config = require('../config')
pubnub = require('pubnub')({
	origin: 'resin.pubnub.com'
	subscribe_key: config.subscribe_key
	publish_key: config.publish_key
})
_ = require 'lodash'
Image = require './image'
Device = require './device'

# The time to wait (per image) for a worker to complete an
# assignment before reassigning it to someone else
ASSIGNMENT_EXPIRATION = 11

Dispatcher =

	idle: true

	work: {
		images: []
		workerAssigned: {}
		distributeInterval: {}
		saveInterval: {}
		workloadModified: false
	}

	workload: {}

	start: (workload) ->
		d = this
		if !d.idle
			return false
		d.idle = false
		d.workload = workload

		publishWorkload = ->
			pubnub.publish({
				channel: 'status'
				message: workload: d.workload
				error: (err) -> console.log(err)
			})

		finishWork = ->
			d.work.workloadModified = false
			clearInterval(d.work.distributeInterval)
			clearInterval(d.work.saveInterval)
			theUltimateResult = _.max(d.workload.results, 'value')
			console.log('The ultimate result is:')
			console.log(theUltimateResult)
			console.log('Total elapsed time: ' + (Date.now() - d.workload.startTime) + 'ms')
			d.workload.finishTime = Date.now()
			d.workload.status = 'Done'
			d.workload.finalResult = theUltimateResult
			d.workload.markModified('finalResult')

			d.workload.save()
			publishWorkload()

			_.defer ->
				pubnub.unsubscribe({
					channel: ['results', 'working']
				})
				d.idle = true


		newWorkingStatus = (m) ->
			if m.progress? && m.progress < 100
				Device.findOne {macAddress: m.device}, (err, device) ->
					if err or !device?
						return err
					device.status = 'Working'
					device.progress = m.progress
					device.save()

		newResults = (m) ->
			console.log('Results')
			console.log(m)
			console.log('Elapsed time: ' + (Date.now() - d.workload.startTime) + 'ms')
			newResult = m.chunkId? && !d.workload.results[m.chunkId]?
			if newResult
				console.log('New result')
				d.workload.results[m.chunkId] = m
				d.workload.numResults += 1
			d.work.workerAssigned[m.device] = null

			Device.findOne {macAddress: m.device}, (err, device) ->
				if err or !device?
					return err
				device.status = 'Idle'
				device.progress = 100
				device.lastElapsedTime = m.elapsedTime
				device.lastProcessed = Date.now()
				device.totalProcessed += d.workload.chunkSize
				device.save()

			d.workload.markModified('results')
			if newResult
				if d.workload.numResults == d.workload.numChunks
					finishWork()
				else
					d.work.workloadModified = true
					publishWorkload()

		distributeAll = (workers) ->
			workerList = _.shuffle(workers.uuids)
			chunkId = 0

			expiredAssignments = _.filter d.workload.assigned, (chunk) ->
				if chunk?
					return !d.workload.results[chunk.chunkId]? && chunk.assignTime < (Date.now() - (d.workload.chunkSize * ASSIGNMENT_EXPIRATION))
				else
					return false

			_.each expiredAssignments, (assignment) ->
				d.workload.assigned[assignment.chunkId] = null
				d.work.workerAssigned[assignment.worker] = null
				d.workload.numAssigned -= 1

			while(chunkId < d.workload.numChunks && workerList.length > 0)
				if (! d.workload.assigned[chunkId]? && ! d.workload.results[chunkId]?)
					if workerList[0].state.status == 'Idle' && ! d.work.workerAssigned[workerList[0].uuid]?
						images = d.work.images[chunkId]
						workSize = images.length
						targetImage = d.workload.targetImage.image.original.path

						pubnub.publish({
							channel: workerList[0].uuid
							message: {
								targetImage
								chunkId
								images
								workSize
							}
							error: (err) -> console.log(err)
						})
						d.workload.assigned[chunkId] = {
							worker: workerList[0].uuid
							assignTime: Date.now()
							chunkId: chunkId
						}
						d.work.workerAssigned[workerList[0].uuid] = chunkId
						d.workload.numAssigned += 1
						chunkId += 1
					_.pullAt(workerList, 0)
				else
					chunkId += 1

			d.workload.markModified('assigned')
			d.work.workloadModified = true
			publishWorkload()


		startDistribution = (workers) ->
			d.workload.startTime = Date.now()

			d.workload.results = []
			d.workload.numResults = 0
			d.workload.status = 'Distributing'
			d.work.workloadModified = true
			publishWorkload()

			pubnub.subscribe({
				channel: 'working'
				message: newWorkingStatus
			})

			pubnub.subscribe({
				channel: 'results'
				message: newResults
			})

			numWorkers = workers.occupancy

			console.log('gonna find images')
			Image.find {target: false}, (err, images) ->
				if err
					console.log(err)
					return err

				d.workload.totalSize = images.length
				d.workload.chunkSize = Math.min( Math.ceil(d.workload.totalSize / numWorkers), 100)
				console.log(d.workload.chunkSize)
				d.workload.numChunks = Math.ceil(d.workload.totalSize / d.workload.chunkSize)

				mappedImages = _.map images, (obj) ->
					return {
						uuid: obj.uuid
						personName: obj.personName
						#id: obj._id
					}

				d.work.images = _.chunk(mappedImages, d.workload.chunkSize)
				d.work.workerAssigned = {}

				d.workload.status = 'Processing'
				distributeAll(workers)
				d.work.distributeInterval = setInterval ->
					pubnub.here_now({
						channel: 'work'
						callback: distributeAll
						state: true
					})
				, 600
				console.log(d.workload.assigned)

		pubnub.here_now({
			channel: 'work'
			callback: startDistribution
			state: true
		})
		d.work.saveInterval = setInterval ->
			if d.work.workloadModified == true
				d.work.workloadModified = false
				d.workload.save()
		, 1000

	stop: ->
		d = this
		d.work.workloadModified = false
		clearInterval(d.work.distributeInterval)
		clearInterval(d.work.saveInterval)
		console.log('The ultimate result is:')
		d.workload.finishTime = Date.now()
		d.workload.status = 'Stopped'
		d.workload.save()
		publishWorkload()

		_.defer ->
			pubnub.unsubscribe({
				channel: ['results', 'working']
			})
			d.idle = true

	warmCache: ->
		Image.count {target: false}, (err, count) ->
			console.log("Will send #{count} images")
			pageSize = 100
			nPages = Math.ceil(count / pageSize)
			_.each [1..nPages], (page) ->
				Image.paginate {target: false}, page, pageSize, (error, pageCount, paginatedResults, itemCount) ->
					console.log('Publishing')

					images = _.map paginatedResults, (obj) ->
						return {
							path: obj.path
							uuid: obj.uuid
							personName: obj.personName
							id: obj._id
						}

					console.log(JSON.stringify(images).length)
					pubnub.publish({
						channel: 'images'
						message: { images, page, nPages }
						error: (err) -> console.log(err)
					})

module.exports = Dispatcher

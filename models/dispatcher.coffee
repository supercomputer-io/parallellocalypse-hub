config = require('../config')
pubnub = require('pubnub')({
	subscribe_key: config.subscribe_key
	publish_key: config.publish_key
})
_ = require 'lodash'
Image = require './image'
Device = require './device'




distributeLoad = (workload, workers) ->
	startTime = Date.now()

	workload.results = []
	workload.numResults = 0
	workload.status = 'Distributing'
	workload.save()

	finishWork = () ->
		theUltimateResult = _.max(workload.results, 'value')
		console.log('The ultimate result is:')
		console.log(theUltimateResult)
		workload.status = "Done"
		workload.finalResult = theUltimateResult
		workload.markModified('finalResult')
		clearInterval(workload.distributeInterval)
		workload.save()

	newWorkingStatus = (m) ->
		if m.progress < 100
			Device.findOne {macAddress: m.device}, (err, device) ->
				if err
					return err
				device.status = 'Working'
				device.progress = m.progress
				device.save()

	newResults = (m) ->
		console.log('Results')
		console.log(m)
		console.log("Took " + (Date.now() - startTime) + "ms")
		workload.results[m.chunkId] = m
		workload.numResults += 1

		Device.findOne {macAddress: m.device}, (err, device) ->
			if err
				return err
			device.status = 'Idle'
			device.progress = 100
			device.lastElapsedTime = m.elapsedTime
			device.lastProcessed = Date.now()
			device.totalProcessed += workload.chunkSize
			device.save()

		workload.markModified('results')
		if workload.numResults == workload.numChunks
			finishWork()
		else
			workload.save()

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
	Image.find({target: false}, (err, images) ->
		if err
			console.log(err)
			return err
		console.log('got images')
		console.log(images.length)
		workload.totalSize = images.length
		workload.chunkSize = Math.min(workload.totalSize / numWorkers, 100)
		console.log(workload.chunkSize)
		workload.numChunks = Math.ceil(workload.totalSize / workload.chunkSize)	
	
		distributeAll = (workers) ->
			workerList = workers.uuids
			console.log("Distributing " + (workload.numChunks - workload.numAssigned) + " chunks between " + workerList.length + " workers.")
			chunkId = 0
			while(workload.numAssigned < workload.numChunks && workerList.length > 0)
				if (! workload.assigned[chunkId]?) or workload.assigned[chunkId].assignTime < (Date.now() - 5000)
					if workerList[0].state.status == 'Idle'
						imgs = _.map images[(chunkId*workload.chunkSize)..((chunkId+1)*workload.chunkSize - 1)], (obj) ->
							return {
								original_img: obj.original_img
								personName: obj.personName
								id: obj._id
							}

						workSize = imgs.length

						pubnub.publish({
							channel: workerList[0].uuid
							message: {
								targetImage: workload.targetImage
								chunkId
								images: imgs
								workSize
							}
						})
						workload.assigned[chunkId] = {
							worker: workerList[0].uuid
							assignTime: Date.now()
						}
						workload.numAssigned += 1
						chunkId += 1
					_.pullAt(workerList, 0)
				else
					chunkId += 1

			workload.markModified('assigned')
			workload.status = 'Processing'
			workload.save()

		distributeAll(workers)
		workload.distributeInterval = setInterval ->
			pubnub.here_now({
				channel: 'work'
				callback: distributeAll
				state: true
			})
		, 1000
		console.log(workload.assigned)
	)

module.exports = {
	start: (workload) ->
		distributeToPresent = () ->
			distribute = _.partial(distributeLoad, workload)
			pubnub.here_now({
				channel: 'work'
				callback: distribute
				state: true
			})

		distributeToPresent()

	warmCache: () ->
		Image.count {target: false}, (err, count) ->
			console.log("Will send #{count} images")
			pageSize = 200
			nPages = Math.ceil(count / pageSize)
			_.each [1..nPages], (page) ->
				Image.paginate {target: false}, page, pageSize, (error, pageCount, paginatedResults, itemCount) ->
					console.log("Publishing")

					images = _.map(paginatedResults,(obj) -> return {original_img: obj.original_img})

					console.log(JSON.stringify(images).length)
					pubnub.publish({
						channel: 'images'
						message: images
						error: (err) -> console.log(err)
					})
}

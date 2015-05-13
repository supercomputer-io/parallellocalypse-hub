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
	workload.status = 'Distributing...'
	workload.save()

	finishWork = () ->
		theUltimateResult = _.max(workload.results, 'value')
		console.log('The ultimate result is:')
		console.log(theUltimateResult)
		workload.finalResult = theUltimateResult
		workload.markModified('finalResult')
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
	
	workerList = workers.uuids
	numWorkers = workers.occupancy

	chunkId = 0

	console.log('gonna find images')
	Image.find({target: false}, (err, images) ->
		if err
			console.log(err)
			return err
		console.log('got images')
		console.log(images.length)
		workload.totalSize = images.length
		workload.chunkSize = Math.min(workload.totalSize / numWorkers, 1000)
		console.log(workload.chunkSize)
		workload.numChunks = workload.totalSize / workload.chunkSize	
	# until workload complete
		distributeAll = (workerList) ->
			while(workload.numAssigned < workload.numChunks && workerList.length > 0)
			
				imgs = images[(chunkId*workload.chunkSize)..((chunkId+1)*workload.chunkSize - 1)]
				workSize = imgs.length

				pubnub.publish({
					channel: workerList[0]
					message: {
						targetImage: workload.targetImage
						chunkId
						images: imgs
						workSize
					}
				})
				workload.assigned[chunkId] = {
					worker: workerList[0]
					assignTime: Date.now()
				}
				chunkId += 1
				workload.numAssigned += 1
				_.pullAt(workerList, 0)
			workload.markModified('assigned')
			workload.status = 'Processing'
			workload.save()

		distributeAll(workerList)
		console.log(workload.assigned)
	)

module.exports = {
	start: (workload) ->
		distributeToPresent = () ->
			distribute = _.partial(distributeLoad, workload)
			pubnub.here_now({
				channel: 'work'
				callback: distribute
			})

		distributeToPresent()

	warmCache: () ->
		Image.count {target: false}, (err, count) ->
			pageSize = 1000
			nPages = Math.ceil(count / pageSize)
			_.each [1..nPages], (page) ->
				Image.paginate {target: false}, page, pageSize, (error, pageCount, paginatedResults, itemCount) ->
					pubnub.publish({
						channel: 'images'
						message: paginatedResults
					})
}

config = require('../config')
pubnub = require('pubnub')({
	subscribe_key: config.subscribe_key
	publish_key: config.publish_key
})
_ = require 'lodash'
Image = require './image'




distributeLoad = (workload, workers) ->
	startTime = Date.now()

	results = []
	numResults = 0

	finishWork = () ->
		theUltimateResult = _.max(results, 'value')
		console.log('The ultimate result is:')
		console.log(theUltimateResult)

	newWorkingStatus = (m) ->
		console.log('Status')
		console.log(m)

	newResults = (m) ->
		console.log('Results')
		console.log(m)
		console.log("Took " + (Date.now() - startTime) + "ms")
		results[m.chunkId] = m
		numResults += 1
		if numResults == workload.numChunks
			finishWork()

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
				chunkId += 1
				workload.assigned[chunkId] = {
					worker: workerList[0]
					assignTime: Date.now()
				}
				workload.numAssigned += 1
				_.pullAt(workerList, 0)

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
}

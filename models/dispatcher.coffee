config = require('../config.json')
pubnub = require('pubnub')({
	subscribe_key: config.subscribe_key
	publish_key: config.publish_key
})
_ = require 'lodash'
Image = require './image'

newWorkingStatus = (m) ->
	console.log('Status')
	console.log(m)

newResults = (m) ->
	console.log('Results')
	console.log(m)

pubnub.subscribe({
	channel: 'working'
	message: newWorkingStatus
})

pubnub.subscribe({
	channel: 'results'
	message: newResults
})


distributeLoad = (workload, workers) ->
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
		while(workload.numAssigned < workload.numChunks && workerList.length > 0)
		
			imgs = images[(chunkId*workload.chunkSize)..((chunkId+1)*workload.chunkSize - 1)]
			workSize = imgs.length

			pubnub.publish({
				channel: workerList[0]
				message: {
					targetImage: { url: workload.targetImage.original_img }
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

		console.log(workload.assigned)
	)
module.exports = {
	start: (targetImage, workload) ->
		distributeToPresent = () ->
			distribute = _.partial(distributeLoad, workload)
			pubnub.here_now({
				channel: 'work'
				callback: distribute
			})
		workload.targetImage = targetImage
		
		distributeToPresent()
}

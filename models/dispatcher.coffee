pubnub = require 'pubnub'
_ = require 'lodash'

pubnub.subscribe({
	channel: 'working'
	message: newWorkingStatus
})

pubnub.subscribe({
	channel: 'results'
	message: newResults
})

start = (targetImage, workload) ->
	workload.targetImage = targetImage
	distribute = _.partial(distributeLoad, workload)
	pubnub.publish({
		channel: 'work'
		message: { targetImage }
	})
	distributeToPresent()

distributeToPresent = () ->
	pubnub.here_now({
		channel: 'work'
		callback: distributeLoad
	})

distributeLoad = (workload, workers) ->
	workerList = workers.uuids
	numWorkers = workers.occupancy

	workload.chunkSize = workload.workSize / numWorkers
	workload.numChunks = workload.totalSize / workload.chunkSize

	# until workload complete
	while(workload.numAssigned < workload.numChunks && workerList.length > 0)
		pubnub.publish({
			channel: workerList[0]
			message: {
				chunkId
				images: []
			}
		})
		workload.assigned[chunkId] = {
			worker: workerList[0]
			assignTime: Date.now()
		}
		workload.numAssigned += 1
		_.pullAt(workerList, 0)


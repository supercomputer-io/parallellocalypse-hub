mongoose = require('mongoose')

Workload = mongoose.model 'workload',
	targetImage: {
		type: mongoose.Schema.Types.ObjectId
		ref: 'image'
	}
	status: String
	chunkSize: Number
	numChunks: Number
	numAssigned:
		type: Number
		default: 0
	numResults:
		type: Number
		default: 0
	assigned: []
	results: []
	finalResult: mongoose.Schema.Types.Mixed

module.exports = Workload

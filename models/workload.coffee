mongoose = require('mongoose');

Workload = mongoose.model 'workload',
	targetImage: mongoose.Schema.Types.ObjectId
	status: String
	chunkSize: Number
	numChunks: Number
	numAssigned:
		type: Number
		default: 0
	assigned: []

module.exports = Workload;
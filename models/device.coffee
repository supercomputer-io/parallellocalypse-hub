mongoose = require('mongoose')

Device = mongoose.model 'device',
	resinId:
		type: String
		unique: true
		required: true
	macAddress:
		type: String
		unique: true
		required: true
	status:
		type: String
		default: 'Idle'
	progress:
		type: Number
		default: 0
	totalProcessed:
		type: Number
		default: 0
	lastElapsedTime:
		type: Number
	lastProcessed:
		type: Date
	location:
		type: mongoose.Schema.Types.Mixed


module.exports = Device

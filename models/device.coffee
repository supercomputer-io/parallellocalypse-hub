mongoose = require('mongoose');

Device = mongoose.model 'device',
	resinId:
		type: String
		unique: true
		required: true
	macAddress:
		type: String
		unique: true
		required: true

module.exports = Device;
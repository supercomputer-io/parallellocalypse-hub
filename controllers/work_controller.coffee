express = require('express')
router = express.Router();
resin = require('resin-sdk')
fs = require('fs')
config = require('../config')

Device = require('../models/device');
Workload = require('../models/workload')
router.post '/work', (req, res) ->
	
	#image uploaded->
	# dispatcher.start(req.files)


module.exports = router

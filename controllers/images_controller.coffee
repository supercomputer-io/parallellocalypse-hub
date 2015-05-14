express = require('express')
router = express.Router()
resin = require('resin-sdk')
fs = require('fs')
config = require('../config')
multer = require('multer')

Device = require('../models/device')
Workload = require('../models/workload')
dispatcher = require '../models/dispatcher'
Image = require('../models/image')

router.use(multer({}))

router.post '/images', (req, res, next) ->

	image = new Image({personName: req.body.name, target: false })

	image.attach 'image', req.files.image, (err) ->
		if(err)
			return next(err)

		image.save (err) ->
			if(err)
				return next(err)
			res.send('OK')



module.exports = router
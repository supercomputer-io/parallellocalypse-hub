express = require('express')
router = express.Router();
resin = require('resin-sdk')
fs = require('fs')
config = require('../config')

Device = require('../models/device');

router.post '/devices', (req, res) ->
	device = new Device(req.body)
	device.save (err) ->
		if err
			res.status(422).send(error: err)
		else
			res.status(201).send(device)

router.get '/devices', (req, res) ->
	Device.find {}, (err, devices) ->
		if(err)
			console.log(err)
			res.status(500).send(error: err)
		else
			res.send(devices)

router.get '/devices/by_mac_address/:mac', (req, res) ->
	Device.find {macAddress: req.params.mac}, (err, device) ->
		if err or !device[0]
			console.log(err) if err
			res.status(404).send(error: "Not found")
		else
			resin.models.device.getByUUID device[0].resinId, (err, resinDevice) ->
				console.log(err) if err?
				device = device[0]
				res.send({ device, resinDevice })

router.get '/devices/:id', (req, res) ->
	Device.find {_id: req.params.id}, (err, device) ->
		if err
			console.log(err)
			res.status(404).send(error: "Not found")
		else
			resin.models.device.getByUUID device[0].resinId, (err, resinDevice) ->
				console.log(err) if err?
				device = device[0]
				res.send({ device, resinDevice })

module.exports = router

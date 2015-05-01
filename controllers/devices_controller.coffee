express = require('express')
router = express.Router();
resin = require('resin-sdk')
fs = require('fs')

Device = require('../models/device');

resin.auth.loginWithToken JSON.parse(fs.readFileSync('token.json', encoding: 'utf-8')).token, (err) ->
	throw err if err?
	console.log('Authenticated with Resin')

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

router.get '/devices/:id', (req, res) ->
	Device.find {_id: req.params.id}, (err, device) ->
		if err
			console.log(err)
			res.status(404).send(error: "Not found")
		resin.models.device.get device[0].resinId, (err, resinDevice) ->
			console.log(err) if err?
			device = device[0]
			res.send({ device, resinDevice })

module.exports = router
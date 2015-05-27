express = require('express')
resin = require('resin-sdk')
fs = require('fs')
config = require('../config')

Device = require('../models/device')

auth = require('./auth_controller')

router = express.Router()

module.exports = (passport) ->

	router.post '/devices', passport.authenticate('device'), (req, res) ->
		Device.findOne {macAddress: req.body.macAddress}, (err, device) ->
			if device?
				device.location = req.body.location
				device.resinId = req.body.resinId
				device.status = req.body.status
			else
				device = new Device(req.body)
			device.save (err) ->
				if err
					res.status(422).send(error: err)
				else
					res.status(201).send(device)

	router.get '/devices/count', (req, res) ->
		Device.count {}, (err, count) ->
			if(err)
				console.log(err)
				res.status(500).send(error: err)
			else
				res.send({ count })

	router.get '/devices', auth.isLoggedIn, (req, res) ->
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
				res.status(404).send(error: 'Not found')
			else
				resin.models.device.getByUUID device[0].resinId, (err, resinDevice) ->
					console.log(err) if err?
					device = device[0]
					res.send({ device, resinDevice })

	router.get '/devices/:id', (req, res) ->
		Device.find {_id: req.params.id}, (err, device) ->
			if err or !device[0]
				console.log(err)
				res.status(404).send(error: 'Not found')
			else
				resin.models.device.getByUUID device[0].resinId, (err, resinDevice) ->
					console.log(err) if err?
					device = device[0]
					res.send({ device, resinDevice })

	return router

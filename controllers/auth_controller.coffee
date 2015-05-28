express = require 'express'
config = require('../config')
router = express.Router()
module.exports = {
	isLoggedIn: (req, res, next) ->
		if req.isAuthenticated()
			return next()
		res.status(401).send({error: 'Not logged in.'})

	router: (passport) ->
		router.post '/login', passport.authenticate('admin'), (req, res, next) ->
			res.redirect('/#/dashboard')
		router.post '/logout', (req, res) ->
			if req.isAuthenticated()
				req.logout()
			res.send({})
		router.get '/who', module.exports.isLoggedIn, (req, res, next) ->
			res.send(req.user.email)
		router.get '/subscribe_key', (req, res) ->
			res.send(config.subscribe_key)


}
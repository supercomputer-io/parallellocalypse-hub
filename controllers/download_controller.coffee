express = require('express')
router = express.Router()

request = require('request')
url = require('url')
config = require('../config')

router.get '/download', (req, res) ->
	parameters = {
		appId: config.appId,
		network: req.params.network
		processorType: req.params.processorType
		coprocessorCore: req.params.coprocessorCore
		hdmi: req.params.hdmi
	}
	if req.params.network == 'wifi'
		parameters.wifiSsid = req.params.wifiSsid
		parameters.wifiKey = req.params.wifiKey

	query = url.format({
		query: parameters
	})
	downloadUrl = url.resolve('https://dashboard.resin.io/download', query)
	options = {
		headers: Authorization: 'Bearer ' + config.token
		url: downloadUrl
	}

	return request.get(options).pipe(res)

module.exports = router

express = require('express')
router = express.Router()

request = require('request')
url = require('url')
config = require('../config')

settings = require('resin-settings-client')

if settings.get("remoteUrl") == 'https://staging.resin.io'
	apiUrl = 'https://api.staging.resin.io'
else
	apiUrl = 'https://api.resin.io'

router.get '/download', (req, res) ->
	parameters = {
		appId: config.appId,
		network: req.query.network
		processorType: req.query.processorType
		coprocessorCore: req.query.coprocessorCore
		hdmi: req.query.hdmi
	}

	if req.query.network == 'wifi'
		parameters.wifiSsid = req.query.wifiSsid
		parameters.wifiKey = req.query.wifiKey

	query = url.format({
		query: parameters
	})
	downloadUrl = url.resolve(apiUrl + '/download', query)
	options = {
		headers: Authorization: 'Bearer ' + config.token
		url: downloadUrl
	}

	return request.get(options).pipe(res)

module.exports = router

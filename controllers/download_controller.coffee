express = require('express')
router = express.Router()

request = require('request')
url = require('url')
config = require('../config')

settings = require('resin-settings-client')

apiUrl = settings.get('remoteUrl')
accepts = require('accepts')

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

router.get '/download/:image', (req, res) ->
	image = req.params.image

	if image is 'Z7010'
		imageName = 'resin-supercomputer-0.1.0-0.0.14-Z7010-16.img'
	else if image is 'Z7020'
		imageName = 'resin-supercomputer-0.1.0-0.0.14-Z7020-16.img'
	else
		return res.sendStatus(404)

	urlPrefix = config.s3.url + 'os/'
	accept = accepts(req)
	if accept.encoding('gzip') is 'gzip'
		urlPrefix += 'gzip/'

	downloadUrl = urlPrefix + imageName
	res.redirect(301, downloadUrl)


module.exports = router

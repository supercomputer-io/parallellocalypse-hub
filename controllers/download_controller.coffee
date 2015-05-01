express = require('express')
router = express.Router();

request = require('resin-request')
url = require('url')
config = require('../config')

router.get '/download', (req, res) ->

    parameters = {
    	appId: config.appId,
    	network: req.params.network
    }
    if req.params.network == 'wifi'
    	parameters.wifiSsid = req.params.wifiSsid
    	parameters.wifiKey = req.params.wifiKey

    query = url.format({
      query: parameters
    })
    downloadUrl = url.resolve('/download', query)
    return request.request
    	method: 'GET',
    	url: downloadUrl,
    	pipe: res
    , (err) ->
    	if(err)
    		console.log(err)
    , (state) -> {}

module.exports = router

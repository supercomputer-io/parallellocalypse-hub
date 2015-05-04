fs = require('fs')
if process.env.NODE_ENV == 'production'
	module.exports = {
		token: process.env.RESIN_TOKEN
		appId: process.env.RESIN_APP_ID
	}
else
	module.exports = JSON.parse(fs.readFileSync('config.json', encoding: 'utf-8'))

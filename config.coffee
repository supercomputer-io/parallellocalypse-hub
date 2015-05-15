fs = require('fs')
if process.env.NODE_ENV == 'production'
	module.exports = {
		token: process.env.RESIN_TOKEN
		appId: process.env.RESIN_APP_ID
		subscribe_key: process.env.PUBNUB_SUB_KEY
		publish_key: process.env.PUBNUB_PUB_KEY
		admin: {
			email: process.env.ADMIN_EMAIL
			password: process.env.ADMIN_PASSWORD
		}
	}
else
	module.exports = JSON.parse(fs.readFileSync('config.json', encoding: 'utf-8'))

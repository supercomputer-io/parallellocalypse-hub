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
		device: {
			secret: process.env.DEVICE_SECRET
		}
		s3: {
			key: process.env.S3_KEY
			secret: process.env.S3_SECRET
			bucket: process.env.S3_BUCKET
			directory: process.env.S3_DIRECTORY
		}
	}
else
	module.exports = JSON.parse(fs.readFileSync('config.json', encoding: 'utf-8'))

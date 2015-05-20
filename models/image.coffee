mongoose = require('mongoose')
attachments = require('mongoose-attachments-aws2js')
autoIncrement = require('mongoose-auto-increment')
config = require('../config')
path = require('path')

ImageSchema = new mongoose.Schema({
	personName: String,
	target: {
		type: Boolean,
		default: false
	},
	uuid: {
		type: Number,
		unique: true
	}
},{
	toJSON: {virtuals: true}
})

ImageSchema.plugin(attachments, {
	directory: config.s3.directory,
	storage: {
		providerName: 'aws2js'
		options: {
			key: config.s3.key,
			secret: config.s3.secret,
			bucket: config.s3.bucket,
			endpoint: 'https://' + config.s3.bucket + '.s3-website-us-east-1.amazonaws.com',
		}
	},
	properties: {
		image: {
			styles: {
				original: {},
				resized: {
					thumbnail: '250x250',
					gravity: 'center',
					extent: '250x250',
					'$format': 'jpg'
				}
			}
		}
	}
})

autoIncrement.initialize(mongoose.connection)
ImageSchema.plugin(autoIncrement.plugin, { model: 'image', field: 'uuid' })
ImageSchema.virtual('path').get ->
	return this.image.original.path

Image = mongoose.model('image', ImageSchema)

module.exports = Image

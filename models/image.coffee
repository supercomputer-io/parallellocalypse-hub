mongoose = require('mongoose')
attachments = require('mongoose-attachments-aws2js')
config = require('../config')
path = require('path')

ImageSchema = new mongoose.Schema({
	personName: String,
	target: {
		type: Boolean,
		default: false
	}
},{
	toJSON: {virtuals: true}
})

ImageSchema.plugin(attachments, {
	directory: 'images',
	storage: {
		providerName: 'aws2js'
		options: {
			key: config.s3.key,
			secret: config.s3.secret,
			bucket: config.s3.bucket
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
ImageSchema.virtual('original_img').get ->
	return path.join('original', path.basename(this.image.original.path))

Image = mongoose.model('image', ImageSchema)

module.exports = Image

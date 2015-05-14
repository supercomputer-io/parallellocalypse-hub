mongoose = require('mongoose')
attachments = require('mongoose-attachments-localfs')
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
	directory: '/home/pablo/resin/parallellocalypse-hub/public/images',
	storage: {
		providerName: 'localfs'
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

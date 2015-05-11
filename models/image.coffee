mongoose = require('mongoose');

Image = mongoose.model 'image',
	personName: String
	url: String

module.exports = Image;
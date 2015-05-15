request = require('superagent').agent()
fs = require('fs')
_ = require('lodash')
config = require('../config')
url = process.env.HUB_URL || 'http://localhost:8080'

basePath = process.env.BASE_PATH

semaphore = 0

sendFile = (path, file, personName) ->
	if semaphore < 100
		semaphore += 1
		req = request.post(url + '/api/images')
		req.field('name', personName).attach('image', basePath + '/' + path + '/' + file)
		req.end (err, res) ->
			if err
				throw err
			console.log(path + '/' + file + ' uploaded.')
			semaphore -= 1
	else
		func = _.partial(sendFile, path, file, personName)
		setTimeout(func, 10)

searchDir = (path) ->
	personName = path.split('_').join(' ')
	console.log(personName)
	fs.readdir basePath + '/' + path, (err, files) ->
		files.forEach (file) ->
			sendFile(path, file, personName)


console.log('Reading dir')

request.post(url + '/login')
.send(config.admin)
.end (err, res) ->
	if res.statusCode == 200
		fs.readdir basePath, (err, directories) ->
			directories.forEach (path) ->
				searchDir(path)
	else
		console.log('Incorrect login')

# This requires the 'convert' executable in PATH
fs = require('fs')
_ = require('lodash')
exec = require('child_process').exec

basePath = process.env.BASE_PATH

semaphore = 0

convertFile = (path, file) ->
	if semaphore < 100

		fileparts = file.split('.')
		fileName = fileparts[0]
		fileExt = fileparts[1]
		if fileExt == 'jpg'
			semaphore += 1
			console.log('Converting ' + file)
			exec "convert #{file} #{fileName}.bmp", {cwd: basePath + '/' + path}, (err) ->
				semaphore -= 1
				if err
					console.log(err)
				else
					if process.env.REMOVE_JPGS
						fs.unlinkSync(basePath + '/' + path + '/' + file)
					console.log('Converted ' + file)
	else
		func = _.partial(convertFile, path, file)
		setTimeout(func, 10)

searchDir = (path) ->
	fs.readdir basePath + '/' + path, (err, files) ->
		files.forEach (file) ->
			convertFile(path, file)

console.log('Reading dir')
fs.readdir basePath, (err, directories) ->
	directories.forEach (path) ->
		searchDir(path)

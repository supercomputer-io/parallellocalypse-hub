mongoose = require('mongoose')
express = require('express')
server = require('http').createServer(app)
bodyParser = require('body-parser')
resin = require('resin-sdk')
config = require('./config')

mongooseURL = process.env.MONGOLAB_URI or process.env.MONGOHQ_URL or 'mongodb://localhost/parallellocalypse'
mongoose.connect mongooseURL, (err) ->
	if err
		throw err
	console.log("Connected to MongoDB")

token = config.token

resin.auth.loginWithToken token, (err) ->
	throw err if err?
	console.log('Authenticated with Resin')

port = process.env.PORT or 8080
app = express()
app.use(bodyParser())
app.use(express.static(__dirname + '/public'))
app.use(require('./controllers/devices_controller'))
app.use(require('./controllers/download_controller'))

app.listen port, ->
	console.log("Server listening on port #{port}")

express = require('express')
router = express.Router()

request = require('superagent')
url = require('url')
config = require('../config')

nodemailer = require('nodemailer')

transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        user: config.mailer.user,
        pass: config.mailer.pass
    }
})

router.post '/contact', (req, res) ->
	console.log(req.body)
	console.log(config.recaptchaSecret)
	console.log(req.body['g-recaptcha-response'])
	request.post('https://www.google.com/recaptcha/api/siteverify')
	.send("secret=#{config.recaptchaSecret}")
	.send("response=#{req.body['g-recaptcha-response']}")
	.end (err, resp) ->
		if resp.body.success == true
			mailOptions = {
			    from: config.mailer.user,
			    to: config.mailer.recipients,
			    subject: 'supercomputer.io contact form',
			    text: "Email: #{req.body.email}, Name: #{req.body.name}\n\nMessage:\n#{req.body.message}"
			}

			transporter.sendMail mailOptions, (error, info) ->
				if (error)
					return console.log(error)
				console.log('Message sent: ' + info.response);


			res.send({error: null})
		else
			res.send({error: "Invalid captcha"})

module.exports = router

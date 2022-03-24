import { HelpPage } from './app/screens/HelpPage'
import "dotenv/config";
import express from 'express'
import index from './app/index.html'

const app = express!

app.get '/help' do(req, res)
	res.send String <html> <body>
		<HelpPage>

# catch-all route that returns our index.html
app.get(/.*/) do(req,res)
	# only render the html for requests that prefer an html response
	unless req.accepts(['image/*', 'html']) == 'html'
		return res.sendStatus(404)

	res.send index.body

imba.serve app.listen(process.env.PORT or 3000)
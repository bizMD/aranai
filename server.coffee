require 'sugar'
fs = require 'fs'
path = require 'path'
domain = require 'domain'
google = require 'google'
restify = require 'restify'

# Require the marko adapter
require('marko/node-require').install();

# Activate the domain
d = domain.create()
d.run ->

	# Create the web server and use middleware
	server = restify.createServer name: 'Aranai'
	server.use restify.gzipResponse()
	server.use restify.bodyParser()
	server.use restify.queryParser()
	server.pre restify.pre.sanitizePath()
	server.use restify.CORS()
	server.use restify.fullResponse()

	# Serve routes
	server.get '/', (req, res, next) ->
		res.writeHead 200, {'Content-Type': 'text/html; charset=utf-8'}
		template = path.resolve 'pages', '2-home', 'marko', 'template.marko'
		view = require template
		view.render {}, res
		#file = fs.createReadStream template
		#file.pipe res

	server.get '/home/css', (req, res, next) ->
		res.writeHead 200, {'Content-Type': 'text/css'}
		template = path.resolve 'pages', '2-home', 'sass', 'styles.min.css'
		file = fs.createReadStream template
		file.pipe res

	server.get '/home/js', (req, res, next) ->
		res.writeHead 200, {'Content-Type': 'application/javascript'}
		template = path.resolve 'pages', '2-home', 'coffee', 'index.min.js'
		file = fs.createReadStream template
		file.pipe res

	server.get '/request', (req, res, next) ->
		res.writeHead 200, {'Content-Type': 'application/json'}
		crawl = req.params.crawl
		google.resultsPerPage = 20

		google crawl, (err, resp) ->
			if err
				res.write "{error:true}"
				res.end()
				next()
			else
				obj = []
				obj.push {title:title, link:link} for {title, link} in resp.links when title isnt '' and !!link is true and obj.length < 10
				res.write JSON.stringify obj
				res.end()
				next()

	# After each operation, log if there was an error
	server.on 'after', (req, res, route, error) ->
		console.log "======= After call ======="
		console.log "Error: #{error}"
		console.log "=========================="

	# Log when the web server starts up
	server.listen 7000, -> console.log "#{server.name}[#{process.pid}] online: #{server.url}"
	console.log "#{server.name} is starting..."

d.on 'error', (error) ->
	console.warn error
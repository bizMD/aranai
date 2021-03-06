# Require the dependencies
# ------------------------
# These are either out of the box dependencies, or helpful NPM packages

fs = require 'fs'
path = require 'path'
domain = require 'domain'
google = require 'google'
restify = require 'restify'


# Require the marko adapter
# -------------------------
# This dependency allows for the use of MarkoJS to require marko files

require('marko/node-require').install();

# Activate the domain
# -------------------
# A domain is used to catch any asynchronous errors that show up in our code

d = domain.create()
d.run ->

	# Create the web server and use middleware
	# ----------------------------------------
	# The following sets up the web server using Restify's out of the box middleware.
	# This makes it easy for us to grab and serve info to any client.
	
	server = restify.createServer name: 'Aranai'
	server.use restify.gzipResponse()
	server.use restify.bodyParser()
	server.use restify.queryParser()
	server.pre restify.pre.sanitizePath()
	server.use restify.CORS()
	server.use restify.fullResponse()

	# Serve routes
	# ------------
	# There are four routes in use:
	# - The home page, serving the HTML

	server.get '/', (req, res, next) ->
		res.writeHead 200, {'Content-Type': 'text/html; charset=utf-8'}
		template = path.resolve 'pages', '2-home', 'marko', 'template.marko'
		view = require template
		view.render {}, res

	# - The CSS styles for the home page
	
	server.get '/home/css', (req, res, next) ->
		res.writeHead 200, {'Content-Type': 'text/css'}
		template = path.resolve 'pages', '2-home', 'sass', 'styles.min.css'
		file = fs.createReadStream template
		file.pipe res

	# - The JS file for the home page
	
	server.get '/home/js', (req, res, next) ->
		res.writeHead 200, {'Content-Type': 'application/javascript'}
		template = path.resolve 'pages', '2-home', 'coffee', 'index.min.js'
		file = fs.createReadStream template
		file.pipe res

	# - The request path, which takes in a request from the homepage, crawls Google, then returns the result

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

# Catch the error in the domain
d.on 'error', (error) ->
	console.warn error
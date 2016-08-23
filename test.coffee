require 'sugar'

google = require 'google'
google.resultsPerPage = 10

google 'critical role', (err, res) ->
	if err then console.error err
	#console.log "#{title}" for {title, link, description} in res.links
	console.log Object.keys res
	console.log res.links
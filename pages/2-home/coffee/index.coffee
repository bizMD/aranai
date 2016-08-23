require 'sugar'
$ = require 'jquery'

$('.searchBar button').click (event) ->
	event.preventDefault()
	input = $('.searchBar input').val()
	table = $ '.tableBody'

	# First, hide the table
	# Then, clear the table
	table.slideUp () ->
		$ '.tables tbody'
			.empty()


	$.get "/request?crawl=#{input}", (data) ->
		for item, index in data
			$ '.tables tbody:last-child'
				.append "<tr><td>#{item.title}</td><td>#{item.link}</td></tr>"

			# Then, show the table
			if index == 9 then table.slideDown()
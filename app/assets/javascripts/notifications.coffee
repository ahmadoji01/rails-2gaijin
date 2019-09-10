App.room = App.cable.subscriptions.create "WebNotificationsChannel",
	
	connected: ->

	received: (data) ->
		$('#notification div').append '<li>' + data['notification'] + '</li>'
		$('#notifications-count,.notifications-count').text data['count']


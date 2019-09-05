App.room = App.cable.subscriptions.create "WebNotificationsChannel",
	
	connected: ->
		console.log("Connected")

	received: (data) ->
		$('#notification div').append '<li>' + data['notification'] + '</li>'
		$('#notifications-count,.notifications-count').text data['count']


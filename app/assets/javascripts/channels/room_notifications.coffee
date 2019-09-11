jQuery(document).on 'turbolinks:load', ->
	App.room_notifications = App.cable.subscriptions.create "RoomNotificationsChannel",
  		connected: ->

  		disconnected: ->
    		# Called when the subscription has been terminated by the server

  		received: (data) ->
  			$("#msg-notif-num").html(data.unreadrooms)
$(document).ready( function() {

	$('[data-channel-subscribe="message"]').each(function(index, element) {
		var $element = $(element);

		App.cable.subscriptions.create(
	    {
	      channel: "RoomNotificationsChannel"
	    },
	    {
	      received: function(data) {
	      	var messageBarHTML = this.messageBar(data);
	        var barID = "#room-bar-" + data.roomid;

	        if(data.roomname != null) {
	        	$("#msg-notif-num").addClass("beep");
				$("#msg-md-notif-num").addClass("beep");
		        $(barID).remove();
		        $element.prepend(messageBarHTML);
		        $('#msg-notif-num').text(data.unreadrooms);
		        $('#msg-md-notif-num-text').text(data.unreadrooms);
		        
		        $('[data-channel-subscribe="room"]').each(function(index, element) {
		        	var counter = parseInt($('#msg-notif-num').text());
		        	counter--; $('#msg-notif-num').text(counter);
		        });
	    	}
	      },

	      messageBar: function(data) {
	      	return '<a href="'+ data["roompath"] +'" id="room-bar-'+ data["roomid"] +'" class="dropdown-item" data-room-order=""><div class="dropdown-item-avatar"><img src="' + data["avatar"] + '" class="rounded-circle" width="30" alt="image"></div><div class="dropdown-item-desc"><b class="msg_name">' + data["roomname"] + '</b><div class="text-success text-small font-600-bold" style="float: right;"><i class="fas fa-circle"></i></div><div class="msg_time time">' + moment(data["time"]).calendar() + '</div></div></a>';
	      }
	    }
  		);
	});
});
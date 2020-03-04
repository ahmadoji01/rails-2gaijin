$(document).ready( function() {

	$('[data-channel-subscribe="room"]').each(function(index, element) {
		var $element = $(element),
        room_id = $element.data('room-id'),
        current_user_id = $element.data('user-id'),
        another_user_id = $element.data('another-user-id');

		App.cable.subscriptions.create("AppearanceChannel", {
			received: function(data) {
				if(data.user == another_user_id){
					if(data.type == "CO_USER") {
						$("#active-status-msg").text("Online Now");
						$("#active-status-div").removeClass("text-muted");
						$("#active-status-div").addClass("text-success");
					} else {
						$("#active-status-msg").text("Offline");
						$("#active-status-div").removeClass("text-success");
						$("#active-status-div").addClass("text-muted");
					}
				}
			}
		});
	});
});
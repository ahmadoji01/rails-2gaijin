$(document).ready( function() { 
	$("#msg-nav").click( function() {
		$.ajax({
			type: "POST", 
			url: "/notifications/set_message_read",
			success: function(data){
				$("#msg-notif-num").removeClass("beep");
				$("#msg-md-notif-num").removeClass("beep");
			}
		})
	});
	
	$("#notif-nav").click( function() {
		$.ajax({
			type: "POST", 
			url: "/notifications/set_notif_read",
			success: function(data) {
				$("#total-notif-number").removeClass("beep");
				$("#total-md-notif-number").removeClass("beep");
			}
		})
	});
});
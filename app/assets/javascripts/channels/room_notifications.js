$(document).ready( function() {

	App.cable.subscriptions.create(
    {
      channel: "RoomNotificationChannel"
    },
    {
      received: function(data) {
       
      }
    }
  );

});
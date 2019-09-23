jQuery(document).on('turbolinks:load', function() {

	App.cable.subscriptions.create(
    {
      channel: "NotificationChannel"
    },
    {
      received: function(data) {
       
      }
    }
  );

});
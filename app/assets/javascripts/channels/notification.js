$(document).ready( function() {

  /*$('.time_date').each(function(index, element) {
    var $element = $(element);
    var formattedDate = moment($element.html()).calendar();
    $element.html(formattedDate);
  });*/

  $('#msg-nav').click(function() {
    console.log($('#msg-notif-beep'));
  });

  $('[data-channel-subscribe="notification"]').each(function(index, element) {
    var $element = $(element),
        current_user_id = $element.data('user-id'),
        notifTemplate = $('[data-role="notif-template"]');     

    App.cable.subscriptions.create("NotificationChannel",
      {
        received: function(data) {
          var msgDate = moment(data.created_at).calendar();
          var content = notifTemplate.children().clone(true, true);
          content.find('[data-role="notif-title"]').text(data.name);
          content.find('[data-role="notif-time"]').text(msgDate);
          content.find('[data-role="notif-link"]').attr('href', data.link);
          
          $element.prepend(content);
          $('#total-notif-number').text(data.unreadnotifs);
        }
      }
    );
  });
});
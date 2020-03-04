$(document).ready( function() {

  $('.time_date').each(function(index, element) {
    var $element = $(element);
    var formattedDate = moment($element.html()).calendar();
    $element.html(formattedDate);
  });

  $('[data-channel-subscribe="room"]').each(function(index, element) {
    var $element = $(element),
        room_id = $element.data('room-id'),
        current_user_id = $element.data('user-id'),
        outgoingMsgTemplate = $('[data-role="outgoing-message-template"]'),
        messageTemplate = $('[data-role="message-template"]');

    $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000);        

    App.cable.subscriptions.create(
      {
        channel: "RoomChannel",
        room: room_id
      },
      {
        received: function(data) {
          var msgDate = moment(data.created_at).calendar();
          var msgHTML = $.parseHTML(data.message);
          if( current_user_id == data.user_id.$oid ) {
            var content = outgoingMsgTemplate.children().clone(true, true);
            content.find('[data-role="outgoing-message-text"]').append(msgHTML);
            content.find('[data-role="outgoing-message-date"]').text(msgDate);
          } else {
            var content = messageTemplate.children().clone(true, true);
            content.find('[data-role="user-avatar"]').attr('src', data.user_avatar_url);
            content.find('[data-role="message-text"]').append(msgHTML);
            content.find('[data-role="message-date"]').text(msgDate);
          }

          $('.active_msg_time').each(function(index, element) {
            var $element = $(element);
            $element.html(msgDate);
          });
          
          $('.write_msg').val("");
          $element.append(content);
          $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000);
        }
      }
    );
  });
});
$(function() {
  $('[data-channel-subscribe="room"]').each(function(index, element) {
    var $element = $(element),
        room_id = $element.data('room-id'),
        current_user_id = $element.data('user-id'),
        outgoingMsgTemplate = $('[data-role="outgoing-message-template"]');
        messageTemplate = $('[data-role="message-template"]');

    $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000)        

    App.cable.subscriptions.create(
      {
        channel: "RoomChannel",
        room: room_id
      },
      {
        received: function(data) {
          if( current_user_id == data.user_id.$oid ) {
            var content = outgoingMsgTemplate.children().clone(true, true);
            content.find('[data-role="outgoing-message-text"]').text(data.message);
            content.find('[data-role="outgoing-message-date"]').text(data.created_at);
          } else {
            var content = messageTemplate.children().clone(true, true);
            content.find('[data-role="user-avatar"]').attr('src', data.user_avatar_url);
            content.find('[data-role="message-text"]').text(data.message);
            content.find('[data-role="message-date"]').text(data.created_at);
          }
          $('.write_msg').val("");
          $element.append(content);
          $element.animate({ scrollTop: $element.prop("scrollHeight")}, 1000);
        }
      }
    );
  });
});
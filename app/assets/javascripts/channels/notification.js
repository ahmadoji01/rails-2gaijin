$(document).ready( function() {

  /*$('.time_date').each(function(index, element) {
    var $element = $(element);
    var formattedDate = moment($element.html()).calendar();
    $element.html(formattedDate);
  });*/

  $('[data-channel-subscribe="notification"]').each(function(index, element) {
    var $element = $(element),
        current_user_id = $element.data('user-id'),
        notifTemplate = $('[data-role="notif-template"]');     

    App.cable.subscriptions.create("NotificationChannel",
      {
        received: function(data) {
          var notifBarHTML = this.notifBar(data);
          var barID = "#notif-bar-" + data.notifid;

          if(data.action == "Add") {
            $element.prepend(notifBarHTML);
            $("#total-notif-number").addClass("beep");
            $("#total-md-notif-number").addClass("beep");
            $('#total-notif-number').text(data.unreadnotifs);
            $('#total-md-notif-number').text(data.unreadnotifs);
          } 
          else if(data.action == "Delete") {
            $(barID).remove();
            $('#total-notif-number').text(data.unreadnotifs);
            $('#total-md-notif-number').text(data.unreadnotifs);
          }
        },

        notifBar: function(data) {
          return `
          <a href="${data["link"]}" id="notif-bar-${data["notifid"]}" class="dropdown-item" data-room-order="">
              <div class="dropdown-item-avatar">
                <img src="${data["image_url"]}" class="rounded-circle" style="width: 30px; height: 30px; object-fit: cover" alt="image">
              </div>
              <div class="dropdown-item-desc">
                  <b class="msg_name">${data["name"]}</b>
                    <div class="text-success text-small font-600-bold" style="float: right;">
                        <i class="fas fa-circle"></i>
                    </div>
                  <div class="msg_time time">${moment(data["time"]).calendar()}</div>
              </div>
          </a>
        `;
        }
      }
    );
  });
});
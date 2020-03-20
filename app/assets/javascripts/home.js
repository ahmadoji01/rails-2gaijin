$(document).ready(function() { 

    var target = document.location.hash.replace("#", "");
    if (target.length) {
        if(target=="delivery"){
        	if( $("#signed-in-token").html() == "Signed In" ) {
          		showModal();
        	} else {
        		window.location = $("#signed-in-token").html();
        	}
        } else if(target=="deliverySuccess"){
            swal("Order Successfully Received!", "We will notify our member immediately!", "success");
        } else if(target=="ticketSuccess"){
            swal("Ticket Successfully Received!", "We will notify our member immediately!", "success");
        } else if(target=="deliveryRemoved"){
            swal("Order Successfully Removed!", "We will notify our member immediately!", "success");
        } else if(target=="jobSuccess"){
            swal("Job Application Successfully Received!", "We will notify our partner immediately! The response will be sent via your email", "success");
        } else if(target=="offerAccepted"){
            swal("Offer Successfully Accepted!", "You can proceed with the delivery on the defined date!", "success")
        } else if(target=="offerRejected"){
            swal("Offer Successfully Rejected!", "You have successfully rejected the delivery order!", "success")
        }
    }

    function showModal(){
        $('#deliveryModal').modal('show');
    }

    if($(".datetimepicker").length) {
        $(".datetimepicker").flatpickr({
            enableTime: true,
            minTime: "09:00"
        });
    } else if($(".datepicker").length) {
        $(".datepicker").flatpickr();
    }
    
    $(".delivery_btn").click( function() {
        var method = $(this).attr("data-method");
        var del_btn = $(this);
        var url = "/" + method;
        $.ajax({
            type: "POST",
            beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))}, 
            url: url,
            dataType:'json',
            data:{
                id: $(this).attr("data-id")
            },
            success: function(data) {
                if(method == "add_to_delivery") {
                    swal("Successfully Added!", "Your item is successfully added to your delivery!", "success");
                    var counter = parseInt($('#del-notif-num').text());
                    counter++; 
                    $('#del-notif-num').text(counter);
                    $('#del-md-notif-num-text').text(counter);
                    
                    if($("#locale-token").length) {
                        var lang = $("#locale-token").html();
                        if(lang == "en")
                            $("#delivery_text").text("Remove from Delivery");
                        else if(lang == "zh-CN")
                            $("#delivery_text").text("从物流列表中移除");
                        else
                            $("#delivery_text").text("Remove from Delivery");
                    }
                    
                    del_btn.removeClass("btn-outline-primary");
                    del_btn.addClass("btn-outline-danger");
                    del_btn.attr("data-method", "remove_from_delivery");
                } else {
                    swal("Successfully Removed!", "Your item is successfully removed from your delivery!", "success");
                    var counter = parseInt($('#del-notif-num').text());
                    counter--;
                    $('#del-notif-num').text(counter);
                    $('#del-md-notif-num-text').text(counter);

                    if($("#locale-token").length) {
                        var lang = $("#locale-token").html();
                        if(lang == "en")
                            $("#delivery_text").text("Add to Delivery");
                        else if(lang == "zh-CN")
                            $("#delivery_text").text("添加到物流列表");
                        else
                            $("#delivery_text").text("Add to Delivery");
                    }

                    del_btn.removeClass("btn-outline-danger");
                    del_btn.addClass("btn-outline-primary");
                    del_btn.attr("data-method","add_to_delivery");
                }
            }
        })
    });

    $("img").lazyload();
});

function removeItemDelivery(productID) {
    $.ajax({
        type: "POST",
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        url: "/remove_from_delivery",
        dataType:'json',
        data:{
            id: productID
        },
        success: function(data){
            $('#del-product-' + productID).fadeOut();
            var counter = parseInt($('#del-notif-num').text());
            counter--;
            $('#del-notif-num').text(counter);
            $('#del-md-notif-num-text').text(counter);
        }
    });
}
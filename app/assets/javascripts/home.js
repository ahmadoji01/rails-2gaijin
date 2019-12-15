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
        }
    }

    function showModal(){
        $('#deliveryModal').modal('show');
    }

    $(".datetimepicker").flatpickr({
        enableTime: true,
        minTime: "09:00"
    });

    $("img").lazyload();
});
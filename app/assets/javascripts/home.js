$(document).ready(function() { 

    var target = document.location.hash.replace("#", "");
    if (target.length) {
        if(target=="delivery"){
        	if( $("#signed-in-token").html() == "Signed In" ) {
          		showModal();
        	} else {
        		window.location = $("#signed-in-token").html();
        	}
        }
    }

    function showModal(){
        $('#deliveryModal').modal('show');
    }

    $('.carousel').carousel('pause');

    $(".datetimepicker").flatpickr({
        enableTime: true,
        minTime: "09:00"
    });

    $("img").lazyload();
});
"use strict";

$(document).ready( function() {
    $('#select2').select2();
    $('.singleselect2').select2({
        minimumResultsForSearch: Infinity
    });
    $('.multiselect2').select2();
    $('#city').select2({
        width: 'resolve'
    });
    $('#condition').select2();
});

$('#menu-profile a').on('click', function (e) {
  e.preventDefault()
  $(this).tab('show')
});

$(document).ready(function(){
	var active = 0; 
    $('.extending-fab').rippleria({
        duration: 750,
        easing: 'linear',
        color: undefined,
        detectBrightness: true
    });
    $("#extending-fab").hover(function(){
        $("#extending-fab-text").removeClass("hidden");
        setTimeout(function() {
  			active = 1;
		}, 100);
    }, function() {
        $("#extending-fab-text").addClass("hidden");
        active = 0;
    });
    $('#extending-fab').click( function() {
        if(active) {
        	window.location = $("#extending-fab").data('new-product-path');
        	active = 0;
        }
    });
    if($(".dropdown-toggle").length)
        $(".dropdown-toggle").dropdown();
});

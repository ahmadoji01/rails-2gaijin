"use strict";

$(document).ready( function() {
    $('#select2').select2();
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

$('.dropdown-toggle').dropdown();
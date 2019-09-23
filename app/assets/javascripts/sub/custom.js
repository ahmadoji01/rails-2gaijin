"use strict";

$(document).ready(function() {
    $('#select2').select2();
    $('.multiselect2').select2();
});

$(document).ready(function() {
    $('#city').select2({
        width: 'resolve'
    });
});

$(document).ready(function() {
    $('#condition').select2();
});

$('#menu-profile a').on('click', function (e) {
  e.preventDefault()
  $(this).tab('show')
});

$('.dropdown-toggle').dropdown();

/*$('.bootstrap-date-picker').bootstrapMaterialDatePicker({ weekStart : 0, time: false }, moment());
$('.bootstrap-time-picker').bootstrapMaterialDatePicker({ date: false }, moment());*/
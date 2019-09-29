"use strict";

$(document).ready( function() {
    $('#select2').select2();
    $('.multiselect2').select2();
    $('#city').select2({
        width: 'resolve'
    });
    $('#condition').select2();

    var config = {
      target: 'delivery-date',
      future: true,
      smartHours: true,
      years: {
        min: 2019,
        max: 2030,
        step: 1
      }
    };
    var myDatepicker = new MtrDatepicker(config);
    $("#delivery-date-input").val(myDatepicker.toISOString());

    myDatepicker.onChange('time', function() {
      var datepickerOutput = myDatepicker.toLocaleString();
      $("#delivery-date-input").val(myDatepicker.toISOString());
    });
});

$('#menu-profile a').on('click', function (e) {
  e.preventDefault()
  $(this).tab('show')
});

$('.dropdown-toggle').dropdown();
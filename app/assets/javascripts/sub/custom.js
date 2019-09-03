"use strict";

$(document).ready(function() {
    $('#select2').select2();
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

var cleave = new Cleave('.currency', {
    numeral: true,
    numeralThousandsGroupStyle: 'thousand'
});

// $('#top-product').owlCarousel({
//         autoplay:false,
//         responsiveClass:true,
//         items : 1, //10 items above 1000px browser width
//         responsive:{
//             0:{
//                 items:1,
//                 nav:true
//             },
//             480:{
//                 items:2,
//                 nav:true
//             },
//             768:{
//                 items:1,
//                 nav:true
//             },
//             1000:{
//                 items:1,
//                 nav:true,
//             }
//         }
//     });

$('#checkoutModal').modal('toggle');



"use strict";

//homepage

$(document).ready( function() {
  $("#home-products-carousel").owlCarousel({
    stagePadding: 0,
    items: 1,
    margin: 5,
    autoplay: true,
    autoplayTimeout: 3000,
    loop: true,
    responsive: {
      0: {
        items: 1
      },
      320: {
        items: 3
      },
      768: {
        items: 5
      },
      1200: {
        items: 6
      }
    }
  });
  $("#products-carousel").owlCarousel({
    stagePadding: 0,
    items: 1,
    margin: 5,
    autoplay: true,
    autoplayTimeout: 3000,
    loop: false,
    responsive: {
      0: {
        items: 1
      },
      320: {
        items: 3
      },
      768: {
        items: 5
      },
      1200: {
        items: 6
      }
    }
  });
  $("#products-carousel-2").owlCarousel({
    stagePadding: 0,
    items: 1,
    margin: 5,
    autoplay: true,
    autoplayTimeout: 3000,
    loop: false,
    responsive: {
      0: {
        items: 1
      },
      320: {
        items: 3
      },
      768: {
        items: 5
      },
      1200: {
        items: 6
      }
    }
  });
});

$("#promos-2gaijin").owlCarousel({
  items: 1,
  singleItem: true,
  autoplay: true,
  autoplayTimeout: 5000,
  loop: true,
});

//product page

$("#related-carousel").owlCarousel({
  items: 5,
  margin: 5,
  autoplay: true,
  autoplayTimeout: 3000,
  // loop: true,
  nav: true
});

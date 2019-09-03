"use strict";

//homepage

$("#products-carousel").owlCarousel({
  items: 6,
  margin: 10,
  autoplay: true,
  autoplayTimeout: 3000,
  loop: true,
  responsive: {
    0: {
      items: 1
    },
    320: {
      items: 1
    },
    768: {
      items: 2
    },
    1200: {
      items: 6
    }
  }
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
  margin: 10,
  autoplay: true,
  autoplayTimeout: 3000,
  // loop: true,
  nav: true
});

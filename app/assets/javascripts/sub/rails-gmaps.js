/*handler = Gmaps.build('Google');
handler.buildMap({ provider: {}, internal: {id: 'basic_map'}}, function(){
  markers = handler.addMarkers([
    {
      "lat": 43.0664199,
      "lng": 141.3409724,
      "infowindow": "hello!"
    }
  ]);
  handler.bounds.extendWith(markers);
  handler.fitMapToBounds();
});*/

/*jQuery(function() {
  var completer;

  completer = new GmapsCompleter({
    inputField: '#gmaps-input-address',
    errorField: '#gmaps-error'
  });

  completer.autoCompleteInit({
    country: "us"
  });
});*/
function initMap() {
  var map = new google.maps.Map(document.getElementById('product-map'), {
    center: {lat: 43.0779575, lng: 141.337819},
    zoom: 13,
    panControl:true,
    zoomControl:true,
    mapTypeControl:false,
    scaleControl:true,
    streetViewControl:false,
    overviewMapControl:false,
    rotateControl:true
  });

  var input = document.getElementById('pac-input');
  var geocoder = new google.maps.Geocoder();
  
  $("#pac-autolocate")[0].onclick = function() {
    // Try HTML5 geolocation.
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        var pos = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };

        map.setCenter(pos);
        map.setZoom(17);
        marker.setPosition(pos);
        marker.setVisible(true);
        $("#address-lat-2").val(pos.lat);
        $("#address-long-2").val(pos.lng);
        geocoder.geocode({"latLng": pos}, function(results, status) {
          if (status === google.maps.GeocoderStatus.OK) {
            if (results[0]) {
              var place = results[0];
              input.value = place.formatted_address;
            } 
          }
        });
      });
    }
  };

  var autocomplete = new google.maps.places.Autocomplete(input);

  // Bind the map's bounds (viewport) property to the autocomplete object,
  // so that the autocomplete requests use the current map bounds for the
  // bounds option in the request.
  autocomplete.bindTo('bounds', map);

  // Set the data fields to return when the user selects a place.
  autocomplete.setFields(
      ['address_components', 'geometry', 'icon', 'name']);

  var marker = new google.maps.Marker({
    map: map,
    anchorPoint: new google.maps.Point(0, -29),
    draggable: true
  });

  marker.addListener('dragend', function() {
    geocoder.geocode({"latLng": marker.position}, function(results, status) {
      if (status === google.maps.GeocoderStatus.OK) {
        if (results[0]) {
          var place = results[0];
          $("#address-lat-2").val(place.geometry.location.lat());
          $("#address-long-2").val(place.geometry.location.lng());
          input.value = place.formatted_address;
        } else {
          // alert("No results found");
        }
      } else {
        // alert("Geocoder failed due to: " + status);
      }
    });
  });



  autocomplete.addListener('place_changed', function() {
    marker.setVisible(false);
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      // User entered the name of a Place that was not suggested and
      // pressed the Enter key, or the Place Details request failed.
      window.alert("No details available for input: '" + place.name + "'");
      return;
    }

    // If the place has a geometry, then present it on a map.
    if (place.geometry.viewport) {
      map.fitBounds(place.geometry.viewport);
    } else {
      map.setCenter(place.geometry.location);
      map.setZoom(17);  // Why 17? Because it looks good.
    }
    marker.setPosition(place.geometry.location);
    marker.setVisible(true);
    $("#address-lat-2").val(place.geometry.location.lat());
    $("#address-long-2").val(place.geometry.location.lng());

    var address = '';
    if (place.address_components) {
      address = [
        (place.address_components[0] && place.address_components[0].short_name || ''),
        (place.address_components[1] && place.address_components[1].short_name || ''),
        (place.address_components[2] && place.address_components[2].short_name || '')
      ].join(' ');
    }
  });
}

$(document).ready( function() {
  
  if($("#product-map").length)
    initMap();
  
  var geocoder = new google.maps.Geocoder();

  var autocomplete = new google.maps.places.Autocomplete($("#item-loc-input")[0]);
  $("#item-autolocate")[0].onclick = function() {
      // Try HTML5 geolocation.
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
          var pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          };
          geocoder.geocode({"latLng": pos}, function(results, status) {
            if (status === google.maps.GeocoderStatus.OK) {
              if (results[0]) {
                var place = results[0];
                $("#item-loc-input").val(place.formatted_address);
              } 
            }
          });
        });
      }
    };

  $(document).on('cocoon:after-insert', function(e, added_item) {
    var itemSizes = $('#delivery_form').find("[data-field='item-size']");
    var locInput = added_item.find("#item-loc-input");
    var autoLocate = added_item.find("#item-autolocate");
    var autocomplete = new google.maps.places.Autocomplete(locInput[0]);
    autoLocate[0].onclick = function() {
      // Try HTML5 geolocation.
      if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(function(position) {
          var pos = {
            lat: position.coords.latitude,
            lng: position.coords.longitude
          };
          geocoder.geocode({"latLng": pos}, function(results, status) {
            if (status === google.maps.GeocoderStatus.OK) {
              if (results[0]) {
                var place = results[0];
                locInput.val(place.formatted_address);
              } 
            }
          });
        });
      }
    };
  });

  $("#pac-input").keypress(function(e) {
    var code = (e.keyCode ? e.keyCode : e.which);
    if(code == 13) { //Enter keycode
        return false;
    }
  });
});
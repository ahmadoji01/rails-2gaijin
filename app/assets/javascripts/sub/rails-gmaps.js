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

  var pickerMap = new google.maps.Map(document.getElementById('picker_map'), {
    center: {lat: 43.0664199, lng: 141.3409724},
    zoom: 13
  });

  var routeMap = new google.maps.Map(document.getElementById('route_map'), {
    center: {lat: 43.0664199, lng: 141.3409724},
    zoom: 13
  });

  var input = document.getElementById('item-loc-input');
  var autocomplete = new google.maps.places.Autocomplete(input);

  autocomplete.setFields(['address_components', 'geometry', 'icon', 'name']);

  autocomplete.addListener('place_changed', function() {
    var place = autocomplete.getPlace();
    if (!place.geometry) {
      // User entered the name of a Place that was not suggested and
      // pressed the Enter key, or the Place Details request failed.
      window.alert("No details available for input: '" + place.name + "'");
      return;
    }

    var address = '';
    if (place.address_components) {
      address = [
        (place.address_components[0] && place.address_components[0].short_name || ''),
        (place.address_components[1] && place.address_components[1].short_name || ''),
        (place.address_components[2] && place.address_components[2].short_name || '')
      ].join(' ');
    }
  });

  // Sets a listener on a radio button to change the filter type on Places
  // Autocomplete.
  function setupClickListener(id, types) {
    var radioButton = document.getElementById(id);
    radioButton.addEventListener('click', function() {
      autocomplete.setTypes(types);
    });
  }
}

jQuery(document).on('turbolinks:load', function() {
  //initMap();
  $(".placepicker").placepicker();
  $("#item-loc-input").placepicker();

  

  $(document).on('cocoon:after-insert', function(e, added_item) {
    var itemSizes = $('#delivery_form').find("[data-field='item-size']");
    var locInput = added_item.find("#item-loc-input");
    locInput.placepicker();
    locInput.placeChanged.call("", );
  });
});
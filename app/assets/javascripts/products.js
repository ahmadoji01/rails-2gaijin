// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
// You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready( function() { 

  if($('#moment-chinese-locale-token').length){
    moment.locale("zh-cn");
  } else {
    moment.locale("en");
  }

	$('.product_time').each(function(index, element) {
		var $element = $(element);
		var formattedDate = moment($element.html()).calendar();
		$element.html(formattedDate);
	});

	$('.comment_time').each(function(index, element) {
		var $element = $(element);
		var formattedDate = moment($element.html()).calendar();
		$element.html(formattedDate);
	});

  $("#product-image-upload").fileinput({
    'showUpload':false,
    'maxFileCount': 6,
    'allowedFileExtensions': ['jpg', 'png', 'jpeg']
  });

});

$(document).ready( function() { 
  $("#add_to_delivery_btn").click( function(e) {
    ahoy.track("Added Item to Delivery", e.target.dataset);
  });
});

$(document).ready( function() {

  $('.galleria').each(function(index, element) {
    Galleria.configure({
      transition: 'fade',
      imageCrop: false,
      swipe: "enforced"
    });
    Galleria.loadTheme('https://cdn.jsdelivr.net/npm/galleria@1.6.1/dist/themes/classic/galleria.classic.min.js');
    Galleria.run('.galleria');
  });

  function readURL(input) {
    if (input.files && input.files[0]) {
      var reader = new FileReader();

      reader.onload = function (e) {
        $('#img_prev').attr('src', e.target.result);
      }
      reader.readAsDataURL(input.files[0]);
    }
  }

  $("#avatar-upload").change(function(){
    $('#div_img_prev').removeClass('d-none');
    $('#img_prev').removeClass('hidden');
    readURL(this);
  });
});

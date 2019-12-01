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

function markSold(productID) {
  $.ajax({
    type: 'POST',
    url: '/products/mark_as_sold',
    data: { id: productID },
    success: function(data){
      if($("#product-status-badge-" + productID).html() == "Available") {
        $("#product-status-badge-" + productID).removeClass("badge-success");
        $("#product-status-badge-" + productID).addClass("badge-warning");
        $("#product-status-badge-" + productID).html("Sold");
        $("#product-status-btn-" + productID).html("Mark as Available");
      } else if($("#product-status-badge-" + productID).html() == "Sold") {
        $("#product-status-badge-" + productID).removeClass("badge-warning");
        $("#product-status-badge-" + productID).addClass("badge-success");
        $("#product-status-badge-" + productID).html("Available");
        $("#product-status-btn-" + productID).html("Mark as Sold");
      }
    }
  });
}

function deleteProduct(productID) {
  swal({
    title: "Are you sure?",
    text: "Once deleted, you will not be able to see this item again!",
    icon: "warning",
    buttons: true,
    dangerMode: true,
  }).then( function(willDelete) {
    if (willDelete) {
      $.ajax({
        type: 'DELETE',
        url: '/products/' + productID + ".json",
        success: function(data){
          swal("Your item has been deleted!", {
            icon: "success",
          });
          $('#product-tab-' + productID).fadeOut();
        }
      }); 
    } else {
      swal("Your item is safe!");
    }
  });
}

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
    'allowedFileExtensions': ['jpg', 'png']
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

var AvatarCrop,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

$(document).ready(function() {
  //return new AvatarCrop();
  $('.product-image-forms').each(function(i, obj){
    new AvatarCrop($(this));
  });

  $("#zoom_03").ezPlus({
    gallery: 'gal1', 
    cursor: 'pointer', 
    galleryActiveClass: 'active',
    imageCrossfade: true, 
    loadingIcon: 'http://www.elevateweb.co.uk/spinner.gif',
    
    scrollZoom: true,
    showLens: true
  });

  //pass the images to Fancybox
  $('#zoom_03').bind('click', function (e) {
      var ez = $('#zoom_03').data('ezPlus');
      $.fancyboxPlus(ez.getGalleryList());
      return false;
  });
});

AvatarCrop = (function() {
  function AvatarCrop(form) {
    this.form = form;
    this.updatePreview = bind(this.updatePreview, this);
    this.update = bind(this.update, this);
    var height, width;
    width = parseInt(this.form.find('.cropbox').width());
    height = parseInt(this.form.find('.cropbox').height());
    this.form.find('.cropbox').Jcrop({
      aspectRatio: 1,
      onSelect: this.update,
      onChange: this.update,
      setSelect: [0, 0, width, height]
    });
  }

  AvatarCrop.prototype.update = function(coords) {
    this.form.find('.crop_x_attr').val(coords.x);
    this.form.find('.crop_y_attr').val(coords.y);
    this.form.find('.crop_w_attr').val(coords.w);
    this.form.find('.crop_h_attr').val(coords.h);
    return this.updatePreview(coords);
  };

  AvatarCrop.prototype.updatePreview = function(coords) {
    var rx, ry;
    rx = 100 / coords.w;
    ry = 100 / coords.h;
  };

  return AvatarCrop;

})();

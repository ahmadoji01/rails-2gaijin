jQuery(document).on('turbolinks:load', function() {
	
	$('.msg_time').each(function(index, element) {
		var $element = $(element);
		var formattedDate = moment($element.html()).calendar();
		$element.html(formattedDate);
	});
});

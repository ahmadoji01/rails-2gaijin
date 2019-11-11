$(document).ready( function() {
	
	if($('#moment-chinese-locale-token').length){
		moment.locale("zh-cn");
	} else {
		moment.locale("en");
	}

	$('.msg_time').each(function(index, element) {
		var $element = $(element);
		var formattedDate = moment($element.html()).calendar();
		$element.html(formattedDate);
	});

	$('.active_msg_time').each(function(index, element) {
		var $element = $(element);
		var formattedDate = moment($element.html()).calendar();
		$element.html(formattedDate);
	});
});

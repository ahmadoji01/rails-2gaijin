$(document).ready(function(){
	var totalPrice = 0;

	function calculatePrice(bigItemNum, smallItemNum) {
		var bigItemFirstRate = 1500; var smallItemFirstRate = 500;
		var bigItemRate = 500; var smallItemRate = 300;
		var cost = 0;

		if(bigItemNum == 1)
			cost += bigItemFirstRate;
		else if(bigItemNum == 2)
			cost += bigItemFirstRate + 750;
		else if(bigItemNum >= 3)
			cost += bigItemFirstRate + 750 + (bigItemRate * (bigItemNum - 2));

		if(smallItemNum == 1)
			cost += smallItemFirstRate;
		else if(smallItemNum >= 2)
			cost += smallItemFirstRate + (smallItemRate * (smallItemNum - 1));

		return cost;
	}

	$(document).on('cocoon:after-insert', function() {
		var itemSizes = $('#delivery_form').find("[data-field='item-size']");		

		for( var i = 0; i < itemSizes.length; i++ ) {
			itemSizes[i].onchange = function() {
				var bigItemTotal = 0; var smallItemTotal = 0;
				
				for( var i = 0; i < itemSizes.length; i++ ) {
					var checkedVal = $("input[id=" + itemSizes[i].id + "]:checked").val();
					if(checkedVal == "big")
						bigItemTotal++;
					else if(checkedVal == "small")
						smallItemTotal++;
				}

				totalPrice = 0;
				totalPrice = calculatePrice(bigItemTotal, smallItemTotal);

				$('#delivery_price').val(totalPrice);
				$('#delivery_price_view').html("¥‎" + totalPrice);
				$('#total_price_view').html("¥‎" + totalPrice);
			};
		}
	})
	.on('cocoon:after-remove', function(){
		var itemSizes = $('#delivery_form').find("[data-field='item-size']");
		var bigItemTotal = 0; var smallItemTotal = 0;
		
		for( var i = 0; i < itemSizes.length; i++ ) {
			var checkedVal = $("input[id=" + itemSizes[i].id + "]:checked").val();
			if(checkedVal == "big")
				bigItemTotal++;
			else if(checkedVal == "small")
				smallItemTotal++;
		}

		totalPrice = 0;
		totalPrice = calculatePrice(bigItemTotal, smallItemTotal);

		$('#delivery_price').val(totalPrice);
		$('#delivery_price_view').html("¥‎" + totalPrice);
		$('#total_price_view').html("¥‎" + totalPrice);
	});
});
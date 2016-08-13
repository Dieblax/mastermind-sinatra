$(document).ready(function() {
	var digits = [-1, -1, -1, -1];
	$('.circle').click(function() {
		digits[parseInt($(this).attr('id')) - 1] += 1;
		digits[parseInt($(this).attr('id')) - 1] = digits[parseInt($(this).attr('id')) - 1] % 6;
		var value = digits[parseInt($(this).attr('id')) - 1]; 
		// $(this).text(value);
		$(this).css({'background-color' : getColor(value)});
		$(this).removeClass('inactive')
	});
	$('form').submit(function(e) {
		$(this).append("<input type='hidden' name='digit1' value=" + digits[0] + " >");
		$(this).append("<input type='hidden' name='digit2' value=" + digits[1] + " >");
		$(this).append("<input type='hidden' name='digit3' value=" + digits[2] + " >");
		$(this).append("<input type='hidden' name='digit4' value=" + digits[3] + " >");
	});

	$('.help a').click(function() {
		$('.help_mask').css({'display' : 'block'});
		$('.help_window').css({'display' : 'block'});
	});

	$('.play').click(function() {
		$('.help_mask').css({'display' : 'none'});
		$('.help_window').css({'display' : 'none'});
	});

	$('.help_mask').on('mousedown', function() {
		$('.help_mask').css({'display' : 'none'});
		$('.help_window').css({'display' : 'none'});
	});

	// When a div is clicked, it changes color and its value goes up 1 
	// When the form is submitted it sends the value of each div
});

function getColor(number) {
	var colors = [
					"#3A3485",
					"#017FCA",
					"#76B716",
					"#FFB700",
					"#EE6E01",
					"#F66A96"
				];
	
	return colors[number];
}
$('nav li:has(ul)').addClass('expanding');

$('.open-link').click(function(event){
	event.preventDefault();
	$(this).parent().toggleClass('opened');

	if ($(this).find('.open-widget').text() == '+'){
		$(this).find('.open-widget').text('-');
	}
	else{
		$(this).find('.open-widget').text('+');
	}
});
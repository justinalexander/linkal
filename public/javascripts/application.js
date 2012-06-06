$(function() {
	$( ".datepicker" ).datepicker();

	$('.ec-day-bg,').click(function(){
		position = $.inArray( this, $(this).parent().children() );

		// This is so ugly :(
		day = $(this).parent().parent().parent().siblings('.ec-row-table').children().children().first().children()[position]
		window.location = $('.ec-day-link', day).first().attr('href');
	});
	
	$('.ec-day-header').click( function() {
		window.location = $('.ec-day-link', this).first().attr('href');
	});

	$('.ec-day-header').click(function(){
		window.location = $('.ec-day-link', this).first().attr('href');
	});

	$('select#per_page').change(function(){
		$(this).parent().submit();
	});
  
});
jQuery( function($) {
	$('#signup #content form a.button').click( function() {
		$(this).parent().append('<br />').append('<input type="file" class="file" />');
		return false;
	});
	
	$('#signup > form a.button.add-end-time').click( function() {
		$(this).slideUp();
		$('#end-time').slideDown();
	});

	$('#signup > form a.button.add-location').click( function() {
		$(this).slideUp();
		$('#location').slideDown();
	});
	
	$('#signup > form a.button.add-change-password').click( function() {
		$(this).slideUp();
		$('#change-password').slideDown();
	});
	
	
	$('table.styled tbody tr[data-href]').addClass('clickable').click( function() {
		window.location = $(this).attr('data-href');
	}).find('a').hover( function() {
		$(this).parents('tr').unbind('click');
	}, function() {
		$(this).parents('tr').click( function() {
			window.location = $(this).attr('data-href');
		});
	});
	
	if( $.browser.msie && $.browser.version.substr(0,1) <= 8 ) {
		$('table.styled tbody tr:even').addClass('even');
		$('#cities li:nth-child(7n)').addClass('row');
	}
	
	//city selector
    $('#cities').hide();
    $('#change-city').click(function() {
		$('#cities').slideUp();
		if($('#cities').is(':hidden')) {
			$('#cities').slideDown();
		}
		return false;
     });
	
	//step-by-step date picker, hide/show 'to' field
	$('.end-date').hide();
	$('.switch').click( function() {
		$(this).hide();
		$('.end-date').show();
		$('.pickers #from').attr('placeholder', 'Start Date');
	});
	
	//advanced email settings form hide/show
	$('#email-settings').hide();    
    $('.expander').click(function() {
		$('#email-settings').slideUp();
		$(this).removeClass('opened');
		if($('#email-settings').is(':hidden')) {
			$('#email-settings').slideDown();
			$(this).addClass('opened');
		}
		return false;
     });
    
    //radio styling
    $('#email-settings input:radio').css('opacity','0').parent().addClass('radio');
	$('#email-settings input:checkbox').css('opacity','0').parent().addClass('radio');
	$('#email-settings input:checked').parent().addClass('active');
	
	$('#email-settings input:radio').parent().click(function() {
		$('#email-settings input:radio:checked').parent().addClass('active');
		$('#email-settings input:radio:checked').parent().siblings().removeClass('active');
	});
	
	$('#email-settings input:checkbox').change(function() {
		$(this).parent().toggleClass('active');
	});

  /* submit if elements of class=autosubmit_item in the form changes */
  $(".autosubmit_item").change(function() {
    $(this).parents("form").submit();
  });
  
    //select styling plugin
    $('.chzn-select').chosen();
});
(function($){
	$.fn.extend({
 
		selectbox : function(options) {
			if(!$.browser.msie || ($.browser.msie&&$.browser.version>6)){
				return this.each(function() {
	  
					var currentSelected = $(this).find(':selected');
					$(this).after('<span class="select"><span class="select-inner">'+currentSelected.text()+'</span></span>').css({position:'absolute', opacity:0,fontSize:$(this).next().css('font-size')});
					var selectBoxSpan = $(this).next();
					selectBoxSpan.addClass( $(this).attr('class') );
					var selectBoxWidth = parseInt($(this).width()) - parseInt(selectBoxSpan.css('padding-left')) -parseInt(selectBoxSpan.css('padding-right'));			
					var selectBoxSpanInner = selectBoxSpan.find(':first-child');
					selectBoxSpan.css({width:selectBoxWidth, display:'inline-block'});
					selectBoxSpanInner.css({width:selectBoxWidth-20, display:'inline-block'});
					var selectBoxHeight = parseInt(selectBoxSpan.height()) + parseInt(selectBoxSpan.css('padding-top')) + parseInt(selectBoxSpan.css('padding-bottom'));
					$(this).height(selectBoxHeight).change(function(){
						// selectBoxSpanInner.text($(this).val()).parent().addClass('changed');   This was not ideal
						selectBoxSpanInner.text($(this).find(':selected').text()).parent().addClass('changed');
						// Thanks to Juarez Filho & PaddyMurphy
					});
				});
			}
		}
	});
})(jQuery);
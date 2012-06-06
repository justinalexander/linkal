
(function($){
	$.getScript('/javascripts/mylibs/jquery.select.js', function(){
		$('select').wrap('<span class="select-wrap" />').selectbox();
		$('#email-settings select').wrap('<span class="nowrap" />').remove();
	});
	
	$.getScript('/javascripts/libs/jquery.fancybox.1.3.4.pack.js', function(){
		$('head').append('<link rel="stylesheet" type="text/css" href="/stylesheets/jquery.fancybox.css" />');
		
		$('#attached-photos a').attr('rel', 'fancy-group').fancybox({
			'padding': 0,
			'type': 'image'
		});
		
		$('a.terms-of-service').fancybox({
			'content': $('#terms-of-service').html()
		});
	});
 
	$.getScript('/javascripts/mylibs/jquery.placeholder.min.js', function(){
		$('input[placeholder], textarea[placeholder], email[placeholder]').placeholder();
	});


})(this.jQuery);




window.log = function(){
  log.history = log.history || [];   
  log.history.push(arguments);
  if(this.console){
    console.log( Array.prototype.slice.call(arguments) );
  }
};
(function(doc){
  var write = doc.write;
  doc.write = function(q){ 
    log('document.write(): ',arguments); 
    if (/docwriteregexwhitelist/.test(q)) write.apply(doc,arguments);  
  };
})(document);



$(function(){
  $.mobile.ajaxEnabled = false;
  $('input[placeholder], textarea[placeholder]').placeholder();
  $('#mydate').bind('datebox', function(e, p) {
    if ( p.method === 'set' ) {
      e.stopImmediatePropagation()
      //DO SOMETHING//
    }
  });
});

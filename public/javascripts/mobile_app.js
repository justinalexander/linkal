$(function(){
  $.mobile.ajaxEnabled = false;
  $('input[placeholder], textarea[placeholder]').placeholder();
  if($('#mydate').length > 0){
    $('[class*="ui-btn-up"]').each(function(idx, date_box){
      var day_text = $(date_box).text()
      var day = parseInt(day_text);
      if(!isNaN(day)){
        var day_has_event = $.grep(month_events, function(d){
          return d === day;
        }).length > 0;
        if(day_has_event){
          if($(date_box).hasClass('ui-btn-up-d')){
            $(date_box).removeClass('ui-btn-up-d');
            $(date_box).addClass('ui-btn-up-e');
          }
        }
      }
    });

    $('#mydate').bind('datebox', function(sender, e) {
      var year, month, day;
      if ( e.method === 'set' ) {
        sender.stopImmediatePropagation()
        year = e.date.getFullYear();
        month = e.date.getMonth() + 1;
        day = e.date.getDate();
        window.location = calendar_url + '/' + year + '/' + month + '/' + day;
      }
    });
  }
  
});

$(document).on('pageinit', function() {

  $('input[placeholder], textarea[placeholder]').placeholder();

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

  $(document).on('pagechange', function(e){
    e.stopImmediatePropagation();
    $('#mydate', $.mobile.activePage).on('datebox', function(e, sender) {
      var year, month, day, url;
      if ( sender.method === 'set' ) {
        e.stopImmediatePropagation();
        year = sender.date.getFullYear();
        month = sender.date.getMonth() + 1;
        day = sender.date.getDate();
        url = calendar_url + '/' + year + '/' + month + '/' + day;
        $.mobile.changePage(url, {
          showLoadMsg: true,
          reloadPage: true,
          changeHash: true
        });
      }
    });
  });

  if(typeof(attendance_urls) !== 'undefined'){
    $.each(attendance_urls, function(idx, att){
      $(att.target).on('click', function(e){
        e.preventDefault();
        $.ajax({
          type: "PUT",
          url: att.url,
        }).done(function( msg ) {
          $(att.target).addClass('ui-disabled');
          $(att.target).off('click');
        });
      });
    });
  }

  $('input[name^="user_organization"]:checkbox').on('change', function(e){
    $(e.target).parents('form').first().submit();
  });

});

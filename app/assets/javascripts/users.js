/*
jQuery ->
  $( "#tabs" ).tabs
    #i.e. do something on show tab
    show: (event, ui) ->
      #optional if want to do something based on tab selection
      whichSelected = $("#tabs").tabs('option', 'selected')
      #do something
*/
(function() {
  jQuery(function() {
    return $("#tabs").tabs({
      show: function(event, ui) {
        var whichSelected;
        return whichSelected = $("#tabs").tabs('option', 'selected');
      }
    });
  });

}).call(this);
jQuery ->
  $( "#tabs" ).tabs
    #i.e. do something on show tab
    show: (event, ui) ->
      #optional if want to do something based on tab selection
      whichSelected = $("#tabs").tabs('option', 'selected')
      #do something

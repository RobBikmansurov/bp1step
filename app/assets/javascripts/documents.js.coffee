jQuery ->
  $("#document_owner_name").autocomplete
    source: "/users/autocomplete"
#    source: ['foo', 'foobar', 'bar']
#    source: $('#document_owner_name').data('autocomplete-source')
#$(document).ready ->
#  $('#document_owner_name').autocomplete
#  source: "/users/autocomplete"
#  select: (event,ui) -> $("#document_owner_name").val(ui.item.id)
 
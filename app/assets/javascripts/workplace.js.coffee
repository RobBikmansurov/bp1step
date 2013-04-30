jQuery ->
  $("#user_workplace_user_name").autocomplete
    source: "/users/autocomplete"
  $("#user_workplace_user_name").bind "railsAutocomplete.select", (event, data) ->
    alert data.item.id
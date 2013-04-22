jQuery ->
  $("#bproce_user_name").autocomplete
    source: "/users/autocomplete"
  $("#bproce_workplace_workplace_designation").autocomplete
    source: "/workplaces/autocomplete"
  $("#bproce_bapp_bapp_name").autocomplete
    source: "/bapps/autocomplete"
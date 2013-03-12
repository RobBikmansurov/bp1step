jQuery ->
  $("#document_owner_name").autocomplete
    source: "/users/autocomplete"
  $("#document_directive_directive_id").autocomplete
    source: "/directives/autocomplete"

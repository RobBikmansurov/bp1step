// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.jQuery ->
jQuery ->
  $("#document_owner_name").autocomplete
    source: ["foo', 'forte', 'fif"]
//    source: $('#document_owner_name').data('autocomplete-source')
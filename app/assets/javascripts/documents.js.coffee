// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.jQuery ->
jQuery ->
  $('#document_owner_id').autocomplete
   source: $('#document_owner_id').data('autocomplete-source')
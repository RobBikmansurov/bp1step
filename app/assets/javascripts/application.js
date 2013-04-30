// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery-1.9.1.min.js
//= require jquery_ujs
//= require_tree .
//= require autocomplete-rails
//= datepicker.translate.js
//= require jquery.ui.nestedSortable
//= require sortable_tree/initializer
$(function (){
  $('.datepicker').datepicker({
  	changeMonth: true,
    changeYear: true,
    yearRange: "-15:+0",
    dateFormat: "dd.mm.yy",
    autoSize: true,
    dayNamesMin: ['ВС', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'СБ'],
    monthNamesShort: ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'],
    firstDay: 1});
});
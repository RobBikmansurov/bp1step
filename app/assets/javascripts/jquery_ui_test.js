//= require jquery-ui/datepicker
$(function() {
  $('.datepicker').datepicker({
    changeMonth: true,
    changeYear: true,
    inline: true, 
    showOtherMonths: true, 
    yearRange: "-15:+1",
    dateFormat: "dd.mm.yy",
    autoSize: true,
    dayNamesMin: ['ВС', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'СБ'],
    monthNamesShort: ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'],
    firstDay: 1});
});
$(document).ready(function() {
  $(".tabs ul li").on("click", function() {
    // alert('tab clicked!');
    var id = $(this).attr("data-tab");
    // alert(id);
 
    $(".tabs ul li").removeClass("is-active");
    $(".tab-content").removeClass("current-tab");
    $(this).addClass("is-active");
    $("#" + id).addClass("current-tab");
  });
});
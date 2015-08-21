$(document).ready(function() {
  $("#frm_new").hide();
  $("#coverage").click(function() {
    update_coverage();
  });
  $("#create_image").click(function() {
    var url = $("#url").val();
    $("#source_image").attr("src", url);
    toggle_all();
    $("#frm_cancel").show();
    $.ajax({
      url: "/pop?url=" + url,
      success: function(pcnt, status) {
        var img = new Image();
        $(img).attr("src", "out.jpg");
        $("#pop_image").append(img);
        $("#frm_new").show();
      }
    });
  });
});

function toggle_all() {
  $("#coverage").toggle();
  $("#p-coverage").toggle();
  $("#url").toggle();
  $("#create_image").toggle();
}

function update_coverage() {
  $.ajax({
    url: "/coverage",
    success: function(coverage, status) {
      set_coverage(coverage);
    }
  });
}

function set_coverage(coverage) {
  var color = 'color: #900;';
  if (coverage >= 50) color = 'color: #990;';
  if (coverage >= 75) color = 'color: #090;';
  $("#p-coverage").attr("style", color);
  $("#p-coverage").html(coverage + "% coverage");
}

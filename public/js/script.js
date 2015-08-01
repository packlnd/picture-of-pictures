$(document).ready(function() {
  $("#coverage").click(function() {
    update_coverage();
  });

  $("#indexing").click(function() {
    $("#p-coverage").html("Indexing images..");
    $.ajax({
      url: "/index",
      success: update_coverage()
    });
  });

  $("#create_image").click(function() {
    var url = $("#url").val()
    $.ajax({url: "/pop?url=" + url});
  });
});

function update_coverage() {
  $.ajax({
    url: "/coverage",
    success: function(coverage, status) {
      var color = 'color: #900;';
      if (coverage >= 50) color = 'color: #990;';
      if (coverage >= 75) color = 'color: #090;';
      $("#p-coverage").attr("style", color);
      $("#p-coverage").html(coverage + "% coverage");
    }
  });
}

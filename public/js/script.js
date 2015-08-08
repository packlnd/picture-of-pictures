$(document).ready(function() {
  $("#coverage").click(function() {
    update_coverage();
  });

  $("#indexing").click(function() {
    $("#p-coverage").html("Indexing images..");
    $.ajax({
      url: "/index",
      success: function(coverage, status) {
        set_coverage(coverage);
      }
    });
  });

  $("#create_image").click(function() {
    var url = $("#url").val();
    $("#source_image").attr("src", url);
    $.ajax({
      url: "/pop?url=" + url,
      success: function(json, status) {
        var img = new Image();
        $(img).attr("src", json);
        $("#pop_image").append(img);
      }
    });
  });
});

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

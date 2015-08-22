var tot=0
var cur=0;

$(document).ready(function() {
  $("#frm_new").hide();
  $("#coverage").click(function() {
    update_coverage();
  });
  //$("#create_image").click(function() {
  //  var url = $("#url").val();
  //  $("#source_image").attr("src", url);
  //  toggle_all();
  //  $("#frm_cancel").show();
  //  $.ajax({
  //    url: "/pop?url=" + url,
  //    success: function(pcnt, status) {
  //      load_image();
  //      $("#frm_new").show();
  //    }
  //  });
  //});
  $("#create_image").click(function() {
    var url = $("#url").val();
    var img = document.getElementById("source_image");
    img.src=url;
    img.onload = function() {
      cur=1;
      tot=img.naturalHeight;
    };
    toggle_all();
    $("#frm_cancel").show();
    console.log("Starting pop");
    $.ajax({
      url: "/begin_pop?url=" + url,
      success: function(img_name, status) {
        do_next_row(img_name);
      }
    });
  });
});

function do_next_row(img_name) {
  cur += 1;
  if (cur >= tot) {
    console.log("Done");
    $("#frm_new").show();
    return;
  }
  var img = new Image();
  img.src = img_name;
  img.onload = function() {
    $("#pop_image").html(img);
    $.ajax({
      url: "/continue_pop",
      success: function(img_name, status) {
        do_next_row(img_name);
      }
    });
  };
}

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

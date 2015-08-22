var tot=0
var cur=1;
var inc = 1;

$(document).ready(function() {
  $("#frm_new").hide();
  $("#coverage").click(function() {
    update_coverage();
  });
  $("#create_image").click(function() {
    var url = $("#url").val();
    var size = $("#sel_size").val();
    var img = document.getElementById("source_image");
    img.src=url;
    img.onload = function() {
      cur=1;
      tot=img.naturalHeight;
    };
    toggle_all();
    $("#frm_cancel").show();
    $.ajax({
      url: "/begin_pop?inc=" + inc + "&url=" + url + "&size=" + size,
      success: function(img_name, status) {
        do_next_row(img_name);
      },
      error: function(xhr, textStatus, errorThrown) {
        console.log(xhr +" "+ textStatus);
      }
    });
  });
});

function do_next_row(img_name) {
  cur += inc;
  var img = new Image();
  img.src = img_name;
  img.onload = function() { $("#pop_image").html(img);
    if (cur > tot) {
      $("#frm_new").show();
      return;
    }
    $.ajax({
      url: "/continue_pop",
      success: function(img_name, status) {
        do_next_row(img_name);
      },
      error: function(xhr, textStatus, errorThrown) {
        console.log(xhr +" "+ textStatus);
      }
    });
  };
}

function toggle_all() {
  $("#coverage").toggle();
  $("#p-coverage").toggle();
  $("#url").toggle();
  $("#create_image").toggle();
  $("#sel_size").toggle();
  $("#recent_links").toggle();
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

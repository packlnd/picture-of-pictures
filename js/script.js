function get_pictures() {
  $.ajax({
    url: 'https://api.flickr.com/services/rest/?method=flickr.photos.getRecent' +
    '&api_key=' + config.api_key +
    '&extras=url_q' +
    '&format=json' +
    '&nojsoncallback=1',
    dataType: "text"
  })
  .done(function(data) {
    var json = JSON.parse(data);
    var div = document.getElementById('for_test')
    for (var i=0; i<json.photos.photo.length; i++) {
      handle_photo(div, json.photos.photo[i], i);
    }
  });
}

function handle_photo(div, photo, i) {
  var url = 'https://farm' +
    photo.farm + '.staticflickr.com/' +
    photo.server + '/' +
    photo.id + '_' +
    photo.secret + '_q.jpg';
  var img = '<img width=100 height=100 id="img' + i + '" src=' + url + '/>';
  var img_div = '<div id="img_div">' + img + '</div>';
  div.innerHTML = div.innerHTML + img_div;
  dominant_border(i);
}

function dominant_border(i) {
  var img = document.getElementById('img' + i);
  var pixels = getContext().getImageData(img.x,img.y,img.width,img.height).data;
  img.style.borderColor = '#' + dec_to_hex(pixels[0]) + dec_to_hex(pixels[1]) + dec_to_hex(pixels[2]);
}

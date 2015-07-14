function get_pictures() {
  $.ajax({
    url: "https://api.flickr.com/services/rest/?method=flickr.photos.getRecent&api_key=efc9e30a247dfdc1367cba1ba68b3dae&extras=url_q&format=json&nojsoncallback=1",
    dataType: "text"
  })
  .done(function(data) {
    var json = JSON.parse(data);
    var div = document.getElementById('for_test')
    for (var i=0; i<json.photos.photo.length; i++) {
      var url = 'https://farm' +
        json.photos.photo[i].farm + '.staticflickr.com/' +
        json.photos.photo[i].server + '/' +
        json.photos.photo[i].id + '_' +
        json.photos.photo[i].secret + '_q.jpg';
      div.innerHTML = div.innerHTML + '<img src=' + url + '/>';
    }
  });
}

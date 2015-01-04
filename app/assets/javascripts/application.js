// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require turbolinks
//= require bootstrap.min
//= require_tree .
//= require chart.min

  var polylines = [];

  function get_route()
  {
      var origin = escape($('#origin').val());
      var destination = escape($('#destination').val());

      $.getJSON( "/route/"+origin+"/"+destination+".json", function() {})
      .done(function(data){
        if(data["distance"] == 0) alert("Leider ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut!"); 
        else draw_route(data);
      }) 
      .fail(function() {    
        alert("Leider ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut!"); 
      });

  }

  function draw_route(data)
  {
    var path   = data["path"],
        last   = path[0],
        bounds = data["bounds"]

    var coordinates = [];

    console.log(data);

    for (i = 0; i < path.length; i++) {
      coordinates.push(new google.maps.LatLng(path[i][0], path[i][1]));
    }

    var polyline = new google.maps.Polyline({
      path: coordinates,
      geodesic: true,
      strokeColor: '#ed4514',
      strokeOpacity: 0.7,
      strokeWeight: 5
    });

    // Add to polylines
    polylines.push(polyline);

    // Remove old polylines
    for(i=0; i<polylines.length;i++)
    {
      polylines[i].setMap(null);
    }

    // Draw on map
    polyline.setMap(map);

    map.fitBounds(new google.maps.LatLngBounds(bounds["path"]));

    map.setCenter(coordinates[coordinates.length/2]);

  }


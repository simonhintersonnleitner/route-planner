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
//= require jquery.tablesorter.min

  var polylines = [],
      garages   = [],
      loading   = false;

  function get_route()
  {
      var origin = encodeURI($('#origin').val());
      var destination = encodeURI($('#destination').val());

      $.getJSON( "/route/"+origin+"/"+destination+".json", function() {})
      .done(function(data){
        if(data["distance"] == 0) alert("Leider ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut!"); 
        else {
          startLoading();
          draw_route(data);
        }
      }) 
      .fail(function() {    
        alert("Leider ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut!"); 
        stopLoading();
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

    // Anzahl Zwischenschritte berechnen
    var x = Math.round(path.length / (data["distance"]/ 1000 / 40) );

    // Tankstellen finden
    for(i = 0; i < path.length-1; i+=x)
    {    
      get_garages(path[i][0],path[i][1],false);
    }
    get_garages(path[path.length-1][0],path[path.length-1][1],true);

    // Ladebildschirm stoppen
    //stopLoading();

    map.fitBounds(new google.maps.LatLngBounds(bounds["path"]));

    map.setCenter(coordinates[Math.round(coordinates.length/2)]);

  }

    function get_garages(lat,lng,last)
    {
      $.getJSON( "/garage/"+lat+"/"+lng+".json", function() {})
      .done(function(data){       
        garages = $.merge(garages, data);
        draw_garages_to_map(data);
        draw_garages_to_sidebar(data);
        if(last==true) stopLoading();
      }) 
      .fail(function() {    
        alert("Leider ist beim Abruf der Tankstellen ein Fehler aufgetreten. Bitte versuchen Sie es erneut!"); 
        if(last==true) stopLoading();
      });      
    }

    function draw_garages_to_map(data)
    {
      data.forEach(function(element,index,array){
        new google.maps.Marker({
          position: new google.maps.LatLng(element['lat'], element['lng']),
          map: map
        }); 
      });
    }

    function draw_garages_to_sidebar(data)
    {

    }

    function g_print()
    {
      garages.forEach(function(g){
        console.log(g["price_die"]);
      });
    }

    function sortByDiesel(a, b){
      var x = a.price_die;
      var y = b.price_die; 
      return x === null ? -1 : y === null ? -1 : ((x < y) ? -1 : ((x > y) ? 1 : 0));
    }
    function sortBySuper(a, b){
      var x = a.price_sup;
      var y = b.price_sup; 
      return x === null ? -1 : y === null ? -1 : ((x < y) ? -1 : ((x > y) ? 1 : 0));
    }

    function startLoading() 
    { 
      $("body").addClass("loading");
      loading = true; 
    }
    
    function stopLoading()  
    { 
      $("body").removeClass("loading"); 
    }    
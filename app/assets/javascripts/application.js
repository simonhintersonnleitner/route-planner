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
      loading   = false,
      id        = 0;

  function get_route()
  {
      var origin = encodeURI($('#origin').val());
      var destination = encodeURI($('#destination').val());

      garages = [];

      $.getJSON( "/route/"+origin+"/"+destination+".json", function() {})
      .done(function(data){
        if(data["distance"] == 0) alert("Leider ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut!"); 
        else {
          id = data["id"];
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
        if(last==true){
          stopLoading();
          draw_garages_to_sidebar(garages);
        }
      }) 
      .fail(function() {    
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

    function draw_sidebar()
    {
      draw_garages_to_sidebar(garages);
    }

    function draw_garages_to_sidebar(data)
    {
      $sidebar = $('#sidebar');
      $sidebar.text("");

      $sidebar.append("<a href='#"+id+"' class='col-xs-12 col-md-12 add-route'><span class='glyphicon glyphicon-resize-plus' aria-hidden='true'></span> Route zum Account hinzufügen</a>");
      $sidebar.append("<a id='dieselSort' href='javascript:sort_diesel();' class='col-xs-12 col-md-6 button'><span class='glyphicon glyphicon-resize-vertical' aria-hidden='true'></span> Diesel-Preis</a>");
      $sidebar.append("<a id='superSort' href='javascript:sort_super();' class='col-xs-12 col-md-6 button'><span class='glyphicon glyphicon-resize-vertical' aria-hidden='true'></span> Super-Preis</a>");

      data.forEach(function(g)
      {
        $sidebar.append("<div id='id"+g["id"]+"' class='tankstelle'></div>");
        $div = $sidebar.find('#id'+g["id"]);

        $div.append("<p><h4>"+g["name"]+"</h4></p>"); 
        $div.append("<p><span class='small'>"+g["address"]+"</span></p>"); 
        if(g["price_die"] != null)
          $div.append("<p><b>Diesel:</b> "+g["price_die"]+"€</p>"); 
        else
          $div.append("<p><b>Diesel:</b> -</p>"); 
        if(g["price_sup"] != null)
          $div.append("<p><b>Super:</b> "+g["price_sup"]+"€</p>");
        else
          $div.append("<p><b>Diesel:</b> -</p>"); 
        $div.append("<b>SHOW #</b>"+g["id"]); 
      });

      $sidebar.css('overflow','scroll');

    }

    function g_print()
    {
      garages.forEach(function(g){
        console.log(g["price_die"]);
      });
    }

    function sort_diesel()
    {
      $('#superSort').removeClass('active');
      $('#dieselSort').addClass('active');      
      garages.sort(sort_by_diesel);
      draw_sidebar();
    }

    function sort_super()
    {
      $('#dieselSort').removeClass('active');
      $('#superSort').addClass('active');
      garages.sort(sort_by_super);
      draw_sidebar();
    }

    function sort_by_diesel(a, b){
      var x = parseFloat(a.price_die);
      var y = parseFloat(b.price_die); 
      
      return isNaN(x) ? 1 : isNaN(y) ? -1 : x-y;
    }
    function sort_by_super(a, b){
      var x = parseFloat(a.price_sup);
      var y = parseFloat(b.price_sup); 
      
      return isNaN(x) ? 1 : isNaN(y) ? -1 : x-y;
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
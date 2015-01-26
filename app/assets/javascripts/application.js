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
  var distance = 0, hours = 0, minutes = 0;

  function get_route()
  {
      var origin = encodeURI($('#origin').val());
      var destination = encodeURI($('#destination').val());

      garages = [];
      
      markers.forEach(function(marker){
        marker.setMap(null);
      });

      markers = [];

      $.getJSON( "/route/"+origin+"/"+destination+".json", function() {})
      .done(function(data){
        if(data["route"]["distance"] == 0) alert("Leider ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut!"); 
        else {
          id = data["route"]["id"];

          distance = Math.round(data["route"]["distance"] / 1000);
          hours = Math.floor(data["route"]["time"] / 3600);
          minutes = Math.round((data["route"]["time"]-hours*3600)/60);

          startLoading();
          draw_route(data["route"]);
          if(data["weather"] != null) draw_weather(data["weather"]);
          if(data["hotels"] != null) draw_hotels(data["hotels"]["hash"]);
        }
      }) 
      .fail(function() {    
        alert("Leider ist ein Fehler aufgetreten. Bitte versuchen Sie es erneut!"); 
        stopLoading();
      });

  }

  function draw_hotels(data)
  {
    $div = $("#weather");
    $div.append('<h4>Hotels in der Umgebung</h4>');

    for(i = 0; i < data["businesses"].length; i++)
    {

      $div.append("<div class='hotel'><b><a target='_blank' href='"+data["businesses"][i]["url"]+"'>"+data["businesses"][i]["name"]+"</a></b><br><span class='small'>"+data["businesses"][i]["location"]["address"][0]+", Bewertung: "+data["businesses"][i]["rating"] + " / 5</span></div>");

    }

    $div.append('<a target="_blank" href="http://www.yelp.at/search?find_desc=Hotel&find_loc='+encodeURI($('#destination').val())+'&ns=1">Weitere Hotels bei Yelp</a>');

  }

  function draw_weather(data)
  {
    $div = $("#weather");
    $div.show(1000);
    $div.text("");
    $div.append('<h3>'+$('#destination').val()+'</h3>');
      $div.append('<div class="small">Entfernung: '+distance+'km</span></div>');
    if(hours == 1)
      $div.append('<div class="small">Fahrzeit: '+hours+' Stunde, '+ minutes +' Minuten</div>');
    else
      $div.append('<div class="small">Fahrzeit: '+hours+' Stunden, '+ minutes +' Minuten</div>');
    $div.append('<img src="/assets/weather/'+data["icon"]+'.png" alt="'+data["icon"]+'">');
    $div.append('<div class="temperature">'+data["temperature"]+"°C</div>");
  }

  function draw_route(data)
  {
    var path   = data["path"],
        last   = path[0],
        bounds = data["bounds"]

    var coordinates = [];

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
      get_garages(path[i][0],path[i][1],false,true,'sidebar');
    }
    get_garages(path[path.length-1][0],path[path.length-1][1],true,true,'sidebar');

    // Ladebildschirm stoppen
    //stopLoading();

    map.fitBounds(new google.maps.LatLngBounds(bounds["path"]));

    map.setCenter(coordinates[Math.round(coordinates.length/2)]);

  }

    function get_garages(lat,lng,last,map,div)
    {
      $.getJSON( "/garage/"+lat+"/"+lng+".json", function() {})
      .done(function(data){       
        garages = $.merge(garages, data); 
        if(map==true)
          draw_garages_to_map(data);
        if(last==true){
          stopLoading();
          draw_garages_to_div(garages,div);
        }
      }) 
      .fail(function() {    
        if(last==true) stopLoading();
      });      
    }

    var markers = [];

    function calculate_difference(price,t)
    {
      var priceSum = 0, prices = 0;

      for(i = 0; i < garages.length; i++)
      {
        if(garages[i]["price_"+t] != null){
          priceSum  += garages[i]["price_"+t];
          prices += 1;
        }
      }

      return ((Math.round((1-(price/(priceSum/prices)))*100)/100)*(-100));

    }

    function draw_garages_to_map(data)
    {

      var marker;

      data.forEach(function(element,index,array){
        marker = new google.maps.Marker({
          position: new google.maps.LatLng(element['lat'], element['lng']),
          map: map,
          title: "Klicken für Details"
        }); 

        google.maps.event.addListener(marker, 'click', function() {
          showGarage(element['id']);
        });

        markers[element['id']] = marker; 


      });
    }

    function draw_sidebar(div)
    {
      draw_garages_to_div(garages,div);
    }



    function draw_garages_to_div(data,div)
    {

      $sidebar = $('#'+div);
      $sidebar.text("");

      $sidebar.append("<a href='/route/add/"+id+"' class='col-xs-12 col-md-12 add-route'><span class='glyphicon glyphicon-resize-plus' aria-hidden='true'></span> Route zum Account hinzufügen</a>");
      $sidebar.append("<a id='dieselSort' href='javascript:sort_diesel(\""+div+"\");' class='col-xs-6 col-md-6 button'><span class='glyphicon glyphicon-resize-vertical' aria-hidden='true'></span> Diesel-Preis</a>");
      $sidebar.append("<a id='superSort' href='javascript:sort_super(\""+div+"\");' class='col-xs-6 col-md-6 button'><span class='glyphicon glyphicon-resize-vertical' aria-hidden='true'></span> Super-Preis</a>");

      var all = [];

      // unique array
      data.forEach(function(g){
        if($.grep(all, function(o){ return o.id == g.id; }).length == 0)
          all.push(g);
      });

      all.forEach(function(g)
      {


        if(g["open"] == 'false')
          $sidebar.append("<div id='id"+g["id"]+"' class='tankstelle closed'></div>");
        else
          $sidebar.append("<div id='id"+g["id"]+"' class='tankstelle'></div>");
        $div = $sidebar.find('#id'+g["id"]);

        $div.append("<p><h4>"+g["name"]+"</h4></p>"); 
        
        if(g["open"] == 'false')
          $div.append('<b class="small">Zurzeit geschlossen.</b>');
        $div.append("<p><span class='small'>"+g["address"]+"</span></p>"); 
        
        
        dif_sup = calculate_difference(g['price_sup'],'sup');


        if(g["price_die"] != null){
          dif_die = calculate_difference(g['price_die'],'die');
          if(dif_die >= 0) $div.append("<p><b>Diesel:</b> "+g["price_die"]+"€</p>"); 
          else $div.append("<p><b>Diesel:</b> "+g["price_die"]+"€ <span class='guenstig'>"+ dif_die*(-1) +"% günstiger als der Durchschnitt!</span></p>");   
        }
        else
          $div.append("<p><b>Diesel:</b> -</p>"); 
        if(g["price_sup"] != null){
          dif_sup = calculate_difference(g['price_sup'],'sup');

          if(dif_sup >= 0) $div.append("<p><b>Super:</b> "+g["price_sup"]+"€</p>"); 
          else $div.append("<p><b>Super:</b> "+g["price_sup"]+"€ <span class='guenstig'>"+ dif_sup*(-1) +"% günstiger als der Durchschnitt!</span></p>"); 
        }
        else
          $div.append("<p><b>Super:</b> -</p>"); 

        var opening = "";

        g["opening"].sort(function(a,b){
          
          var dayA, dayB;

          switch(a["day"]["dayLabel"]){
            case "Montag":
              dayA = 1; break;
            case "Dienstag":
              dayA = 2; break;
            case "Mittwoch":
              dayA = 3; break;
            case "Donnerstag":
              dayA = 4; break;
            case "Freitag":
              dayA = 5; break;
            case "Samstag":
              dayA = 6; break;
            case "Sonntag":
              dayA = 7; break;
            case "Feiertag":
              dayA = 8; break;
            default:
              dayA = 9;
          }
          switch(b["day"]["dayLabel"]){
            case "Montag":
              dayB = 1; break;
            case "Dienstag":
              dayB = 2; break;
            case "Mittwoch":
              dayB = 3; break;
            case "Donnerstag":
              dayB = 4; break;
            case "Freitag":
              dayB = 5; break;
            case "Samstag":
              dayB = 6; break;
            case "Sonntag":
              dayB = 7; break;
            case "Feiertag":
              dayB = 8; break;
            default:
              dayB = 9;
          }

          return dayA > dayB;

        });

        for(i = 0; i < g["opening"].length; i++)
        {
          opening = opening + g["opening"][i]["day"]["dayLabel"]+": " + g["opening"][i]["beginn"] + " - " + g["opening"][i]["end"] + "<br>";
        }

        $div.append("<div class='opening'>"+opening+"</div>");
      
        $('#id'+g["id"]).on('click',function(){
          showGarage(g["id"]);
        });

        if(div == 'sidebar')
        {

          $( "#id"+g["id"] ).hover( function(){
            markers[g["id"]].setAnimation(google.maps.Animation.BOUNCE);
          }, function(){
            markers[g["id"]].setAnimation(null);
          } );

        }


      });

      if(div == 'sidebar') $sidebar.css('overflow','scroll');

    }

    function g_print()
    {
      garages.forEach(function(g){
        console.log(g["price_die"]);
      });
    }

    function sort_diesel(div)
    {
      $('#superSort').removeClass('active');
      $('#dieselSort').addClass('active');      
      garages.sort(sort_by_diesel);
      console.log(div);
      draw_sidebar(div);
    }

    function sort_super(div)
    {
      $('#dieselSort').removeClass('active');
      $('#superSort').addClass('active');
      garages.sort(sort_by_super);
      draw_sidebar(div);
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

    function showGarage(id)
    {

      $('#garageModal').html("").html($('#id'+id).html());
      $(".overlay").show();    
      $("#garageModal").show();  

    }

    function closeGarage()
    {
      $(".overlay").hide();    
      $("#garageModal").hide();    
    }

  $(document).ready(function(){

    $(document).on('keyup',"#origin,#destination",function(event){
      if(event.keyCode == 13){
          get_route();
          closeGarage();
      }
    });
    $(document).on('click',"#searchbutton",function(){
      get_route();
      closeGarage();
    });
    
    $(document).on('keyup',"#origin2,#destination2",function(event){
      if(event.keyCode == 13){
          $('#origin').val($('#origin2').val());
          $('#destination').val($('#destination2').val());
          get_route();
          closeGarage();
      }
    });

    $(document).on('click',"#searchbutton2",function(){
      $('#origin').val($('#origin2').val());
      $('#destination').val($('#destination2').val());
      get_route();
      closeGarage();
    });

    $("#toggleNav").on('click',function(){
      $('nav').slideToggle();
      $(this).toggleClass('active',500);
    });

    $('.overlay').on('click',function(){
      closeGarage();
    });  

  });


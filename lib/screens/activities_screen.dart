import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';

import '../widgets/marker_popup.dart';


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatelessWidget {
  List<Marker> markerslist=[];
  final String mapboxAccessToken =
      'pk.eyJ1Ijoiam9yZGlwaWUiLCJhIjoiY2xxMTI4dHE4MDRrejJycGszdjZ2MTFxYiJ9.ns79MsPOeQ9_0drgrsYPEw';
  List<Marker> initMarkers(){
    markerslist=[];
    markerslist.add(Marker(
                width: 30.0,
                height: 30.0,
                point: LatLng(41.275556, 1.986944),
                child: Icon(
                    Icons.location_pin, size:50,
                    color: Colors.black,
                  ),
                ),);
    markerslist.add(Marker(
                width: 30.0,
                height: 30.0,
                point: LatLng(41.274322, 1.983839),
                child: Icon(
                    Icons.location_pin, size:50,
                    color: Colors.black,
                  ),
                ),);
                return markerslist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activitats'),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(41.275556, 1.986944),
          zoom: 16.0,
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token=$mapboxAccessToken',
            additionalOptions: {
              'id': 'mapbox/streets-v11', // Puedes cambiar el estilo del mapa aquí
            },
          ),
          MarkerLayer(
            markers: initMarkers()
          ),
          PopupMarkerLayer(
            options: PopupMarkerLayerOptions(
              markers: markerslist,
              popupDisplayOptions: PopupDisplayOptions(
                builder: (BuildContext context, Marker marker) =>
                    ExamplePopup(marker),
              ),
              selectedMarkerBuilder: (context, marker) => const Icon(
                Icons.location_on,
                size: 50,
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


  






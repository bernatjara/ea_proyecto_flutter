import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_marker_popup/flutter_map_marker_popup.dart';




class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatelessWidget {
  var markerslist;
  final String mapboxAccessToken =
      'pk.eyJ1Ijoiam9yZGlwaWUiLCJhIjoiY2xxMTI4dHE4MDRrejJycGszdjZ2MTFxYiJ9.ns79MsPOeQ9_0drgrsYPEw';
  initMarkers(){
    markerslist=[];
    markerslist.add(Marker(width: 30.0,
                height: 30.0,
                point: LatLng(41.275556, 1.986944),
                builder: (ctx) => const Icon(
                
                    Icons.location_pin,
                    color: Colors.red,
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
          zoom: 13.0,
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
            markers: initMarkers()/*[
              Marker(
                width: 30.0,
                height: 30.0,
                point: LatLng(41.275556, 1.986944),
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.red,
                  ),
                ),
              ),
            ],*/
          ),
         /* PopupMarkerLayerOptions(
            markers: [
              PopupMarker(
                marker: markers[0],
                popupBuilder: (BuildContext context, Marker marker) {
                  return Container(
                    width: 200,
                    height: 100,
                    color: Colors.white,
                    child: Text('Información del Marcador'),
                  );
                },
              ),
            ],
          ),*/
        ],
      ),
    );
  }
}
  





/*
//import 'package:geolocator/geolocator.dart';


//const MAPBOX_ACCESS_TOKEN = 'pk.eyJ1Ijoiam9yZGlwaWUiLCJhIjoiY2xxMTI4dHE4MDRrejJycGszdjZ2MTFxYiJ9.ns79MsPOeQ9_0drgrsYPEw';
const myPosition=LatLng(41.275556,1.986944);

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? myPosition;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Mapa'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FlutterMap(
              options: MapOptions(
                  center: myPosition, minZoom: 5, maxZoom: 25, zoom: 18),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/jordipie/clq1424ox01ox01qtb5l32ydd/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1Ijoiam9yZGlwaWUiLCJhIjoiY2xxMTI4dHE4MDRrejJycGszdjZ2MTFxYiJ9.ns79MsPOeQ9_0drgrsYPEw',
                  /*additionalOptions: const {
                    'accessToken': MAPBOX_ACCESS_TOKEN,
                    'id': 'mapbox/streets-v12'
                  },*/
                ),
                /*MarkerLayer(
                  markers: [
                    Marker(
                      point: myPosition!,
                      builder: (context) {
                        return Container(
                          child: const Icon(
                            Icons.person_pin,
                            color: Colors.blueAccent,
                            size: 40,
                          ),
                        );
                      },
                    )
                  ],
                )*/
              ],
            ),
    );
  }
}

class ActivitiesScreen extends StatefulWidget {
  const ActivitiesScreen({super.key});

  @override
  State<ActivitiesScreen> createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavBar(),
      appBar: AppBar(
        title: const Text("Activitats"),
        backgroundColor: const Color.fromRGBO(0, 125, 204, 1.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
                ElevatedButton(
                onPressed: () {
                  // Acción a realizar cuando se presiona el botón
                  print('Botón presionado');
                },
                child: Text('Xocolatada 17 de Gener'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Acción a realizar cuando se presiona el segundo botón
                  print('Segundo botón presionado');
                },
                child: Text('Partit de futbol 20 de Desembre'),
              ),
              SizedBox(height: 20), // Agrega un espacio entre los botones y el mapa
              Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: LatLng(0, 0), // Cambia esto con las coordenadas reales
                  zoom: 15,
                ),
                markers: Set<Marker>.of([
                  Marker(
                    markerId: MarkerId('markerId'),
                    position: LatLng(0, 0), // Cambia esto con las coordenadas reales
                    infoWindow: InfoWindow(title: 'Mi Marcador'),
                  ),
                ]),
                // Otros atributos de GoogleMap según tus necesidades
              ),
              ),
            ],
          ), 
        ),
      ),
    );
  }
}*/

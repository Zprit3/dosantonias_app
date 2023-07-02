import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  LocationData? currentLocation;
  Set<Marker> markers = {};
  List<LatLng> polylineCoordinates = [];
  Polyline? polyline;
  Stopwatch stopwatch = Stopwatch();
  String elapsedTime = '00:00:00';

  @override
  void initState() {
    super.initState();
    startLocationService();
  }

  Future<void> startLocationService() async {
    final location = Location();

    try {
      await location.requestPermission();
      location.onLocationChanged.listen((LocationData newLocation) {
        setState(() {
          currentLocation = newLocation;
          if (stopwatch.isRunning) {
            polylineCoordinates.add(LatLng(
              newLocation.latitude!,
              newLocation.longitude!,
            ));
            updatePolyline();
          }
        });
      });
    } catch (e) {
      print('Error al iniciar el servicio de ubicacion: $e');
    }
  }

  void startRoute() {
    markers.clear();
    polylineCoordinates.clear();
    polyline = null;

    final initialPosition = LatLng(
      currentLocation!.latitude!,
      currentLocation!.longitude!,
    );

    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId("Inicio"),
          position: initialPosition,
          draggable: false,
        ),
      );

      polylineCoordinates.add(initialPosition);
      updatePolyline();

      stopwatch.reset();
      stopwatch.start();
      elapsedTime = '00:00:00';
    });
  }

  void finishRoute() {
    final endPosition = LatLng(
      currentLocation!.latitude!,
      currentLocation!.longitude!,
    );

    setState(() {
      markers.add(
        Marker(
          markerId: const MarkerId("Fin"),
          position: endPosition,
          draggable: false,
        ),
      );

      stopwatch.stop();
      elapsedTime = stopwatch.elapsed.toString().split('.')[0];
    });
  }

  void updatePolyline() {
    setState(() {
      polyline = Polyline(
        polylineId: const PolylineId('ruta'),
        color: Colors.blue,
        points: polylineCoordinates,
        width: 5,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
                target: LatLng(-36.6297, -71.8330), zoom: 16),
            markers: markers,
            polylines: polyline != null ? Set<Polyline>.from([polyline!]) : {},
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
            },
          ),
          Positioned(
            top: 48,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Tiempo: $elapsedTime',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color:
                    Theme.of(context).colorScheme.background.withOpacity(0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: stopwatch.isRunning ? null : startRoute,
                    child: Text(
                      'Iniciar',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: stopwatch.isRunning ? finishRoute : null,
                    child: Text(
                      'Terminar',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'dart:async';
import 'dart:typed_data';
import 'dart:math';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

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
  Timer? timer;
  int secondsElapsed = 0;
  double totalDistance = 0.0;

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
          if (timer != null && timer!.isActive) {
            polylineCoordinates.add(LatLng(
              newLocation.latitude!,
              newLocation.longitude!,
            ));
            updatePolyline();
            updateDistance();
          }
        });
      });
    } catch (e) {
      print('Error al iniciar el servicio de ubicación: $e');
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

      timer?.cancel();
      secondsElapsed = 0;
      totalDistance = 0.0;
      timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
        setState(() {
          secondsElapsed++;
        });
      });
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

      timer?.cancel();
      timer = null;
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

  void updateDistance() {
    if (polylineCoordinates.length >= 2) {
      final LatLng lastPosition =
          polylineCoordinates[polylineCoordinates.length - 2];
      final LatLng currentPosition = polylineCoordinates.last;
      final double distance = calculateDistance(lastPosition, currentPosition);
      setState(() {
        totalDistance += distance;
      });
    }
  }

  double calculateDistance(LatLng fromPosition, LatLng toPosition) {
    const int earthRadius = 6371000; // Radio de la Tierra en metros
    final double lat1 = fromPosition.latitude;
    final double lon1 = fromPosition.longitude;
    final double lat2 = toPosition.latitude;
    final double lon2 = toPosition.longitude;

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_toRadians(lat1)) *
            cos(_toRadians(lat2)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final double c = 2 * asin(sqrt(a));

    return earthRadius * c;
  }

  double _toRadians(double degree) {
    return degree * (pi / 180);
  }

  Future<void> captureScreenshot() async {
    try {
      final Uint8List? imageBytes = await mapController.takeSnapshot();
      final String timestamp =
          DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final String formattedTime = Duration(seconds: secondsElapsed)
          .toString()
          .split('.')
          .first
          .padLeft(8, '0');
      final String formattedDistance = totalDistance.toStringAsFixed(2);
      final String filename =
          'screenshot_$timestamp-$formattedTime-$formattedDistance.jpg';
      final result =
          await ImageGallerySaver.saveImage(imageBytes!, name: filename);

      if (result['isSuccess']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Captura de pantalla guardada en la galería'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No se pudo guardar la captura de pantalla'),
          ),
        );
      }

      print('Ruta de la captura de pantalla guardada: ${result['filePath']}');
    } catch (e) {
      print('Error al capturar la pantalla: $e');
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String formattedTime = Duration(seconds: secondsElapsed)
        .toString()
        .split('.')
        .first
        .padLeft(8, '0');
    final String formattedDistance = totalDistance.toStringAsFixed(2);

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(-36.6297, -71.8330),
              zoom: 17,
            ),
            markers: markers,
            polylines: polyline != null ? <Polyline>{polyline!} : {},
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
              child: Column(
                children: [
                  Text(
                    'Tiempo: $formattedTime',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  Text(
                    'Distancia: $formattedDistance metros',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
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
                    onPressed:
                        timer != null && timer!.isActive ? null : startRoute,
                    child: Text(
                      'Iniciar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed:
                        timer != null && timer!.isActive ? finishRoute : null,
                    child: Text(
                      'Terminar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: captureScreenshot,
                    child: Text(
                      'Capturar',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.tertiary,
                      ),
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

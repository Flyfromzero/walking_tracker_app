import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:walking_tracker_app/services/location_service.dart';
import 'package:walking_tracker_app/services/routes_service.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  final Map<String, Marker> _markers = {};
  final RoutesService _routesService = RoutesService();
  final List<Polyline> _polylines = [];

  @override
  void initState() {
    super.initState();
    _initializeMap();
  }

  Future<void> _initializeMap() async {
    await _getCurrentLocation();
    await _generateRoute();
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await LocationService.getCurrentPosition();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _mapController.animateCamera(CameraUpdate.newLatLng(_currentPosition));
        _markers['currentLocation'] = Marker(
          markerId: const MarkerId('currentLocation'),
          position: _currentPosition,
          infoWindow: const InfoWindow(
            title: 'My Location',
          ),
        );
      });
    } catch (e) {
      print('Error getting current location: $e');
    }
  }

  Future<void> _generateRoute() async {
    try {
      final result = await _routesService.generateRoute();
      final graph = result['graph'] as Map<LatLng, List<LatLng>>;
      final route = result['route'] as List<LatLng>;

      setState(() {
        // Plot the graph
        graph.forEach((start, ends) {
          for (final end in ends) {
            _polylines.add(
              Polyline(
                polylineId: PolylineId('${start.latitude},${start.longitude}-${end.latitude},${end.longitude}'),
                points: [start, end],
                color: Colors.grey,
                width: 2,
              ),
            );
          }
        });

        // Plot the route
        _polylines.add(
          Polyline(
            polylineId: const PolylineId('route'),
            points: route,
            color: Colors.red,
            width: 5,
          ),
        );
      });
    } catch (e) {
      print('Error generating route: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: (controller) {
        _mapController = controller;
      },
      initialCameraPosition: CameraPosition(
        target: _currentPosition,
        zoom: 15,
      ),
      markers: _markers.values.toSet(),
      polylines: _polylines.toSet(),
    );
  }
}

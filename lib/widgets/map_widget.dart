import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:walking_tracker_app/services/location_service.dart';
import 'package:walking_tracker_app/services/step_counter_service.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({super.key});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  late GoogleMapController _mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  final Map<String, Marker> _markers = {};
  final StepCounterService _stepCounterService = StepCounterService();

  @override
  void initState() {
    super.initState();
    _stepCounterService.initStepCounter(() {
      setState(() {});
    });
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
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
  }

  @override
  void dispose() {
    _stepCounterService.dispose();
    super.dispose();
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
    );
  }
}
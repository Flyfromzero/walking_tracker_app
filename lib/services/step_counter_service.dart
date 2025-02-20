import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:geolocator/geolocator.dart';

class StepCounterService {
  late StreamSubscription<StepCount> _stepCountSubscription;
  int _stepCount = 0;
  int _initialStepCount = 0;
  double _totalDistance = 0.0;
  final DateTime _startTime = DateTime.now();
  Position? _lastPosition;

  double get totalDistance => _totalDistance;
  DateTime get startTime => _startTime;
  void initStepCounter(VoidCallback onStepCountUpdated) {
    _stepCountSubscription = Pedometer.stepCountStream.listen(
      (event) {
        if (_initialStepCount == 0) {
          _initialStepCount = event.steps;
        }
        _stepCount = event.steps - _initialStepCount;
        onStepCountUpdated();
      },
      onError: (error) {
        print('Step Count Error: $error');
      },
    );

    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _updateDistance();
      onStepCountUpdated();
    });
  }

  Future<void> _updateDistance() async {
    final position = await Geolocator.getCurrentPosition();
    if (_lastPosition != null) {
      double distance = Geolocator.distanceBetween(
        _lastPosition!.latitude,
        _lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );
      _totalDistance += distance / 1000; // convert to kilometers
    }
    _lastPosition = position;
  }

  int get stepCount => _stepCount;

  void dispose() {
    _stepCountSubscription.cancel();
  }
}
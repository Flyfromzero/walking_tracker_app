import 'package:flutter/material.dart';
import 'package:walking_tracker_app/widgets/map_widget.dart';
import 'package:walking_tracker_app/services/step_counter_service.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final StepCounterService _stepCounterService = StepCounterService();
  bool _isServiceRunning = false;

  void _toggleService() {
    if (_isServiceRunning) {
      _stepCounterService.dispose();
      _stepCounterService.reset();
    } else {
      _stepCounterService.initStepCounter(() {
        setState(() {});
      });
    }
    setState(() {
      _isServiceRunning = !_isServiceRunning;
    });
  }

  @override
  void dispose() {
    if (_isServiceRunning) {
      _stepCounterService.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double elapsedTime = DateTime.now().difference(_stepCounterService.startTime).inSeconds / 3600; // in hours
    double averageSpeed = _stepCounterService.totalDistance / elapsedTime; // in km/h

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Routes Near Me'),
          elevation: 2,
        ),
        body: Column(
          children: [
            const Expanded(
              child: MapWidget(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text('Steps: ${_stepCounterService.stepCount}'),
                  Text('Distance: ${_stepCounterService.totalDistance.toStringAsFixed(2)} km'),
                  Text('Speed: ${averageSpeed.toStringAsFixed(2)} km/h'),
                  ElevatedButton(
                    onPressed: _toggleService,
                    child: Text(_isServiceRunning ? 'Stop' : 'Start'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
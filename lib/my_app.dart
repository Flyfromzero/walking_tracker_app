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

  @override
  void initState() {
    super.initState();
    _stepCounterService.initStepCounter(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _stepCounterService.dispose();
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
          title: const Text('Map Near Me'),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
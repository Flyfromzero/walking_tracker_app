import 'package:flutter/material.dart';
import 'package:walking_tracker_app/widgets/walking_plan_form.dart';
import 'package:walking_tracker_app/my_app.dart';

class Intro extends StatelessWidget {
  const Intro({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Walking Tracker App'),
      ),
      body: WalkingPlanForm(
        onSubmit: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MyApp()),
          );
        },
      ),
    );
  }
}

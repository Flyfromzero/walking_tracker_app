import 'package:flutter/material.dart';

class WalkingPlanForm extends StatefulWidget {
  final VoidCallback onSubmit;

  const WalkingPlanForm({super.key, required this.onSubmit});

  @override
  State<WalkingPlanForm> createState() => _WalkingPlanFormState();
}

class _WalkingPlanFormState extends State<WalkingPlanForm> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  String _walkingPlanCycle = 'Weekly';
  String _walkingIntensityLevel = 'Moderate';
  String _walkingFrequencyLevel = '3 times a week';

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final age = int.parse(_ageController.text);
      final height = double.parse(_heightController.text);
      final weight = double.parse(_weightController.text);
      final walkingPlanCycle = _walkingPlanCycle;
      final walkingIntensityLevel = _walkingIntensityLevel;
      final walkingFrequencyLevel = _walkingFrequencyLevel;

      // Generate walking plan
      final walkingPlan = _generateWalkingPlan(
        age,
        height,
        weight,
        walkingPlanCycle,
        walkingIntensityLevel,
        walkingFrequencyLevel,
      );

      // Display walking plan
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Walking Plan'),
          content: Text(walkingPlan),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      widget.onSubmit(); // Trigger navigation
    }
  }

  String _generateWalkingPlan(
    int age,
    double height,
    double weight,
    String walkingPlanCycle,
    String walkingIntensityLevel,
    String walkingFrequencyLevel,
  ) {
    // Placeholder for walking plan generation logic
    return 'Walking Plan: \nAge: $age\nHeight: $height\nWeight: $weight\nCycle: $walkingPlanCycle\nIntensity: $walkingIntensityLevel\nFrequency: $walkingFrequencyLevel';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(labelText: 'Height (cm)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your height';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your weight';
                }
                return null;
              },
            ),
            DropdownButtonFormField<String>(
              value: _walkingPlanCycle,
              decoration: const InputDecoration(labelText: 'Walking Plan Cycle'),
              items: ['Daily', 'Weekly', 'Monthly']
                  .map((cycle) => DropdownMenuItem(
                        value: cycle,
                        child: Text(cycle),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _walkingPlanCycle = value!;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _walkingIntensityLevel,
              decoration: const InputDecoration(labelText: 'Walking Intensity Level'),
              items: ['Light', 'Moderate', 'Intense']
                  .map((intensity) => DropdownMenuItem(
                        value: intensity,
                        child: Text(intensity),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _walkingIntensityLevel = value!;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: _walkingFrequencyLevel,
              decoration: const InputDecoration(labelText: 'Walking Frequency Level'),
              items: ['1 time a week', '2 times a week', '3 times a week', '4 times a week', '5 times a week']
                  .map((frequency) => DropdownMenuItem(
                        value: frequency,
                        child: Text(frequency),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _walkingFrequencyLevel = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Generate Walking Plan'),
            ),
          ],
        ),
      ),
    );
  }
}
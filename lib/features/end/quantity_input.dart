import 'package:flutter/material.dart';
import 'summary_calculations.dart';

class QuantityInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final VoidCallback onChanged;

  const QuantityInput({
    super.key,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 60,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                controller.text = '';
              }
              onChanged();
            },
          ),
        ),
      ],
    );
  }
}

class QuantityInputWithPercentage extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextEditingController soldController;
  final VoidCallback onChanged;

  const QuantityInputWithPercentage({
    super.key,
    required this.label,
    required this.controller,
    required this.soldController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 60,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.all(8.0),
            ),
            onChanged: (value) {
              if (value.isEmpty) {
                controller.text = '';
              }
              onChanged();
            },
          ),
        ),
        Text(
          calculatePercentage(controller.text, soldController.text),
          style: const TextStyle(
            fontSize: 12,
            fontFamily: 'Cairo',
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

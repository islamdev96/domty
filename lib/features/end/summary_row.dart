import 'package:domty/features/end/quantity_input.dart';
import 'package:domty/features/end/summary_utils.dart';
import 'package:flutter/material.dart';

class SummaryRow extends StatelessWidget {
  final String name;
  final TextEditingController soldController;
  final TextEditingController returnController;
  final TextEditingController goodController;
  final VoidCallback onChanged;

  const SummaryRow({
    super.key,
    required this.name,
    required this.soldController,
    required this.returnController,
    required this.goodController,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            arabicNames[name] ?? name,
            style: const TextStyle(fontSize: 16, fontFamily: 'Cairo'),
          ),
          QuantityInput(
            label: 'مباع',
            controller: soldController,
            onChanged: onChanged,
          ),
          QuantityInputWithPercentage(
            label: 'هالك',
            controller: returnController,
            soldController: soldController,
            onChanged: onChanged,
          ),
          QuantityInput(
            label: 'صالح',
            controller: goodController,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

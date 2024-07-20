// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'summary_row.dart';
import 'summary_calculations.dart';
import 'summary_actions.dart';
import 'summary_utils.dart';

class SummaryPage extends StatefulWidget {
  final Map<String, int> initialSold;
  final Map<String, int> initialReturns;
  final Map<String, int> initialGood;

  const SummaryPage({
    super.key,
    required this.initialSold,
    required this.initialReturns,
    required this.initialGood,
  });

  @override
  _SummaryPageState createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  final ScreenshotController screenshotController = ScreenshotController();
  final ScrollController _scrollController = ScrollController();
  late Map<String, TextEditingController> soldControllers;
  late Map<String, TextEditingController> returnControllers;
  late Map<String, TextEditingController> goodControllers;
  TextEditingController juiceSoldController = TextEditingController();
  TextEditingController juiceReturnController = TextEditingController();
  TextEditingController juiceGoodController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeControllers();
  }

  void initializeControllers() {
    soldControllers = widget.initialSold.map((key, value) => MapEntry(
        key,
        TextEditingController(
            text:
                value == 0 ? '' : (value * getPiecesPerBox(key)).toString())));
    returnControllers = widget.initialReturns.map((key, value) => MapEntry(
        key, TextEditingController(text: value == 0 ? '' : value.toString())));
    goodControllers = widget.initialGood.map((key, value) => MapEntry(
        key, TextEditingController(text: value == 0 ? '' : value.toString())));
  }

  @override
  void dispose() {
    disposeControllers();
    _scrollController.dispose();
    super.dispose();
  }

  void disposeControllers() {
    for (var controller in soldControllers.values) {
      controller.dispose();
    }
    for (var controller in returnControllers.values) {
      controller.dispose();
    }
    for (var controller in goodControllers.values) {
      controller.dispose();
    }
    juiceSoldController.dispose();
    juiceReturnController.dispose();
    juiceGoodController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملخص نهاية اليوم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () => copyToClipboard(context, getFullSummaryText()),
            tooltip: 'نسخ الملخص',
          ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: buildScreenshotContent(),
        ),
      ),
    );
  }

  Widget buildScreenshotContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص نهاية اليوم',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 20),
          ...buildSummaryRows(),
          const SizedBox(height: 20),
          buildTotalRevenue(),
          const SizedBox(height: 20),
          ...buildTotalSummaryItems(),
        ],
      ),
    );
  }

  List<Widget> buildSummaryRows() {
    return [
      for (var key in soldControllers.keys)
        SummaryRow(
          name: key,
          soldController: soldControllers[key]!,
          returnController: returnControllers[key]!,
          goodController: goodControllers[key]!,
          onChanged: () => setState(() {}),
        ),
      SummaryRow(
        name: 'عصير',
        soldController: juiceSoldController,
        returnController: juiceReturnController,
        goodController: juiceGoodController,
        onChanged: () => setState(() {}),
      ),
    ];
  }

  Widget buildTotalRevenue() {
    return Text(
      'نقدية: ${formatCurrency(calculateTotalRevenue(soldControllers, returnControllers, goodControllers, juiceSoldController, juiceReturnController, juiceGoodController))}',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Cairo',
      ),
    );
  }

  List<Widget> buildTotalSummaryItems() {
    return [
      buildSummaryItem('إجمالي القطع المباعة', calculateTotalSold()),
      buildSummaryItem('إجمالي القطع الهالكة', calculateTotalReturns()),
      buildSummaryItem('إجمالي القطع الصالحة', calculateTotalGood()),
    ];
  }

  Widget buildSummaryItem(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '$value',
            style: const TextStyle(fontSize: 18, fontFamily: 'Cairo'),
          ),
        ],
      ),
    );
  }

  int calculateTotalSold() {
    return soldControllers.values
            .map((controller) => int.tryParse(controller.text) ?? 0)
            .reduce((a, b) => a + b) +
        (int.tryParse(juiceSoldController.text) ?? 0);
  }

  int calculateTotalReturns() {
    return returnControllers.values
            .map((controller) => int.tryParse(controller.text) ?? 0)
            .reduce((a, b) => a + b) +
        (int.tryParse(juiceReturnController.text) ?? 0);
  }

  int calculateTotalGood() {
    return goodControllers.values
            .map((controller) => int.tryParse(controller.text) ?? 0)
            .reduce((a, b) => a + b) +
        (int.tryParse(juiceGoodController.text) ?? 0);
  }

  String getFullSummaryText() {
    // Implement this method to return the full summary text
    // This should include all the details for clipboard copying
    return ""; // Placeholder
  }
}

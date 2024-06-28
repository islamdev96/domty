import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:cross_file/cross_file.dart';

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

  final Map<String, String> arabicNames = {
    'classic': 'كلاسيك',
    'croissant': 'كرواسون',
    'supreme': 'سوبريم',
    'double': 'دبل',
    'fino': 'فينو',
    'basket': 'باسكت',
    'aseer': 'عصير',
  };

  @override
  void initState() {
    super.initState();
    soldControllers = widget.initialSold.map((key, value) => MapEntry(
        key,
        TextEditingController(
            text:
                value == 0 ? '' : (value * _getPiecesPerBox(key)).toString())));
    returnControllers = widget.initialReturns.map((key, value) => MapEntry(
        key, TextEditingController(text: value == 0 ? '' : value.toString())));
    goodControllers = widget.initialGood.map((key, value) => MapEntry(
        key, TextEditingController(text: value == 0 ? '' : value.toString())));

    juiceSoldController.text = '';
    juiceReturnController.text = '';
    juiceGoodController.text = '';
  }

  @override
  void dispose() {
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
    _scrollController.dispose();
    super.dispose();
  }

  int _getPiecesPerBox(String key) {
    switch (key) {
      case 'classic':
        return 30;
      case 'croissant':
      case 'supreme':
      case 'double':
        return 24;
      case 'fino':
        return 8;
      case 'basket':
        return 10;
      case 'aseer':
      default:
        return 1;
    }
  }

  double _getPricePerPiece(String key) {
    if (key == 'fino') {
      return 20.0;
    } else {
      return 8.5;
    }
  }

  Widget _buildSummaryRow(String name) {
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
          _buildQuantityColumn('مباع', soldControllers[name]!, (value) {
            setState(() {
              soldControllers[name]!.text = value;
            });
          }),
          _buildQuantityColumn('هالك', returnControllers[name]!, (value) {
            setState(() {
              returnControllers[name]!.text = value;
            });
          }),
          _buildQuantityColumn('صالح', goodControllers[name]!, (value) {
            setState(() {
              goodControllers[name]!.text = value;
            });
          }),
        ],
      ),
    );
  }

  Widget _buildQuantityColumn(String label, TextEditingController controller,
      Function(String) onChanged) {
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
              onChanged(value);
            },
          ),
        ),
      ],
    );
  }

  double calculateTotalRevenue() {
    double totalRevenue = 0.0;

    soldControllers.forEach((key, controller) {
      int soldQuantity = int.tryParse(controller.text) ?? 0;
      int returnQuantity = int.tryParse(returnControllers[key]!.text) ?? 0;
      int goodQuantity = int.tryParse(goodControllers[key]!.text) ?? 0;
      double pricePerPiece = _getPricePerPiece(key);
      totalRevenue +=
          (soldQuantity - returnQuantity - goodQuantity) * pricePerPiece;
    });

    // Add juice cartons to the revenue
    int juiceSoldQuantity = int.tryParse(juiceSoldController.text) ?? 0;
    int juiceReturnQuantity = int.tryParse(juiceReturnController.text) ?? 0;
    int juiceGoodQuantity = int.tryParse(juiceGoodController.text) ?? 0;
    totalRevenue +=
        (juiceSoldQuantity - juiceReturnQuantity - juiceGoodQuantity) * 180.0;

    return totalRevenue;
  }

  Widget _buildSummaryItem(String label, int value) {
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

  Future<void> _takeAndShareScreenshot() async {
    try {
      await _scrollToTop();
      final fullHeight = _scrollController.position.maxScrollExtent +
          MediaQuery.of(context).size.height;
      final Uint8List image = await screenshotController.captureFromLongWidget(
        InheritedTheme.captureAll(
          context,
          Material(
            child: _buildScreenshotContent(),
          ),
        ),
        delay: const Duration(milliseconds: 100),
        constraints: BoxConstraints(
          maxHeight: fullHeight,
          maxWidth: MediaQuery.of(context).size.width,
        ),
      );

      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          await File('${directory.path}/summary_screenshot.png').create();
      await imagePath.writeAsBytes(image);

      await Share.shareXFiles([XFile(imagePath.path)],
          text: 'ملخص نهاية اليوم');
    } catch (e) {
      print('Error taking screenshot: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('حدث خطأ أثناء مشاركة الملخص')),
      );
    }
  }

  Future<void> _scrollToTop() async {
    await _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );
  }

  Widget _buildScreenshotContent() {
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
          for (var key in soldControllers.keys) _buildSummaryRow(key),
          Container(
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.symmetric(vertical: 4.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'عصير',
                  style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                ),
                _buildQuantityColumn('مباع', juiceSoldController, (value) {
                  if (value.isNotEmpty && int.tryParse(value) == null) {
                    return;
                  }
                  setState(() {});
                }),
                _buildQuantityColumn('هالك', juiceReturnController, (value) {
                  if (value.isNotEmpty && int.tryParse(value) == null) {
                    return;
                  }
                  setState(() {});
                }),
                _buildQuantityColumn('صالح', juiceGoodController, (value) {
                  if (value.isNotEmpty && int.tryParse(value) == null) {
                    return;
                  }
                  setState(() {});
                }),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'نقدية: ${intl.NumberFormat('#,##0.00', 'ar_EG').format(calculateTotalRevenue())}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          const SizedBox(height: 20),
          _buildSummaryItem(
            'إجمالي القطع المباعة',
            soldControllers.values
                    .map((controller) => int.tryParse(controller.text) ?? 0)
                    .reduce((a, b) => a + b) +
                (int.tryParse(juiceSoldController.text) ?? 0),
          ),
          _buildSummaryItem(
            'إجمالي القطع الهالكة',
            returnControllers.values
                    .map((controller) => int.tryParse(controller.text) ?? 0)
                    .reduce((a, b) => a + b) +
                (int.tryParse(juiceReturnController.text) ?? 0),
          ),
          _buildSummaryItem(
            'إجمالي القطع الصالحة',
            goodControllers.values
                    .map((controller) => int.tryParse(controller.text) ?? 0)
                    .reduce((a, b) => a + b) +
                (int.tryParse(juiceGoodController.text) ?? 0),
          ),
        ],
      ),
    );
  }

  Future<void> _copyToClipboard() async {
    String summaryText = 'ملخص نهاية اليوم\n\n';

    for (var key in soldControllers.keys) {
      summaryText += '${arabicNames[key] ?? key}:\n';
      summaryText +=
          'مباع: ${soldControllers[key]!.text.isEmpty ? '0' : soldControllers[key]!.text}\n';
      summaryText +=
          'هالك: ${returnControllers[key]!.text.isEmpty ? '0' : returnControllers[key]!.text}\n';
      summaryText +=
          'صالح: ${goodControllers[key]!.text.isEmpty ? '0' : goodControllers[key]!.text}\n\n';
    }

    summaryText += 'عصير:\n';
    summaryText +=
        'مباع: ${juiceSoldController.text.isEmpty ? '0' : juiceSoldController.text}\n';
    summaryText +=
        'هالك: ${juiceReturnController.text.isEmpty ? '0' : juiceReturnController.text}\n';
    summaryText +=
        'صالح: ${juiceGoodController.text.isEmpty ? '0' : juiceGoodController.text}\n\n';

    summaryText +=
        'نقدية: ${intl.NumberFormat('#,##0.00', 'ar_EG').format(calculateTotalRevenue())}\n\n';

    int totalSold = soldControllers.values
            .map((controller) => int.tryParse(controller.text) ?? 0)
            .reduce((a, b) => a + b) +
        (int.tryParse(juiceSoldController.text) ?? 0);
    int totalReturns = returnControllers.values
            .map((controller) => int.tryParse(controller.text) ?? 0)
            .reduce((a, b) => a + b) +
        (int.tryParse(juiceReturnController.text) ?? 0);
    int totalGood = goodControllers.values
            .map((controller) => int.tryParse(controller.text) ?? 0)
            .reduce((a, b) => a + b) +
        (int.tryParse(juiceGoodController.text) ?? 0);

    summaryText += 'إجمالي القطع المباعة: $totalSold\n';
    summaryText += 'إجمالي القطع الهالكة: $totalReturns\n';
    summaryText += 'إجمالي القطع الصالحة: $totalGood\n';

    await Clipboard.setData(ClipboardData(text: summaryText));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم نسخ الملخص إلى الحافظة')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ملخص نهاية اليوم'),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: _copyToClipboard,
            tooltip: 'نسخ الملخص',
          ),
          // IconButton(
          //   icon: const Icon(Icons.share),
          //   onPressed: _takeAndShareScreenshot,
          //   tooltip: 'مشاركة الملخص',
          // ),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: _buildScreenshotContent(),
        ),
      ),
    );
  }
}

// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'package:domty/features/home/screen/summary_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Map<String, TextEditingController> _controllers = {
    'classic': TextEditingController(),
    'croissant': TextEditingController(),
    'supreme': TextEditingController(),
    'double': TextEditingController(),
    'fino': TextEditingController(),
  };

  final Map<String, TextEditingController> _returnControllers = {
    'classic': TextEditingController(),
    'croissant': TextEditingController(),
    'supreme': TextEditingController(),
    'double': TextEditingController(),
    'fino': TextEditingController(),
  };

  final Map<String, TextEditingController> _goodControllers = {
    'classic': TextEditingController(),
    'croissant': TextEditingController(),
    'supreme': TextEditingController(),
    'double': TextEditingController(),
    'fino': TextEditingController(),
  };

  double _currentScale = 1.0;
  double _baseScale = 1.0;
  final double _minScale = 0.5;
  final double _maxScale = 2.0;

  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPreferences();
  }

  void _loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _controllers.forEach((key, controller) {
        controller.text = (prefs.getInt(key) ?? 0).toString();
      });
      _returnControllers.forEach((key, controller) {
        controller.text = (prefs.getInt('${key}Return') ?? 0).toString();
      });
      _goodControllers.forEach((key, controller) {
        controller.text = (prefs.getInt('${key}Good') ?? 0).toString();
      });
    });
  }

  void _saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _controllers.forEach((key, controller) {
      prefs.setInt(key, int.tryParse(controller.text) ?? 0);
    });
    _returnControllers.forEach((key, controller) {
      prefs.setInt('${key}Return', int.tryParse(controller.text) ?? 0);
    });
    _goodControllers.forEach((key, controller) {
      prefs.setInt('${key}Good', int.tryParse(controller.text) ?? 0);
    });
  }

  // Function to reset data
  void _resetData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _controllers.forEach((key, controller) {
        controller.text = '0';
        prefs.setInt(key, 0);
      });
      _returnControllers.forEach((key, controller) {
        controller.text = '0';
        prefs.setInt('${key}Return', 0);
      });
      _goodControllers.forEach((key, controller) {
        controller.text = '0';
        prefs.setInt('${key}Good', 0);
      });
    });
  }

  String _getFormattedDay() {
    DateTime now = DateTime.now();
    String formattedDay = intl.DateFormat('EEEE', 'ar').format(now);
    return 'اليوم $formattedDay';
  }

  String _getFormattedDate() {
    DateTime now = DateTime.now();
    String formattedDate = intl.DateFormat('d/M/yyyy').format(now);
    return formattedDate;
  }

  Widget _buildTable() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onScaleStart: (ScaleStartDetails details) {
            _baseScale = _currentScale;
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            setState(() {
              _currentScale =
                  (_baseScale * details.scale).clamp(_minScale, _maxScale);
            });
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Transform.scale(
              scale: _currentScale,
              child: Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Table(
                    defaultColumnWidth: const IntrinsicColumnWidth(),
                    border: TableBorder.all(color: Colors.grey[300]!),
                    children: [
                      _buildTableRowHeader(),
                      ..._controllers.keys
                          .map((key) => _buildTableRowData(key)),
                      _buildTotalRow(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  TableRow _buildTableRowHeader() {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.2),
      ),
      children: ['الاسم', 'الكمية', 'إجمالي القطع', 'المرتجع', 'الصالح']
          .map((label) => _buildTableCell(label, true))
          .toList(),
    );
  }

  TableRow _buildTableRowData(String key) {
    int itemCount = int.tryParse(_controllers[key]!.text) ?? 0;
    int totalPieces = _calculateTotalPieces(key, itemCount);
    String basketInfo = _getBasketInfo(key, totalPieces);

    return TableRow(
      children: [
        _buildTableCell(key, false),
        _buildTableCell(_buildTextField(_controllers[key]!), false),
        _buildTableCell('$totalPieces', false),
        _buildTableCell(_buildTextField(_returnControllers[key]!), false),
        _buildTableCell(_buildTextField(_goodControllers[key]!), false),
      ],
    );
  }

  int _calculateTotalPieces(String key, int itemCount) {
    switch (key) {
      case 'classic':
        return itemCount * 30;
      case 'croissant':
      case 'supreme':
      case 'double':
        return itemCount * 24;
      case 'fino':
        return itemCount * 8;
      default:
        return itemCount;
    }
  }

  String _getBasketInfo(String key, int totalPieces) {
    int totalBoxes = 0;
    int remainingPieces = 0;

    if (key == 'fino') {
      totalBoxes = totalPieces ~/ 8;
      remainingPieces = totalPieces % 8;
    } else {
      totalBoxes = totalPieces ~/ 30;
      remainingPieces = totalPieces % 30;
    }

    return '$totalBoxes basket\n$remainingPieces قطعة';
  }

  Widget _buildTextField(TextEditingController controller) {
    return SizedBox(
      width: 60,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (_) {
          _saveDataToSharedPreferences();
          setState(() {});
        },
      ),
    );
  }

  TableRow _buildTotalRow() {
    int totalQuantity = _controllers.values
        .map((controller) => int.tryParse(controller.text) ?? 0)
        .reduce((a, b) => a + b);

    int totalPieces = _controllers.entries
        .map((entry) => _calculateTotalPieces(
            entry.key, int.tryParse(entry.value.text) ?? 0))
        .reduce((a, b) => a + b);

    int totalReturns = _returnControllers.values
        .map((controller) => int.tryParse(controller.text) ?? 0)
        .reduce((a, b) => a + b);

    String basketInfo = _getBasketInfo('', totalPieces);

    return TableRow(
      children: [
        _buildTableCell('الإجمالي', true),
        _buildTableCell('$totalQuantity', false),
        _buildTableCell('$totalPieces', false),
        _buildTableCell('$totalReturns', false),
        _buildTableCell('', false),
      ],
    );
  }

  Widget _buildTableCell(dynamic content, bool isHeader) {
    return TableCell(
      child: Container(
        padding: const EdgeInsets.all(8.0),
        width: isHeader ? null : 80,
        child: Center(
          child: isHeader
              ? Text(
                  content,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                )
              : content is String
                  ? Text(
                      content,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    )
                  : content,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية'),
        actions: [
          IconButton(
            icon: const Icon(Icons.summarize),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SummaryPage(
                      initialSold: _controllers.map((key, controller) =>
                          MapEntry(key, int.tryParse(controller.text) ?? 0)),
                      initialReturns: _returnControllers.map((key,
                              controller) =>
                          MapEntry(key, int.tryParse(controller.text) ?? 0)),
                      initialGood: _goodControllers.map((key, controller) =>
                          MapEntry(key, int.tryParse(controller.text) ?? 0))),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 30),
          Column(
            children: [
              Text(
                _getFormattedDay(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                _getFormattedDate(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'بداية اليوم',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _buildTable(),
              // Add the Reset Button here
              Center(
                // Center the button horizontally
                child: ElevatedButton(
                  onPressed: _resetData,
                  child: const Text('Restart'),
                ),
              ),
              const SizedBox(height: 20), // Add spacing
            ],
          ),
        ],
      ),
    );
  }
}

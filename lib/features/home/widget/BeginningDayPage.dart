import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter/services.dart';

class BeginningDayPage extends StatefulWidget {
  const BeginningDayPage({super.key});

  @override
  _BeginningDayPageState createState() => _BeginningDayPageState();
}

class _BeginningDayPageState extends State<BeginningDayPage> {
  final TextEditingController _classicController = TextEditingController();
  final TextEditingController _croissantController = TextEditingController();
  final TextEditingController _supremeController = TextEditingController();
  final TextEditingController _doubleController = TextEditingController();
  final TextEditingController _finoController = TextEditingController();
  final TextEditingController _basketController = TextEditingController();
  final TextEditingController _aseerController = TextEditingController();

  // Controllers for returns
  final TextEditingController _classicReturnController =
      TextEditingController();
  final TextEditingController _croissantReturnController =
      TextEditingController();
  final TextEditingController _supremeReturnController =
      TextEditingController();
  final TextEditingController _doubleReturnController = TextEditingController();
  final TextEditingController _finoReturnController = TextEditingController();
  final TextEditingController _basketReturnController = TextEditingController();
  final TextEditingController _aseerReturnController = TextEditingController();

  // Controllers for manually entered good quantity (Salhe7)
  final TextEditingController _classicGoodController = TextEditingController();
  final TextEditingController _croissantGoodController =
      TextEditingController();
  final TextEditingController _supremeGoodController = TextEditingController();
  final TextEditingController _doubleGoodController = TextEditingController();
  final TextEditingController _finoGoodController = TextEditingController();
  final TextEditingController _aseerGoodController = TextEditingController();

  int totalClassic = 0;
  int totalCroissant = 0;
  int totalSupreme = 0;
  int totalDouble = 0;
  int totalFino = 0;
  int totalBasket = 0;
  int totalAseer = 0;

  int totalQuantity = 0;
  double totalBoxes = 0;

  final double regularPrice = 8.5;
  final double finoPrice = 20.0;
  final double aseerPrice = 8.5;

  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPreferences();
  }

  void _loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _classicController.text = (prefs.getInt('classic') ?? 0).toString();
      _croissantController.text = (prefs.getInt('croissant') ?? 0).toString();
      _supremeController.text = (prefs.getInt('supreme') ?? 0).toString();
      _doubleController.text = (prefs.getInt('double') ?? 0).toString();
      _finoController.text = (prefs.getInt('fino') ?? 0).toString();
      _basketController.text = (prefs.getInt('basket') ?? 0).toString();
      _aseerController.text = (prefs.getInt('aseer') ?? 0).toString();

      _classicReturnController.text =
          (prefs.getInt('classicReturn') ?? 0).toString();
      _croissantReturnController.text =
          (prefs.getInt('croissantReturn') ?? 0).toString();
      _supremeReturnController.text =
          (prefs.getInt('supremeReturn') ?? 0).toString();
      _doubleReturnController.text =
          (prefs.getInt('doubleReturn') ?? 0).toString();
      _finoReturnController.text = (prefs.getInt('finoReturn') ?? 0).toString();
      _basketReturnController.text =
          (prefs.getInt('basketReturn') ?? 0).toString();
      _aseerReturnController.text =
          (prefs.getInt('aseerReturn') ?? 0).toString();

      _classicGoodController.text =
          (prefs.getInt('classicGood') ?? 0).toString();
      _croissantGoodController.text =
          (prefs.getInt('croissantGood') ?? 0).toString();
      _supremeGoodController.text =
          (prefs.getInt('supremeGood') ?? 0).toString();
      _doubleGoodController.text = (prefs.getInt('doubleGood') ?? 0).toString();
      _finoGoodController.text = (prefs.getInt('finoGood') ?? 0).toString();
      _aseerGoodController.text = (prefs.getInt('aseerGood') ?? 0).toString();

      _updateTotals();
    });
  }

  void _saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('classic', int.tryParse(_classicController.text) ?? 0);
    await prefs.setInt(
        'croissant', int.tryParse(_croissantController.text) ?? 0);
    await prefs.setInt('supreme', int.tryParse(_supremeController.text) ?? 0);
    await prefs.setInt('double', int.tryParse(_doubleController.text) ?? 0);
    await prefs.setInt('fino', int.tryParse(_finoController.text) ?? 0);
    await prefs.setInt('basket', int.tryParse(_basketController.text) ?? 0);
    await prefs.setInt('aseer', int.tryParse(_aseerController.text) ?? 0);

    await prefs.setInt(
        'classicReturn', int.tryParse(_classicReturnController.text) ?? 0);
    await prefs.setInt(
        'croissantReturn', int.tryParse(_croissantReturnController.text) ?? 0);
    await prefs.setInt(
        'supremeReturn', int.tryParse(_supremeReturnController.text) ?? 0);
    await prefs.setInt(
        'doubleReturn', int.tryParse(_doubleReturnController.text) ?? 0);
    await prefs.setInt(
        'finoReturn', int.tryParse(_finoReturnController.text) ?? 0);
    await prefs.setInt(
        'basketReturn', int.tryParse(_basketReturnController.text) ?? 0);
    await prefs.setInt(
        'aseerReturn', int.tryParse(_aseerReturnController.text) ?? 0);

    await prefs.setInt(
        'classicGood', int.tryParse(_classicGoodController.text) ?? 0);
    await prefs.setInt(
        'croissantGood', int.tryParse(_croissantGoodController.text) ?? 0);
    await prefs.setInt(
        'supremeGood', int.tryParse(_supremeGoodController.text) ?? 0);
    await prefs.setInt(
        'doubleGood', int.tryParse(_doubleGoodController.text) ?? 0);
    await prefs.setInt('finoGood', int.tryParse(_finoGoodController.text) ?? 0);
    await prefs.setInt(
        'aseerGood', int.tryParse(_aseerGoodController.text) ?? 0);

    _updateTotals();
  }

  void _updateTotals() {
    setState(() {
      totalClassic = int.tryParse(_classicController.text) ?? 0;
      totalCroissant = (int.tryParse(_croissantController.text) ?? 0) * 24;
      totalSupreme = (int.tryParse(_supremeController.text) ?? 0) * 24;
      totalDouble = (int.tryParse(_doubleController.text) ?? 0) * 24;
      totalFino = (int.tryParse(_finoController.text) ?? 0) * 8;
      totalBasket = (int.tryParse(_basketController.text) ?? 0) * 10;
      totalAseer = int.tryParse(_aseerController.text) ?? 0;

      totalQuantity = (int.tryParse(_classicController.text) ?? 0) +
          (int.tryParse(_croissantController.text) ?? 0) +
          (int.tryParse(_supremeController.text) ?? 0) +
          (int.tryParse(_doubleController.text) ?? 0) +
          (int.tryParse(_finoController.text) ?? 0) +
          (int.tryParse(_basketController.text) ?? 0) +
          (int.tryParse(_aseerController.text) ?? 0);

      totalBoxes = (totalClassic +
              totalCroissant +
              totalSupreme +
              totalDouble +
              totalFino / 8 +
              totalBasket +
              totalAseer) /
          30.0;
    });
  }

  void _showSummaryReport() {
    final summaryData = _calculateSummary();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ملخص نهاية اليوم',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildSummaryText(summaryData),
                const SizedBox(height: 20),
                Text(
                  'نقدية: ${intl.NumberFormat('#,##0.00', 'ar_EG').format(summaryData['totalRevenue'])}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    _copyToClipboard(summaryData);
                  },
                  child: const Text('نسخ'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('إغلاق'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildSummaryText(Map<String, dynamic> summaryData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSummaryRow('سندوتش', summaryData['classicSold'],
            summaryData['classicDamaged'], summaryData['classicGood']),
        _buildSummaryRow('سوبريم', summaryData['supremeSold'],
            summaryData['supremeDamaged'], summaryData['supremeGood']),
        _buildSummaryRow('كرواسون', summaryData['croissantSold'],
            summaryData['croissantDamaged'], summaryData['croissantGood']),
        _buildSummaryRow('دبل', summaryData['doubleSold'],
            summaryData['doubleDamaged'], summaryData['doubleGood']),
        _buildSummaryRow('فينو', summaryData['finoSold'],
            summaryData['finoDamaged'], summaryData['finoGood']),
        _buildSummaryRow('عصير', summaryData['aseerSold'],
            summaryData['aseerDamaged'], summaryData['aseerGood']),
        const SizedBox(height: 20),
        Text(
          'نقدية: ${intl.NumberFormat('#,##0.00', 'ar_EG').format(summaryData['totalRevenue'])}',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String name, int sold, int damaged, int good) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$name       $sold',
              style: const TextStyle(fontSize: 16, fontFamily: 'Cairo')),
          Text('هالك       $damaged',
              style: const TextStyle(fontSize: 16, fontFamily: 'Cairo')),
          Text('صالح       $good',
              style: const TextStyle(fontSize: 16, fontFamily: 'Cairo')),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _copyToClipboard(Map<String, dynamic> summaryData) {
    String textToCopy = 'ملخص نهاية اليوم:\n\n';
    textToCopy += _buildClipboardText(summaryData);
    textToCopy +=
        '\nنقدية: ${intl.NumberFormat('#,##0.00', 'ar_EG').format(summaryData['totalRevenue'])}';
    Clipboard.setData(ClipboardData(text: textToCopy)).then((_) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('تم نسخ  الملخص')));
    });
  }

  String _buildClipboardText(Map<String, dynamic> summaryData) {
    String text = "";
    text += _buildClipboardRow('سندوتش', summaryData['classicSold'],
        summaryData['classicDamaged'], summaryData['classicGood']);
    text += _buildClipboardRow('سوبريم', summaryData['supremeSold'],
        summaryData['supremeDamaged'], summaryData['supremeGood']);
    text += _buildClipboardRow('كرواسون', summaryData['croissantSold'],
        summaryData['croissantDamaged'], summaryData['croissantGood']);
    text += _buildClipboardRow('دبل', summaryData['doubleSold'],
        summaryData['doubleDamaged'], summaryData['doubleGood']);
    text += _buildClipboardRow('فينو', summaryData['finoSold'],
        summaryData['finoDamaged'], summaryData['finoGood']);
    text += _buildClipboardRow('عصير', summaryData['aseerSold'],
        summaryData['aseerDamaged'], summaryData['aseerGood']);

    return text;
  }

  String _buildClipboardRow(String name, int sold, int damaged, int good) {
    return '$name       $sold         $damaged        $good\n';
  }

  TableRow _buildTableRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      decoration: BoxDecoration(
        color: isHeader ? Colors.teal.withOpacity(0.2) : null,
      ),
      children: cells
          .map((cell) => TableCell(
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  alignment: Alignment.center,
                  child: Text(
                    cell,
                    style: TextStyle(
                      fontWeight:
                          isHeader ? FontWeight.bold : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }

  TableRow _buildTableRowData(
    String label,
    TextEditingController controller,
    TextEditingController returnController,
    TextEditingController goodController,
    int boxQuantity,
  ) {
    int itemCount = int.tryParse(controller.text) ?? 0;
    int totalPieces = 0;
    int totalBoxes = 0;
    int remainingPieces = 0;

    switch (label) {
      case 'كلاسيك':
        totalPieces = itemCount * 30;
        totalBoxes = totalPieces ~/ 30;
        remainingPieces = totalPieces % 30;
        break;
      case 'كرواسون':
      case 'سوبريم':
      case 'دبل':
        totalPieces = itemCount * 24;
        break;
      case 'فينو':
        totalPieces = itemCount * 8;
        totalBoxes = totalPieces ~/ 8;
        remainingPieces = totalPieces % 8;
        break;
      default:
        totalPieces = 0;
    }

    if (label != 'كلاسيك' && label != 'فينو') {
      totalBoxes = totalPieces ~/ 30;
      remainingPieces = totalPieces % 30;
    }

    return TableRow(
      children: [
        _buildTableCell(label, false),
        _buildTableCell(
          SizedBox(
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
          ),
          false,
        ),
        _buildTableCell(
          '$totalPieces',
          false,
        ),
        _buildTableCell(
          label == 'كلاسيك'
              ? '$totalBoxes basket     $remainingPieces قطعة'
              : label == 'فينو'
                  ? '$totalBoxes basket     $remainingPieces قطعة'
                  : '$totalBoxes basket     $remainingPieces قطعة',
          false,
        ),
        _buildTableCell(
          SizedBox(
            width: 60,
            child: TextField(
              controller: returnController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (_) {
                _saveDataToSharedPreferences();
                setState(() {});
              },
            ),
          ),
          false,
        ),
        _buildTableCell(
          SizedBox(
            width: 60,
            child: TextField(
              controller: goodController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              onChanged: (_) {
                _saveDataToSharedPreferences();
                setState(() {});
              },
            ),
          ),
          false,
        ),
      ],
    );
  }

  TableRow _buildTotalRow() {
    int totalPieces = totalClassic * 30 +
        totalCroissant +
        totalSupreme +
        totalDouble +
        totalFino +
        totalBasket +
        totalAseer;

    int totalFinoBoxes = totalFino ~/ 8;
    int remainingFinoPieces = totalFino % 8;

    int otherTotalPieces = totalClassic * 30 +
        totalCroissant +
        totalSupreme +
        totalDouble +
        totalBasket +
        totalAseer;
    int totalBoxes = otherTotalPieces ~/ 30;
    int remainingPieces = otherTotalPieces % 30;

    int totalReturns = (int.tryParse(_classicReturnController.text) ?? 0) +
        (int.tryParse(_croissantReturnController.text) ?? 0) +
        (int.tryParse(_supremeReturnController.text) ?? 0) +
        (int.tryParse(_doubleReturnController.text) ?? 0) +
        (int.tryParse(_finoReturnController.text) ?? 0) +
        (int.tryParse(_basketReturnController.text) ?? 0) +
        (int.tryParse(_aseerReturnController.text) ?? 0);

    return TableRow(
      children: [
        _buildTableCell('الإجمالي', true),
        _buildTableCell('$totalQuantity', false),
        _buildTableCell(
          '$totalPieces',
          false,
        ),
        _buildTableCell(
          'باتيه\n$totalBoxes basket \n$remainingPieces قطعة \n'
          ' فينو\n$totalFinoBoxes basket  \n$remainingFinoPieces قطعة',
          false,
        ),
        _buildTableCell('$totalReturns', false),
        _buildTableCell(
          '',
          false,
        ),
      ],
    );
  }

  Widget _buildTableCell(dynamic content, bool isHeader) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: isHeader
              ? Text(
                  content,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                )
              : content is String
                  ? Text(
                      content,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontFamily: 'Cairo'),
                    )
                  : content,
        ),
      ),
    );
  }

  Map<String, dynamic> _calculateSummary() {
    final summary = {
      'classicSold': int.tryParse(_classicController.text) ?? 0,
      'supremeSold': (int.tryParse(_supremeController.text) ?? 0) * 24,
      'croissantSold': (int.tryParse(_croissantController.text) ?? 0) * 24,
      'doubleSold': (int.tryParse(_doubleController.text) ?? 0) * 24,
      'finoSold': (int.tryParse(_finoController.text) ?? 0) * 8,
      'aseerSold': int.tryParse(_aseerController.text) ?? 0,
      'classicDamaged': int.tryParse(_classicReturnController.text) ?? 0,
      'supremeDamaged': int.tryParse(_supremeReturnController.text) ?? 0,
      'croissantDamaged': int.tryParse(_croissantReturnController.text) ?? 0,
      'doubleDamaged': int.tryParse(_doubleReturnController.text) ?? 0,
      'finoDamaged': int.tryParse(_finoReturnController.text) ?? 0,
      'aseerDamaged': int.tryParse(_aseerReturnController.text) ?? 0,
      'classicGood': int.tryParse(_classicGoodController.text) ?? 0,
      'supremeGood': int.tryParse(_supremeGoodController.text) ?? 0,
      'croissantGood': int.tryParse(_croissantGoodController.text) ?? 0,
      'doubleGood': int.tryParse(_doubleGoodController.text) ?? 0,
      'finoGood': int.tryParse(_finoGoodController.text) ?? 0,
      'aseerGood': int.tryParse(_aseerGoodController.text) ?? 0,
    };

    summary['classicGood'] = 0;
    summary['supremeGood'] = 0;
    summary['croissantGood'] = 0;
    summary['doubleGood'] = 0;
    summary['finoGood'] = 0;
    summary['aseerGood'] = 0;

    double revenue = (summary['classicGood']! +
            summary['supremeGood']! +
            summary['croissantGood']! +
            summary['doubleGood']! +
            summary['aseerGood']!) *
        regularPrice;
    revenue += summary['finoGood']! * finoPrice;
    summary['totalRevenue'] = revenue.toInt();

    return summary;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.2),
                    1: FlexColumnWidth(1),
                    2: FlexColumnWidth(1.2),
                    3: FlexColumnWidth(1.8),
                    4: FlexColumnWidth(1),
                    5: FlexColumnWidth(1),
                  },
                  border: TableBorder.all(color: Colors.grey[300]!),
                  children: [
                    _buildTableRowHeader('الاسم', 'الكمية', 'إجمالي القطع',
                        'basket', 'المرتجع', 'الصالح'),
                    _buildTableRowData('كلاسيك', _classicController,
                        _classicReturnController, _classicGoodController, 30),
                    _buildTableRowData(
                        'كرواسون',
                        _croissantController,
                        _croissantReturnController,
                        _croissantGoodController,
                        24),
                    _buildTableRowData('سوبريم', _supremeController,
                        _supremeReturnController, _supremeGoodController, 24),
                    _buildTableRowData('دبل', _doubleController,
                        _doubleReturnController, _doubleGoodController, 24),
                    _buildTableRowData('فينو', _finoController,
                        _finoReturnController, _finoGoodController, 8),
                    _buildTableRowData('عصير', _aseerController,
                        _aseerReturnController, _aseerGoodController, 30),
                    _buildTotalRow(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _showSummaryReport,
              child: const Text('عرض ملخص نهاية اليوم'),
            ),
          ],
        ),
      ],
    );
  }

  TableRow _buildTableRowHeader(String label1, String label2, String label3,
      String label4, String label5, String label6) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.2),
      ),
      children: [
        _buildTableCell(label1, true),
        _buildTableCell(label2, true),
        _buildTableCell(label3, true),
        _buildTableCell(label4, true),
        _buildTableCell(label5, true),
        _buildTableCell(label6, true),
      ],
    );
  }
}

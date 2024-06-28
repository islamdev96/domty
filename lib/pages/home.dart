import 'package:domty/features/other/top_of_the_page/page_app_bar.dart';

import '../all_export.dart';

class CalculationPage extends StatefulWidget {
  const CalculationPage({super.key});

  @override
  _CalculationPageState createState() => _CalculationPageState();
}

class _CalculationPageState extends State<CalculationPage> {
  final TextEditingController _classicController = TextEditingController();
  final TextEditingController _croissantController = TextEditingController();
  final TextEditingController _supremeController = TextEditingController();
  final TextEditingController _doubleController = TextEditingController();

  final TextEditingController _classicReturnedController =
      TextEditingController();
  final TextEditingController _croissantReturnedController =
      TextEditingController();
  final TextEditingController _supremeReturnedController =
      TextEditingController();
  final TextEditingController _doubleReturnedController =
      TextEditingController();

  int _totalQuantity = 0;

  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPreferences();
  }

  @override
  void dispose() {
    _saveDataToSharedPreferences();
    super.dispose();
  }

  void _calculateTotalQuantity() {
    setState(() {
      _totalQuantity = (int.tryParse(_classicController.text) ?? 0) +
          (int.tryParse(_croissantController.text) ?? 0) +
          (int.tryParse(_supremeController.text) ?? 0) +
          (int.tryParse(_doubleController.text) ?? 0);
    });
  }

  void _loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _classicController.text = (prefs.getInt('classic') ?? 0).toString();
      _croissantController.text = (prefs.getInt('croissant') ?? 0).toString();
      _supremeController.text = (prefs.getInt('supreme') ?? 0).toString();
      _doubleController.text = (prefs.getInt('double') ?? 0).toString();
    });
  }

  void _saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('classic', int.tryParse(_classicController.text) ?? 0);
    await prefs.setInt(
        'croissant', int.tryParse(_croissantController.text) ?? 0);
    await prefs.setInt('supreme', int.tryParse(_supremeController.text) ?? 0);
    await prefs.setInt('double', int.tryParse(_doubleController.text) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const PageAppBar(),

              // بداية اليوم Table
              _buildTableSection(
                'بداية اليوم',
                <TableRow>[
                  _buildTableRowHeader('الاسم', 'الكمية', 'إجمالي القطع'),
                  _buildTableRowData(
                    'كلاسيك',
                    _classicController,
                    30,
                  ),
                  _buildTableRowData(
                    'كرواسون',
                    _croissantController,
                    24,
                  ),
                  _buildTableRowData(
                    'سوبريم',
                    _supremeController,
                    24,
                  ),
                  _buildTableRowData(
                    'دبل',
                    _doubleController,
                    24,
                  ),
                ],
              ),

              const SizedBox(height: 30), // مسافة بين الجدولين
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: _saveDataToSharedPreferences,
                child: const Text(
                  'حفظ',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              // نهاية اليوم Table
              _buildTableSection(
                'نهاية اليوم',
                <TableRow>[
                  _buildTableRowHeader('الاسم', 'المرتجع', 'النسبة المئوية'),
                  _buildTableRowReturnData(
                    'كلاسيك',
                    _classicReturnedController,
                    (int.tryParse(_classicController.text) ?? 0) * 30,
                  ),
                  _buildTableRowReturnData(
                    'كرواسون',
                    _croissantReturnedController,
                    (int.tryParse(_croissantController.text) ?? 0) * 24,
                  ),
                  _buildTableRowReturnData(
                    'سوبريم',
                    _supremeReturnedController,
                    (int.tryParse(_supremeController.text) ?? 0) * 24,
                  ),
                  _buildTableRowReturnData(
                    'دبل',
                    _doubleReturnedController,
                    (int.tryParse(_doubleController.text) ?? 0) * 24,
                  ),
                ],
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: _saveDataToSharedPreferences,
                child: const Text(
                  'حفظ',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),

              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                  ),
                  onPressed: _calculateTotalQuantity,
                  child: const Text(
                    'احسب',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'إجمالي الكمية: $_totalQuantity',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }

  // دالة لبناء قسم الجدول
  Widget _buildTableSection(String title, List<TableRow> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1.5),
            },
            border: TableBorder.symmetric(
              inside: const BorderSide(color: Colors.grey),
            ),
            children: children,
          ),
        ),
      ],
    );
  }

  // دالة لبناء صف رأس الجدول
  TableRow _buildTableRowHeader(String label1, String label2, String label3) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.2),
      ),
      children: [
        _buildTableCell(label1, true),
        _buildTableCell(label2, true),
        _buildTableCell(label3, true),
      ],
    );
  }

  // دالة لبناء صف بيانات بداية اليوم
  TableRow _buildTableRowData(
      String label, TextEditingController controller, int boxQuantity) {
    return TableRow(
      children: [
        _buildTableCell(label, false),
        _buildTableCell(
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (_) {
              setState(() {});
            },
          ),
          false,
        ),
        _buildTableCell(
          '${(int.tryParse(controller.text) ?? 0) * boxQuantity}',
          false,
        ),
      ],
    );
  }

  // دالة لبناء صف بيانات نهاية اليوم
  TableRow _buildTableRowReturnData(
      String label, TextEditingController controller, int totalPieces) {
    return TableRow(
      children: [
        _buildTableCell(label, false),
        _buildTableCell(
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (_) {
              setState(() {});
            },
          ),
          false,
        ),
        _buildTableCell(
          '${_calculatePercentage(totalPieces, controller)}%',
          false,
        ),
      ],
    );
  }

  // دالة لبناء خلايا الجدول
  Widget _buildTableCell(dynamic content, bool isHeader) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: isHeader
              ? Text(
                  content,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              : content is String
                  ? Text(
                      content,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  : content,
        ),
      ),
    );
  }

  String _calculatePercentage(
      int totalPieces, TextEditingController returnedController) {
    int returned = int.tryParse(returnedController.text) ?? 0;

    if (totalPieces == 0) {
      return '0';
    } else {
      double percentage = (returned / totalPieces) * 100;
      return percentage.toStringAsFixed(2);
    }
  }
}

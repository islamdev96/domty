// ignore_for_file: use_build_context_synchronously

import 'package:intl/intl.dart';

import '../all_export.dart';

class StartOfDayPage extends StatefulWidget {
  final Function(Map<String, TextEditingController>) onSubmit;

  const StartOfDayPage({
    super.key,
    required this.onSubmit,
    required Map<String, TextEditingController> startOfDayControllers,
  });

  @override
  State createState() => _StartOfDayPageState();
}

class _StartOfDayPageState extends State<StartOfDayPage>
    with WidgetsBindingObserver {
  // Step 1: Add WidgetsBindingObserver
  final TextEditingController _classicController = TextEditingController();
  final TextEditingController _croissantController = TextEditingController();
  final TextEditingController _supremeController = TextEditingController();
  final TextEditingController _doubleController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPreferences();
    WidgetsBinding.instance.addObserver(this); // Step 1: Add observer
  }

  @override
  void dispose() {
    //  تم إضافة استدعاء دالة `_saveDataToSharedPreferences`
    //  داخل دالة `dispose` لضمان حفظ البيانات عند إغلاق التطبيق.
    _saveDataToSharedPreferences();
    WidgetsBinding.instance.removeObserver(this);
    _classicController.dispose();
    _croissantController.dispose();
    _supremeController.dispose();
    _doubleController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Step 1: Add method
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused) {
      _saveDataToSharedPreferences(); // Step 2: Save data on app closing
    }
  }

  void _saveDataToSharedPreferences() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now();
      final formattedDate = DateFormat('yyyy-MM-dd').format(now);
      final dayName = DateFormat('EEEE', 'ar').format(now);

      await prefs.setString('date', formattedDate);
      await prefs.setString('dayName', dayName);
      await prefs.setInt('classic', int.tryParse(_classicController.text) ?? 0);
      await prefs.setInt(
          'croissant', int.tryParse(_croissantController.text) ?? 0);
      await prefs.setInt('supreme', int.tryParse(_supremeController.text) ?? 0);
      await prefs.setInt('double', int.tryParse(_doubleController.text) ?? 0);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ البيانات بنجاح!')),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);
    final dayName = DateFormat('EEEE', 'ar').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('بداية اليوم'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                'التاريخ: $formattedDate',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                'اليوم: $dayName',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // قسم الجدول
              _buildTableSection(
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

              const SizedBox(height: 800),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: _saveDataToSharedPreferences,
                child: const Text(
                  'حفظ',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableSection(List<TableRow> children) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.5),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
        },
        border: TableBorder.symmetric(
          inside: const BorderSide(color: Colors.grey),
        ),
        children: children,
      ),
    );
  }

  TableRow _buildTableRowHeader(String label1, String label2, String label3) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.2),
      ),
      children: [
        _buildTableCell(label1, true), // الاسم
        _buildTableCell(label2, true), // الكمية
        _buildTableCell(label3, true), // إجمالي القطع
      ],
    );
  }

  TableRow _buildTableRowData(
      String label, TextEditingController controller, int boxQuantity) {
    return TableRow(
      children: [
        _buildTableCell(label, false), // الاسم
        _buildTableCell(
          TextFormField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (_) {
              setState(() {});
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'الرجاء إدخال قيمة';
              }
              return null;
            },
          ),
          false,
        ), // الكمية
        _buildTableCell(
          '${(int.tryParse(controller.text) ?? 0) * boxQuantity}',
          false,
        ), // إجمالي القطع
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
                  content.toString(),
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
}

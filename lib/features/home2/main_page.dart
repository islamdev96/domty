// ignore_for_file: unused_local_variable, library_private_types_in_public_api

import 'package:domty/features/home/screen/summary_page.dart';
import 'package:intl/intl.dart' as intl;

// استيراد ملفات أخرى
import '../../all_export.dart';
import 'data_table.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Map<String, TextEditingController> _boxControllers = {
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

  late double _currentScale; // أضف `late`
  late double _baseScale; // أضف `late`

  final double _minScale = 0.5;
  final double _maxScale = 2.0;

  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPreferences();
    _currentScale = 1.0; // تعيين قيمة افتراضية
    _baseScale = 1.0; // تعيين قيمة افتراضية
  }

  void _loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _boxControllers.forEach((key, controller) {
        controller.text = (prefs.getInt(key) ?? 0) > 0
            ? (prefs.getInt(key) ?? 0).toString()
            : ""; // تعديل هنا
      });
      _returnControllers.forEach((key, controller) {
        controller.text = (prefs.getInt('${key}Return') ?? 0) > 0
            ? (prefs.getInt('${key}Return') ?? 0).toString()
            : ""; // تعديل هنا
      });
      _goodControllers.forEach((key, controller) {
        controller.text = (prefs.getInt('${key}Good') ?? 0) > 0
            ? (prefs.getInt('${key}Good') ?? 0).toString()
            : ""; // تعديل هنا
      });
    });
  }

// ... (باقي الكود في main_page.dart  كما هو)
  void _saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    _boxControllers.forEach((key, controller) {
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
      _boxControllers.forEach((key, controller) {
        controller.text = '';
        prefs.setInt(key, 0);
      });
      _returnControllers.forEach((key, controller) {
        controller.text = '';
        prefs.setInt('${key}Return', 0);
      });
      _goodControllers.forEach((key, controller) {
        controller.text = '';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const SizedBox(height: 30),
          Column(
            children: [
              const PageAppBar(),
              SizedBox(height: 25.h),
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
              // استدعاء DataTabel من ملفه
              DataTableWidget(
                boxControllers: _boxControllers,
                returnControllers: _returnControllers,
                goodControllers: _goodControllers,
                currentScale: _currentScale, // تمرير _currentScale
                baseScale: _baseScale, // تمرير _baseScale
                minScale: _minScale,
                maxScale: _maxScale,
                saveDataToSharedPreferences: _saveDataToSharedPreferences,
              ),

              // Add the Reset Button here
              ElevatedButton(
                onPressed: _resetData,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  backgroundColor: AppColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), // لون الزر
                ),
                child: const Text(
                  "مسح بيانات الجدول",
                  style: TextStyle(
                      fontSize: 18, color: AppColors.white), // حجم ولون النص
                ),
              ),
              const SizedBox(height: 20), // تضاف مسافة بين الأزرار
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SummaryPage(
                        initialSold: _boxControllers.map((key, controller) =>
                            MapEntry(key, int.tryParse(controller.text) ?? 0)),
                        initialReturns: _returnControllers.map((key,
                                controller) =>
                            MapEntry(key, int.tryParse(controller.text) ?? 0)),
                        initialGood: _goodControllers.map((key, controller) =>
                            MapEntry(key, int.tryParse(controller.text) ?? 0)),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  backgroundColor: AppColors.green1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ), // لون الزر
                ),
                child: const Text(
                  'عرض ملخص نهاية اليوم',
                  style: TextStyle(
                      fontSize: 18, color: AppColors.white), // حجم ولون النص
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

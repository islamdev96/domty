import 'package:domty/features/home/end_of_the_day/summary_page.dart';
import 'package:intl/intl.dart' as intl;
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

  late double _currentScale;
  late double _baseScale;
  final double _minScale = 0.5;
  final double _maxScale = 2.0;

  final Map<String, int> _lastDeletedData = {};
  bool _isDataDeleted = false;

  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPreferences();
    _currentScale = 1.0;
    _baseScale = 1.0;
  }

  void _loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _boxControllers.forEach((key, controller) {
        controller.text = (prefs.getInt(key) ?? 0) > 0
            ? (prefs.getInt(key) ?? 0).toString()
            : "";
      });
      _returnControllers.forEach((key, controller) {
        controller.text = (prefs.getInt('${key}Return') ?? 0) > 0
            ? (prefs.getInt('${key}Return') ?? 0).toString()
            : "";
      });
      _goodControllers.forEach((key, controller) {
        controller.text = (prefs.getInt('${key}Good') ?? 0) > 0
            ? (prefs.getInt('${key}Good') ?? 0).toString()
            : "";
      });
      _isDataDeleted = false;
    });
  }

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

  void _resetData() async {
    if (_isDataDeleted) return;

    final prefs = await SharedPreferences.getInstance();
    _lastDeletedData.clear();
    setState(() {
      _boxControllers.forEach((key, controller) {
        _lastDeletedData[key] = int.tryParse(controller.text) ?? 0;
        controller.text = '';
        prefs.setInt(key, 0);
      });
      _returnControllers.forEach((key, controller) {
        _lastDeletedData['${key}Return'] = int.tryParse(controller.text) ?? 0;
        controller.text = '';
        prefs.setInt('${key}Return', 0);
      });
      _goodControllers.forEach((key, controller) {
        _lastDeletedData['${key}Good'] = int.tryParse(controller.text) ?? 0;
        controller.text = '';
        prefs.setInt('${key}Good', 0);
      });
      _isDataDeleted = true;
    });
  }

  void _restoreDeletedData() {
    if (!_isDataDeleted) return;

    setState(() {
      _boxControllers.forEach((key, controller) {
        controller.text = _lastDeletedData[key] == 0
            ? ''
            : _lastDeletedData[key]?.toString() ?? '';
      });
      _returnControllers.forEach((key, controller) {
        controller.text = _lastDeletedData['${key}Return'] == 0
            ? ''
            : _lastDeletedData['${key}Return']?.toString() ?? '';
      });
      _goodControllers.forEach((key, controller) {
        controller.text = _lastDeletedData['${key}Good'] == 0
            ? ''
            : _lastDeletedData['${key}Good']?.toString() ?? '';
      });
      _isDataDeleted = false;
    });
    _saveDataToSharedPreferences();
  }

  String _getFormattedDay() {
    DateTime now = DateTime.now();
    String formattedDay = intl.DateFormat('EEEE', 'ar').format(now);
    return 'اليوم $formattedDay';
  }

  String _getFormattedDate() {
    DateTime now = DateTime.now();
    return intl.DateFormat('d/M/yyyy').format(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            const PageAppBar(),
            SizedBox(height: 25.h),
            _buildDateSection(),
            const SizedBox(height: 20),
            _buildDataTableSection(),
            const SizedBox(height: 20),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            _getFormattedDay(),
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            _getFormattedDate(),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildDataTableSection() {
    return Column(
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
        const SizedBox(height: 10),
        DataTableWidget(
          boxControllers: _boxControllers,
          returnControllers: _returnControllers,
          goodControllers: _goodControllers,
          currentScale: _currentScale,
          baseScale: _baseScale,
          minScale: _minScale,
          maxScale: _maxScale,
          saveDataToSharedPreferences: _saveDataToSharedPreferences,
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _resetData,
                icon: const Icon(Icons.delete, color: Colors.white),
                label: const Text(
                  "مسح بيانات الجدول",
                  style: TextStyle(color: AppColors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: AppColors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _restoreDeletedData,
                icon: const Icon(Icons.restore, color: Colors.white),
                label: const Text(
                  "استرجاع البيانات",
                  style: TextStyle(color: AppColors.white),
                ),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: AppColors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SummaryPage(
                  initialSold: _boxControllers.map((key, controller) =>
                      MapEntry(key, int.tryParse(controller.text) ?? 0)),
                  initialReturns: _returnControllers.map((key, controller) =>
                      MapEntry(key, int.tryParse(controller.text) ?? 0)),
                  initialGood: _goodControllers.map((key, controller) =>
                      MapEntry(key, int.tryParse(controller.text) ?? 0)),
                ),
              ),
            );
          },
          icon: const Icon(Icons.summarize, color: Colors.white),
          label: const Text(
            'عرض ملخص نهاية اليوم',
            style: TextStyle(color: AppColors.white),
          ),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }
}

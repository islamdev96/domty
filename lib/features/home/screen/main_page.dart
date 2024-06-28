// // ignore_for_file: unused_local_variable, library_private_types_in_public_api

// import 'package:domty/features/home/screen/summary_page.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart' as intl;

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   _MainPageState createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   final Map<String, TextEditingController> _boxControllers = {
//     'classic': TextEditingController(),
//     'croissant': TextEditingController(),
//     'supreme': TextEditingController(),
//     'double': TextEditingController(),
//     'fino': TextEditingController(),
//   };

//   final Map<String, TextEditingController> _returnControllers = {
//     'classic': TextEditingController(),
//     'croissant': TextEditingController(),
//     'supreme': TextEditingController(),
//     'double': TextEditingController(),
//     'fino': TextEditingController(),
//   };

//   final Map<String, TextEditingController> _goodControllers = {
//     'classic': TextEditingController(),
//     'croissant': TextEditingController(),
//     'supreme': TextEditingController(),
//     'double': TextEditingController(),
//     'fino': TextEditingController(),
//   };

//   double _currentScale = 1.0;
//   double _baseScale = 1.0;
//   final double _minScale = 0.5;
//   final double _maxScale = 2.0;

//   @override
//   void initState() {
//     super.initState();
//     _loadDataFromSharedPreferences();
//   }

//   void _loadDataFromSharedPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _boxControllers.forEach((key, controller) {
//         controller.text = (prefs.getInt(key) ?? 0).toString();
//       });
//       _returnControllers.forEach((key, controller) {
//         controller.text = (prefs.getInt('${key}Return') ?? 0).toString();
//       });
//       _goodControllers.forEach((key, controller) {
//         controller.text = (prefs.getInt('${key}Good') ?? 0).toString();
//       });
//     });
//   }

//   void _saveDataToSharedPreferences() async {
//     final prefs = await SharedPreferences.getInstance();
//     _boxControllers.forEach((key, controller) {
//       prefs.setInt(key, int.tryParse(controller.text) ?? 0);
//     });
//     _returnControllers.forEach((key, controller) {
//       prefs.setInt('${key}Return', int.tryParse(controller.text) ?? 0);
//     });
//     _goodControllers.forEach((key, controller) {
//       prefs.setInt('${key}Good', int.tryParse(controller.text) ?? 0);
//     });
//   }

//   // Function to reset data
//   void _resetData() async {
//     final prefs = await SharedPreferences.getInstance();
//     setState(() {
//       _boxControllers.forEach((key, controller) {
//         controller.text = '0';
//         prefs.setInt(key, 0);
//       });
//       _returnControllers.forEach((key, controller) {
//         controller.text = '0';
//         prefs.setInt('${key}Return', 0);
//       });
//       _goodControllers.forEach((key, controller) {
//         controller.text = '0';
//         prefs.setInt('${key}Good', 0);
//       });
//     });
//   }

//   String _getFormattedDay() {
//     DateTime now = DateTime.now();
//     String formattedDay = intl.DateFormat('EEEE', 'ar').format(now);
//     return 'اليوم $formattedDay';
//   }

//   String _getFormattedDate() {
//     DateTime now = DateTime.now();
//     String formattedDate = intl.DateFormat('d/M/yyyy').format(now);
//     return formattedDate;
//   }

//   Widget _buildTable() {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return GestureDetector(
//           onScaleStart: (ScaleStartDetails details) {
//             _baseScale = _currentScale;
//           },
//           onScaleUpdate: (ScaleUpdateDetails details) {
//             setState(() {
//               _currentScale =
//                   (_baseScale * details.scale).clamp(_minScale, _maxScale);
//             });
//           },
//           child: SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Transform.scale(
//               scale: _currentScale,
//               child: Card(
//                 elevation: 1,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12.0),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Table(
//                     defaultColumnWidth: const IntrinsicColumnWidth(),
//                     border: TableBorder.all(color: Colors.grey[300]!),
//                     children: [
//                       _buildTableRowHeader(),
//                       ..._boxControllers.keys
//                           .map((key) => _buildTableRowData(key)),
//                       _buildTotalRow(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   TableRow _buildTableRowHeader() {
//     return TableRow(
//       decoration: BoxDecoration(
//         color: Colors.teal.withOpacity(0.2),
//       ),
//       children: [
//         'الاسم',
//         "الكميه",
//         'إجمالي الصناديق', // تم تغيير مكان هذا العمود
//         'إجمالي القطع',
//         'المرتجع',
//         'الصالح'
//       ].map((label) => _buildTableCell(label, true)).toList(),
//     );
//   }

//   // Function to calculate total pieces based on box count
//   int _calculateTotalPieces(String key, int boxCount) {
//     switch (key) {
//       case 'classic':
//         return boxCount * 30;
//       case 'croissant':
//       case 'supreme':
//       case 'double':
//         return boxCount * 24;
//       case 'fino':
//         return boxCount * 8;
//       default:
//         return boxCount;
//     }
//   }

//   // Function to calculate box equivalent
//   List<String> _calculateBoxEquivalent(String key, int boxCount) {
//     switch (key) {
//       case 'classic':
//         return ['${boxCount * 30} قطعة', '$boxCount صندوق'];
//       case 'croissant':
//       case 'supreme':
//       case 'double':
//         int boxEquivalent = (boxCount * 24 / 30).floor();
//         int remainingPieces = (boxCount * 24) % 30;
//         return [
//           '${boxCount * 24} قطعة',
//           '$boxEquivalent صندوق \n$remainingPieces قطعة'
//         ];
//       case 'fino':
//         return ['${boxCount * 8} قطعة', '$boxCount صندوق'];
//       default:
//         return ['$boxCount قطعة', '$boxCount صندوق'];
//     }
//   }

//   TableRow _buildTableRowData(String key) {
//     int boxCount = int.tryParse(_boxControllers[key]!.text) ?? 0;
//     List<String> boxEquivalent = _calculateBoxEquivalent(key, boxCount);
//     int totalPieces = _calculateTotalPieces(key, boxCount);

//     return TableRow(
//       children: [
//         _buildTableCell(key, false),
//         _buildTableCell(_buildTextField(_boxControllers[key]!), false),
//         _buildTableCell(
//             boxEquivalent[1], false), // تم تغيير مكان هذا العمود أيضًا
//         _buildTableCell('$totalPieces قطعة', false), //
//         _buildTableCell(_buildTextField(_returnControllers[key]!), false),
//         _buildTableCell(_buildTextField(_goodControllers[key]!), false),
//       ],
//     );
//   }

//   //  _buildTextField
//   Widget _buildTextField(TextEditingController controller) {
//     return SizedBox(
//       width: 60,
//       child: TextField(
//         controller: controller,
//         keyboardType: TextInputType.number,
//         textAlign: TextAlign.center,
//         decoration: const InputDecoration(
//           hintText: ' ', //  استخدام مسافة كـ hint لإخفاء الصفر
//         ),
//         onChanged: (_) {
//           _saveDataToSharedPreferences();
//           setState(() {});
//         },
//       ),
//     );
//   }

//   // Function to calculate the total box equivalent for all types
//   List<String> _calculateTotalBoxEquivalentForAll() {
//     int totalPieces = 0;
//     _boxControllers.forEach((key, controller) {
//       totalPieces +=
//           _calculateTotalPieces(key, int.tryParse(controller.text) ?? 0);
//     });

//     int totalBoxEquivalent = (totalPieces / 30).floor();
//     int remainingPieces = totalPieces % 30;
//     return [
//       '$totalPieces قطعة',
//       '$totalBoxEquivalent صندوق \n $remainingPieces قطعة'
//     ];
//   }

//   TableRow _buildTotalRow() {
//     int totalBoxes = _boxControllers.values
//         .map((controller) => int.tryParse(controller.text) ?? 0)
//         .reduce((a, b) => a + b);

//     List<String> totalBoxEquivalent =
//         _calculateTotalBoxEquivalentForAll(); // Calculate total equivalent

//     int totalReturns = _returnControllers.values
//         .map((controller) => int.tryParse(controller.text) ?? 0)
//         .reduce((a, b) => a + b);

//     return TableRow(
//       children: [
//         _buildTableCell('الإجمالي', true),
//         _buildTableCell('$totalBoxes', false), // Display total boxes
//         _buildTableCell(
//             totalBoxEquivalent[1], // تم تغيير مكان هذا العمود أيضًا
//             false),
//         _buildTableCell(totalBoxEquivalent[0], false),
//         _buildTableCell('$totalReturns', false),
//         _buildTableCell('', false),
//       ],
//     );
//   }

//   Widget _buildTableCell(dynamic content, bool isHeader) {
//     return TableCell(
//       child: Container(
//         padding: const EdgeInsets.all(8.0),
//         width: isHeader ? null : 80,
//         child: Center(
//           child: isHeader
//               ? Text(
//                   content,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Cairo',
//                   ),
//                 )
//               : content is String
//                   ? Text(
//                       content,
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Cairo',
//                       ),
//                     )
//                   : content,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('الصفحة الرئيسية'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.summarize),
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => SummaryPage(
//                       initialSold: _boxControllers.map((key, controller) =>
//                           MapEntry(key, int.tryParse(controller.text) ?? 0)),
//                       initialReturns: _returnControllers.map((key,
//                               controller) =>
//                           MapEntry(key, int.tryParse(controller.text) ?? 0)),
//                       initialGood: _goodControllers.map((key, controller) =>
//                           MapEntry(key, int.tryParse(controller.text) ?? 0))),
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16.0),
//         children: [
//           const SizedBox(height: 30),
//           Column(
//             children: [
//               Text(
//                 _getFormattedDay(),
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 10),
//               Text(
//                 _getFormattedDate(),
//                 style:
//                     const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 'بداية اليوم',
//                 style: TextStyle(
//                   fontFamily: 'Cairo',
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               _buildTable(),
//               // Add the Reset Button here
//               Center(
//                 // Center the button horizontally
//                 child: ElevatedButton(
//                   onPressed: _resetData,
//                   child: const Text('مسح كل البيانات الموجوده في الجدول'),
//                 ),
//               ),
//               const SizedBox(height: 20), // Add spacing
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

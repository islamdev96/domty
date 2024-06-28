// import 'package:domty/features/home/screen/summary_page.dart';

// import '../../../all_export.dart';
// import 'package:intl/intl.dart' as intl;

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
//               const Center(
//                 // Center the button horizontally
//                 child: ElevatedButton(
//                   onPressed: _resetData,
//                   child: Text('مسح كل البيانات الموجوده في الجدول'),
//                 ),
//               ),
//               const SizedBox(height: 20), // Add spacing
//             ],
//           ),
//         ],
//       ),
//     );
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


// double _currentScale = 1.0;
// double _baseScale = 1.0;
// const double _minScale = 0.5;
// const double _maxScale = 2.0;

// Widget _buildTable() {
//   return LayoutBuilder(
//     builder: (context, constraints) {
//       return GestureDetector(
//         onScaleStart: (ScaleStartDetails details) {
//           _baseScale = _currentScale;
//         },
//         onScaleUpdate: (ScaleUpdateDetails details) {
//           setState(() {
//             _currentScale =
//                 (_baseScale * details.scale).clamp(_minScale, _maxScale);
//           });
//         },
//         child: SingleChildScrollView(
//           scrollDirection: Axis.horizontal,
//           child: Transform.scale(
//             scale: _currentScale,
//             child: Card(
//               elevation: 1,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Table(
//                   defaultColumnWidth: const IntrinsicColumnWidth(),
//                   border: TableBorder.all(color: Colors.grey[300]!),
//                   children: [
//                     _buildTableRowHeader(),
//                     ..._boxControllers.keys
//                         .map((key) => _buildTableRowData(key)),
//                     _buildTotalRow(),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

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


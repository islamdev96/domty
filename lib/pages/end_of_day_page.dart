// import '../all_export.dart';

// class EndOfDayPage extends StatefulWidget {
//   final Map<String, TextEditingController> startOfDayControllers;

//   const EndOfDayPage({super.key, required this.startOfDayControllers});

//   @override
//   State<EndOfDayPage> createState() => _EndOfDayPageState();
// }

// class _EndOfDayPageState extends State<EndOfDayPage> {
//   final TextEditingController _classicReturnedController =
//       TextEditingController();
//   final TextEditingController _croissantReturnedController =
//       TextEditingController();
//   final TextEditingController _supremeReturnedController =
//       TextEditingController();
//   final TextEditingController _doubleReturnedController =
//       TextEditingController();

//   @override
//   void dispose() {
//     _classicReturnedController.dispose();
//     _croissantReturnedController.dispose();
//     _supremeReturnedController.dispose();
//     _doubleReturnedController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('نهاية اليوم'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: _buildTableSection(
//           <TableRow>[
//             _buildTableRowHeader('الاسم', 'المرتجع', 'النسبة المئوية'),
//             _buildTableRowReturnData(
//               'كلاسيك',
//               _classicReturnedController,
//               (int.tryParse(widget.startOfDayControllers['classic']!.text) ??
//                       0) *
//                   30,
//             ),
//             _buildTableRowReturnData(
//               'كرواسون',
//               _croissantReturnedController,
//               (int.tryParse(widget.startOfDayControllers['croissant']!.text) ??
//                       0) *
//                   24,
//             ),
//             _buildTableRowReturnData(
//               'سوبريم',
//               _supremeReturnedController,
//               (int.tryParse(widget.startOfDayControllers['supreme']!.text) ??
//                       0) *
//                   24,
//             ),
//             _buildTableRowReturnData(
//               'دبل',
//               _doubleReturnedController,
//               (int.tryParse(widget.startOfDayControllers['double']!.text) ??
//                       0) *
//                   24,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // دالة لبناء قسم الجدول (بدون العنوان)
//   Widget _buildTableSection(List<TableRow> children) {
//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Table(
//         columnWidths: const {
//           0: FlexColumnWidth(1),
//           1: FlexColumnWidth(1),
//           2: FlexColumnWidth(1.5),
//         },
//         border: TableBorder.symmetric(
//           inside: const BorderSide(color: Colors.grey),
//         ),
//         children: children,
//       ),
//     );
//   }

//   // دالة لبناء صف رأس الجدول (مع ترتيب الأعمدة المعدل)
//   TableRow _buildTableRowHeader(String label1, String label2, String label3) {
//     return TableRow(
//       decoration: BoxDecoration(
//         color: Colors.teal.withOpacity(0.2),
//       ),
//       children: [
//         _buildTableCell(label3, true), // النسبة المئوية
//         _buildTableCell(label2, true), // المرتجع
//         _buildTableCell(label1, true), // الاسم
//       ],
//     );
//   }

//   // دالة لبناء صف بيانات نهاية اليوم (مع ترتيب الأعمدة المعدل)
//   TableRow _buildTableRowReturnData(
//       String label, TextEditingController controller, int totalPieces) {
//     return TableRow(
//       children: [
//         _buildTableCell(
//           '${_calculatePercentage(totalPieces, controller)}%',
//           false,
//         ), // النسبة المئوية
//         _buildTableCell(
//           TextFormField(
//             controller: controller,
//             keyboardType: TextInputType.number,
//             textAlign: TextAlign.center,
//             onChanged: (_) {
//               setState(() {});
//             },
//             validator: (value) {
//               if (value == null || value.isEmpty) {
//                 return 'الرجاء إدخال قيمة';
//               }
//               return null;
//             },
//           ),
//           false,
//         ), // المرتجع
//         _buildTableCell(label, false), // الاسم
//       ],
//     );
//   }

//   // دالة لبناء خلايا الجدول
//   Widget _buildTableCell(dynamic content, bool isHeader) {
//     return TableCell(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Center(
//           child: isHeader
//               ? Text(
//                   content.toString(),
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 )
//               : content is String
//                   ? Text(
//                       content,
//                       style: const TextStyle(fontWeight: FontWeight.bold),
//                     )
//                   : content,
//         ),
//       ),
//     );
//   }

//   String _calculatePercentage(
//       int totalPieces, TextEditingController returnedController) {
//     int returned = int.tryParse(returnedController.text) ?? 0;

//     if (totalPieces == 0) {
//       return '0';
//     } else {
//       double percentage = (returned / totalPieces) * 100;
//       return percentage.toStringAsFixed(2);
//     }
//   }
// }

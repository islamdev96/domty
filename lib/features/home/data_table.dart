// ignore_for_file: must_be_immutable

import '../../all_export.dart';

class DataTableWidget extends StatefulWidget {
  final Map<String, TextEditingController> boxControllers;
  final Map<String, TextEditingController> returnControllers;
  final Map<String, TextEditingController> goodControllers;
  double currentScale; // إزالة  `final`
  double baseScale; //  إزالة  `final`
  final double minScale;
  final double maxScale;
  final Function saveDataToSharedPreferences;

  DataTableWidget({
    // إزالة  `const`
    //  إزالة `const` من هنا
    super.key,
    required this.boxControllers,
    required this.returnControllers,
    required this.goodControllers,
    required this.currentScale,
    required this.baseScale,
    required this.minScale,
    required this.maxScale,
    required this.saveDataToSharedPreferences,
  });
  @override
  State<DataTableWidget> createState() => _DataTableWidgetState();
}

class _DataTableWidgetState extends State<DataTableWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onScaleStart: (ScaleStartDetails details) {
            widget.baseScale = widget.currentScale;
          },
          onScaleUpdate: (ScaleUpdateDetails details) {
            setState(() {
              widget.currentScale = (widget.baseScale * details.scale)
                  .clamp(widget.minScale, widget.maxScale);
            });
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Transform.scale(
              scale: widget.currentScale,
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
                      ...widget.boxControllers.keys
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
      children: [
        'الاسم',
        "الكميه",
        'إجمالي البساكيت',
        'إجمالي القطع',
        'المرتجع',
        'الصالح'
      ].map((label) => _buildTableCell(label, true)).toList(),
    );
  }

  TableRow _buildTableRowData(String key) {
    int boxCount = int.tryParse(widget.boxControllers[key]!.text) ?? 0;
    List<String> boxEquivalent = calculateBoxEquivalent(key, boxCount);
    int totalPieces = calculateTotalPieces(key, boxCount);

    return TableRow(
      children: [
        _buildTableCell(key, false),
        _buildTableCell(
            CustomTextField(
              controller: widget.boxControllers[key]!,
              onChanged: (_) {
                widget.saveDataToSharedPreferences();
                setState(() {});
              },
            ),
            false),
        _buildTableCell(boxEquivalent[1], false),
        _buildTableCell('$totalPieces قطعة', false),
        _buildTableCell(
            CustomTextField(
              controller: widget.returnControllers[key]!,
              onChanged: (_) {
                widget.saveDataToSharedPreferences();
                setState(() {});
              },
            ),
            false),
        _buildTableCell(
            CustomTextField(
              controller: widget.goodControllers[key]!,
              onChanged: (_) {
                widget.saveDataToSharedPreferences();
                setState(() {});
              },
            ),
            false),
      ],
    );
  }

  TableRow _buildTotalRow() {
    int totalBoxes = widget.boxControllers.values
        .map((controller) => int.tryParse(controller.text) ?? 0)
        .reduce((a, b) => a + b);

    List<String> totalBoxEquivalent =
        calculateTotalBoxEquivalentForAll(widget.boxControllers);

    int totalReturns = widget.returnControllers.values
        .map((controller) => int.tryParse(controller.text) ?? 0)
        .reduce((a, b) => a + b);

    return TableRow(
      children: [
        _buildTableCell('الإجمالي', true),
        _buildTableCell('$totalBoxes', false),
        _buildTableCell(totalBoxEquivalent[1], false), // Box equivalents
        _buildTableCell(totalBoxEquivalent[0], false), // Total pieces
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
}

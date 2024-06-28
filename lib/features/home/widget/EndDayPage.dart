import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EndDayPage extends StatefulWidget {
  final Map<String, TextEditingController> controllers;
  final Map<String, String> initialQuantities;

  const EndDayPage({
    super.key,
    required this.controllers,
    required this.initialQuantities,
  });

  @override
  _EndDayPageState createState() => _EndDayPageState();
}

class _EndDayPageState extends State<EndDayPage> {
  @override
  void initState() {
    super.initState();
    _loadDataFromSharedPreferences();
  }

  void _loadDataFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      widget.controllers.forEach((key, controller) {
        controller.text = (prefs.getInt('${key}_returned') ?? 0).toString();
      });
    });
  }

  void _saveDataToSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    widget.controllers.forEach((key, controller) async {
      await prefs.setInt('${key}_returned', int.tryParse(controller.text) ?? 0);
    });
  }

  String _calculatePercentage(
      String initialQuantityString, TextEditingController controller) {
    int initialQuantity = int.tryParse(initialQuantityString) ?? 0;
    int returned = int.tryParse(controller.text) ?? 0;

    if (initialQuantity == 0) {
      return '0%';
    } else {
      double percentage = (returned / initialQuantity) * 100;
      return '${percentage.toStringAsFixed(2)}%';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTableSection(
          'نهاية اليوم',
          <TableRow>[
            _buildTableRowHeader(
                'الاسم', 'المرتجع', 'النسبة المئوية', 'القطع المتبقية'),
            ...widget.controllers.entries.map((entry) {
              final String label = entry.key;
              final TextEditingController controller = entry.value;
              final String initialQuantity =
                  widget.initialQuantities[label] ?? '0';

              return _buildTableRowReturnData(
                  label, controller, initialQuantity);
            }),
          ],
        ),
      ],
    );
  }

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
              3: FlexColumnWidth(1),
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

  TableRow _buildTableRowHeader(
      String label1, String label2, String label3, String label4) {
    return TableRow(
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.2),
      ),
      children: [
        _buildTableCell(label1, true),
        _buildTableCell(label2, true),
        _buildTableCell(label3, true),
        _buildTableCell(label4, true),
      ],
    );
  }

  TableRow _buildTableRowReturnData(
      String label, TextEditingController controller, String initialQuantity) {
    TextEditingController quantityController = TextEditingController();

    return TableRow(
      children: [
        _buildTableCell(label, false),
        _buildTableCell(
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            onChanged: (text) {
              _saveDataToSharedPreferences();
              // Update the quantityController based on the entered returned value.
              int returned = int.tryParse(text) ?? 0;
              int initial = int.tryParse(initialQuantity) ?? 0;
              int quantity = initial - returned;
              quantityController.text = quantity.toString();
              setState(() {}); // Rebuild the widget to reflect the change
            },
          ),
          false,
        ),
        _buildTableCell(
          _calculatePercentage(initialQuantity, controller),
          false,
        ),
        _buildTableCell(
          TextField(
            controller: quantityController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            readOnly: true, // Make the quantity field read-only
          ),
          false,
        ),
      ],
    );
  }

  Widget _buildTableCell(dynamic content, bool isHeader) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: content is Widget
            ? content
            : Text(
                content.toString(), // Ensure content is a String
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                ),
              ),
      ),
    );
  }
}

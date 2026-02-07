import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterDateButtonWidget extends StatelessWidget {
  final String label;
  final DateTime? date;
  final Function(DateTime?) onDateSelected;

  const FilterDateButtonWidget({super.key, required this.label, required this.onDateSelected, this.date});

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: date ?? DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date != null ? DateFormat('MMM dd, yyyy').format(date!) : label,
              style: TextStyle(
                color: date != null ? Colors.grey.shade900 : Colors.grey.shade500,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Icon(Icons.calendar_today, size: 16, color: date != null ? Colors.blue : Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

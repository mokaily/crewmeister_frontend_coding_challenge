import 'package:flutter/material.dart';

class FilterSelectButtonWidget extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const FilterSelectButtonWidget({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? Colors.blue.shade50 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? Colors.blue : Colors.grey.shade300),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) const Icon(Icons.check, size: 16, color: Colors.blue),
            if (selected) const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: selected ? Colors.blue : Colors.black87, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}

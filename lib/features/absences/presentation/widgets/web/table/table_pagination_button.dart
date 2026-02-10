import 'package:flutter/material.dart';

class TablePaginationButton extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final bool isActive;
  final VoidCallback? onPressed;

  const TablePaginationButton({super.key, this.label, this.icon, this.isActive = false, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: isActive ? Colors.blue.shade900 : Colors.white,
          side: BorderSide(color: isActive ? Colors.blue.shade900 : const Color(0xFFE2E8F0)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        child: label != null
            ? Text(
          label!,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF64748B),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        )
            : Icon(icon, size: 20, color: onPressed == null ? Colors.grey[300] : const Color(0xFF64748B)),
      ),
    );
  }
}

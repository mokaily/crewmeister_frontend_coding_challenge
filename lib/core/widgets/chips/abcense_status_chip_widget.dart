import 'package:flutter/material.dart';

class AbsenceStatusChipWidget extends StatelessWidget {
  final String type;

  const AbsenceStatusChipWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    bool isRequested = type.toLowerCase() == "requested";
    bool isConfirmed = type.toLowerCase() == "confirmed";

    MaterialColor mainColor = isRequested ? Colors.orange : isConfirmed ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: mainColor[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: mainColor[100]!),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 4, backgroundColor: mainColor),
          SizedBox(width: 4),
          Text(
            type.toUpperCase(),
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: mainColor),
          ),
        ],
      ),
    );
  }
}
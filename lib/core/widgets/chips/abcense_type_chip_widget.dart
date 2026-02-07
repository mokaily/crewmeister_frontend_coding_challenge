import 'package:flutter/material.dart';

class AbsenceTypeChipWidget extends StatelessWidget {
  final String type;

  const AbsenceTypeChipWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context) {
    bool isVacation = type.toLowerCase() == "vacation";
    MaterialColor mainColor = isVacation ? Colors.blue : Colors.purple;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: mainColor[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: mainColor[100]!),
      ),
      child: Row(
        children: [
          Icon(isVacation ? Icons.beach_access : Icons.healing_sharp, size: 16, color: mainColor),
          const SizedBox(width: 4),
          Text(type.toUpperCase(), style: TextStyle(fontSize: 12, color: mainColor)),
        ],
      ),
    );
  }
}

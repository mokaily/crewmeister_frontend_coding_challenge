import 'package:flutter/material.dart';

class NotesWidget extends StatelessWidget {
  final bool isMemberNote;
  final bool isRejected;
  final String note;
  const NotesWidget({super.key, required this.isMemberNote, this.isRejected = false, required this.note});

  @override
  Widget build(BuildContext context) {
    String title = isMemberNote ? "Member Note" : "Admitter Note";
    MaterialColor mainColor = isRejected ? Colors.red : Colors.grey;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: mainColor[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: mainColor[200]!),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          children: [
            TextSpan(
              text: "$title\n",
              style: TextStyle(fontWeight: FontWeight.bold, color: mainColor[700], fontSize: 14),
            ),
            TextSpan(
              text: isMemberNote ? '"$note"' : note,
              style: TextStyle(
                fontStyle: isMemberNote ? FontStyle.italic : null,
                color: mainColor[600],
                height: 2.0,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

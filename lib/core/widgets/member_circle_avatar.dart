import 'package:flutter/material.dart';

class MemberCircleAvatar extends StatelessWidget {
  final String link;
  final int index;
  const MemberCircleAvatar({super.key, required this.index, required this.link});

  @override
  Widget build(BuildContext context) {
    String linkAddress = '$link?lock=$index';

    return CircleAvatar(backgroundImage: NetworkImage(linkAddress), radius: 24);
  }
}

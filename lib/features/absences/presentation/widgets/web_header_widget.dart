import 'package:flutter/material.dart';

class WebHeaderWidget extends StatelessWidget {
  const WebHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/banner.jpg"),
          fit: BoxFit.cover,
          alignment: Alignment.center,
          colorFilter: ColorFilter.mode(Colors.blue.shade800.withValues(alpha: 0.45), BlendMode.hue),
        ),
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 1920),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Absence Tracker",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 35),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

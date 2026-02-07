import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  final String imageAsset;
  final String title;
  final String message;

  const ErrorStateWidget({
    super.key,
    required this.imageAsset,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.grey.shade100),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(imageAsset, width: 300, fit: BoxFit.cover),
            ),

            const SizedBox(height: 24),

            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 22),
            ),

            const SizedBox(height: 12),

            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600, fontSize: 16, height: 1.4),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

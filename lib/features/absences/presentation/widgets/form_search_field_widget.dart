import 'package:flutter/material.dart';

class FormSearchFieldWidget extends StatelessWidget {
  final TextEditingController searchController;
  final ValueChanged<String>? onAction;
  const FormSearchFieldWidget({super.key, required this.searchController, this.onAction});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      onChanged: onAction,
      decoration: InputDecoration(
        hintText: 'Names',
        prefixIcon: const Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 0,
        ),
      ),
    );
  }
}

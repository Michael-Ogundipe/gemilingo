import 'package:flutter/material.dart';

class TranslationField extends StatelessWidget {
  const TranslationField({
    super.key,
    required this.label,
     this.hintText,
  });

  final String label;
  final String? hintText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label),
          const SizedBox(height: 20),
          TextFormField(
            autofocus: false,
            decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(fontSize: 20),
                border: InputBorder.none),
          )
        ],
      ),
    );
  }
}

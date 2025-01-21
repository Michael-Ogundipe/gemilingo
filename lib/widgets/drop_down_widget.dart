import 'package:flutter/material.dart';

class DropDownWidget extends StatelessWidget {
  const DropDownWidget({
    super.key,
    required this.value,
    this.items,
    this.onChanged,
  });

  final String value;
  final List<DropdownMenuItem<String>>? items;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width *0.36,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white), // Match your other borders
        borderRadius:
            BorderRadius.circular(10), // Match your other border radius
      ),
      child: DropdownButton<String>(
        value: value,

        isExpanded: true,
        underline: Container(),
        // Remove the default underline
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

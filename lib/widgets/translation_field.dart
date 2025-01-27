import 'package:flutter/material.dart';

class TranslationField extends StatefulWidget {
  const TranslationField({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.onChanged,
    this.readOnly = false,
  });

  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  @override
  State<TranslationField> createState() => _TranslationFieldState();
}

class _TranslationFieldState extends State<TranslationField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.only(left: 16, top: 16),
      height: MediaQuery.of(context).size.height * 0.25,
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(
          color: _isFocused ? Colors.blue : Colors.white,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.label),
          const SizedBox(height: 20),
          TextFormField(
            focusNode: _focusNode,
            controller: widget.controller,
            maxLines: 4,
            autofocus: false,
            onChanged: widget.onChanged,
            style: const TextStyle(fontSize: 20),
            readOnly: widget.readOnly,
            decoration: InputDecoration(
              hintText: widget.hintText,
              hintStyle: const TextStyle(fontSize: 20),
              border: InputBorder.none,
            ),
          )
        ],
      ),
    );
  }
}

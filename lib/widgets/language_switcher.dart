import 'package:flutter/material.dart';

import 'drop_down_widget.dart';

class LanguageSwitcher extends StatelessWidget {
   LanguageSwitcher({
    super.key,
    required this.inputController,
    required this.translateText,
    required this.selectedLanguage,
    required this.translatedLanguage,
    required this.onSelectedLanguageChanged,
    required this.onTranslatedLanguageChanged,
  });

  final TextEditingController inputController;
  final void Function(String) translateText;
  final String selectedLanguage;
  final String translatedLanguage;
  final void Function(String) onSelectedLanguageChanged;
  final void Function(String) onTranslatedLanguageChanged;

  final List<String> _languages = [
    'English',
    'French',
    'Spanish',
    'Italian',
    'Portuguese',
    'Chinese',
  ];
  final List<String> _translatedLanguages = [
    'English',
    'French',
    'Spanish',
    'Italian',
    'Portuguese',
    'Chinese',
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DropDownWidget(
          value: selectedLanguage,
          items: _languages.map((String language) {
            return DropdownMenuItem(
              value: language,
              child: Text(language),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onSelectedLanguageChanged(newValue);
            }
          },
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(8)),
          ),
          child: const Icon(Icons.swap_horiz_outlined),
        ),
        const SizedBox(width: 16),
        DropDownWidget(
          value: translatedLanguage!,
          items: _translatedLanguages.map((String language) {
            return DropdownMenuItem(
              value: language,
              child: Text(language),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onTranslatedLanguageChanged(newValue);
            }
          },
        ),
      ],
    );
  }
}

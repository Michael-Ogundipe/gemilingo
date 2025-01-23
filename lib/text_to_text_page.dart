import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'widgets/drop_down_widget.dart';
import 'widgets/translation_field.dart';

class TextToTextPage extends StatefulWidget {
  const TextToTextPage({super.key});

  @override
  State<TextToTextPage> createState() => _TextToTextPageState();
}

class _TextToTextPageState extends State<TextToTextPage> {
  final TextEditingController _translatedController = TextEditingController();
  final TextEditingController _inputController = TextEditingController();
  Timer? _debounce;
  late final GenerativeModel _model;
  bool _isTranslating = false;

  String _selectedLanguage = 'English';
  String _translatedLanguage = 'French';

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
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: dotenv.env['API_KEY']!, // Replace with your API key
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _translatedController.dispose();
    super.dispose();
  }

  void _onTextChanged(String text) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _translateText(text);
    });
  }

  Future<void> _translateText(String text) async {
    if (text.isEmpty) {
      _translatedController.clear();
      return;
    }

    setState(() => _isTranslating = true);

    try {
      final prompt = 'Translate this text to $_translatedLanguage: "$text".  '
          'Respond with only the translation, no quotes or additional text.';
      final content = [Content.text(prompt)];
      final response = await _model.generateContent(content);

      if (response.text != null) {
        _translatedController.text = response.text!;
      }
    } catch (e) {
      print('Translation error: $e');
    } finally {
      setState(() => _isTranslating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Translate'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropDownWidget(
                  value: _selectedLanguage,
                  items: _languages.map((String language) {
                    return DropdownMenuItem(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedLanguage = newValue;
                        if (_inputController.text.isNotEmpty) {
                          _translateText(_inputController.text);
                        }
                      });
                    }
                  },
                ),
                const SizedBox(width: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Icon(Icons.swap_horiz_outlined),
                ),
                const SizedBox(width: 16),
                DropDownWidget(
                  value: _translatedLanguage,
                  items: _translatedLanguages.map((String language) {
                    return DropdownMenuItem(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _translatedLanguage = newValue;
                        if (_inputController.text.isNotEmpty) {
                          _translateText(_inputController.text);
                        }
                      });
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            TranslationField(
              label: _selectedLanguage,
              hintText: 'Enter your text...',
              onChanged: _onTextChanged,
            ),
            TranslationField(
              label: _translatedLanguage,
              controller: _translatedController,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}

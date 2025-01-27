import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'widgets/language_switcher.dart';
import 'widgets/translation_field.dart';

class TextToTextPage extends StatefulWidget {
  const TextToTextPage({super.key});

  @override
  State<TextToTextPage> createState() => _TextToTextPageState();
}

class _TextToTextPageState extends State<TextToTextPage> {
  final  _translatedController = TextEditingController();
  final  _inputController = TextEditingController();
  late final GenerativeModel _model;

  Timer? _debounce;
  String _selectedLanguage = 'English';
  String _translatedLanguage = 'French';



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
      translateText(text);
    });
  }

  void _handleSelectedLanguageChange(String newLanguage) {
    setState(() {
      _selectedLanguage = newLanguage;
    });
  }

  void _handleTranslatedLanguageChange(String newLanguage) {
    setState(() {
      _translatedLanguage = newLanguage;
    });
  }

  Future<void> translateText(String text) async {
    if (text.isEmpty) {
      _translatedController.clear();
      return;
    }

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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              LanguageSwitcher(
                inputController: _inputController,
                translateText: (string) {},
                selectedLanguage: _selectedLanguage,
                translatedLanguage: _translatedLanguage,
                onSelectedLanguageChanged: _handleSelectedLanguageChange,
                onTranslatedLanguageChanged: _handleTranslatedLanguageChange,
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
      ),
    );
  }
}

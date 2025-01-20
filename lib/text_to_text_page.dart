import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'widgets/translation_field.dart';

class TextToTextPage extends StatefulWidget {
  const TextToTextPage({super.key});

  @override
  State<TextToTextPage> createState() => _TextToTextPageState();
}

class _TextToTextPageState extends State<TextToTextPage> {
  final TextEditingController _translatedController = TextEditingController();
  Timer? _debounce;
  late final GenerativeModel _model;
  bool _isTranslating = false;

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
      final prompt = 'Translate this text to French: "$text".  '
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
            TranslationField(
              label: 'English',
              hintText: 'Enter your text...',
              onChanged: _onTextChanged,
            ),
            TranslationField(
              label: 'French',
              controller: _translatedController,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}

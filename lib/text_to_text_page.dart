import 'package:flutter/material.dart';

import 'widgets/translation_field.dart';

class TextToTextPage extends StatelessWidget {
  const TextToTextPage({super.key});

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
            ),
            TranslationField(
              label: 'French',
            ),

          ],
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';

class ConversationTranslationPage extends StatelessWidget {
  const ConversationTranslationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Translator'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: IconButton(
        onPressed: () {},
        icon: Icon(Icons.mic),
      ),
      body: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Development in Progress..',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

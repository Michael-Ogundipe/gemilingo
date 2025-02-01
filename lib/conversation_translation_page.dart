import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import 'widgets/bar_waveform_painter.dart';
import 'widgets/language_switcher.dart';
import 'widgets/microphone.dart';
import 'widgets/translation_field.dart';

class ConversationTranslationPage extends StatefulWidget {
  const ConversationTranslationPage({super.key});

  @override
  State<ConversationTranslationPage> createState() =>
      _ConversationTranslationPageState();
}

class _ConversationTranslationPageState
    extends State<ConversationTranslationPage> with SingleTickerProviderStateMixin {
  late FlutterTts flutterTts;
  late AnimationController _controller;
  final _inputController = TextEditingController();
  final _translatedController = TextEditingController();
  final textToSpeech = FlutterTts();

  String _selectedLanguage = 'English';
  String _translatedLanguage = 'French';
  bool isRecording = false;
  bool isPlaying = false;
  bool isTranslating = false;
  double speed = 0.5;


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

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
  }

  Future<void> _initializeTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setLanguage("fr-FR");
    await flutterTts.setSpeechRate(speed);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);

    flutterTts.setCompletionHandler(() {
      setState(() {
        isPlaying = false;
      });
      _controller.stop();
    });
  }

  Future<void> _speak() async {
    if (isPlaying) {
      await flutterTts.stop();
      setState(() {
        isPlaying = false;
      });
      _controller.stop();
    } else {
      setState(() {
        isPlaying = true;
      });
      _controller.repeat();
      final log = "Parfois, je me demande si le destin nous guide vraiment ou si nous ne faisons que suivre un chemin tracé par nos propres choix. Quoi qu'il en soit, je suis prêt à affronter ce qui m'attend.";
      await flutterTts.speak(log);
    }
  }

  @override
  void dispose() {
    flutterTts.stop();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          isRecording ? 'Listening...' : 'Translator',
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 90,
        height: 90,
        child: Microphone(
          icon: isRecording ? Icons.stop : Icons.mic_outlined,
          isRecording: isRecording,
          onPressed: () async {
            setState(() {
              isRecording = !isRecording;
            });

            if (isRecording) {
              // if (_translatedController.text.isNotEmpty) {
              //   _translatedController.clear();
              // }
              //recordAudio();
            } else {
              // stopAndTranslate(_translatedLanguage);
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
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
              label: _translatedLanguage,
              controller: _translatedController,
              readOnly: true,
            ),
            SizedBox(
              height: 100,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return CustomPaint(
                    size: const Size(double.infinity, 100),
                    painter: BarWaveformPainter(
                      animation: _controller.value,
                      isPlaying: isPlaying,
                      waveColor: Colors.red,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(isPlaying ? Icons.stop : Icons.play_arrow),
                  iconSize: 32,
                  onPressed: _speak,
                ),
                const SizedBox(width: 20),
                Slider(
                  value: speed,
                  min: 0.5,
                  max: 2.0,
                  divisions: 3,
                  label: 'Speed: ${speed.toStringAsFixed(1)}x',
                  onChanged: (value) async {
                    setState(() {
                      speed = value;
                    });
                    await flutterTts.setSpeechRate(speed);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

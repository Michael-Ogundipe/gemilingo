import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';

import 'widgets/language_switcher.dart';
import 'widgets/microphone.dart';
import 'widgets/translation_field.dart';

class VoiceToTextPage extends StatefulWidget {
  const VoiceToTextPage({super.key});

  @override
  State<VoiceToTextPage> createState() => _VoiceToTextPageState();
}

class _VoiceToTextPageState extends State<VoiceToTextPage>
    with SingleTickerProviderStateMixin {
  final _translatedController = TextEditingController();
  final recorder = FlutterSoundRecorder();
  final _codec = Codec.aacMP4;
  final _mPath = 'audio_record.mp4';

  final _inputController = TextEditingController();

  String _selectedLanguage = 'English';
  String _translatedLanguage = 'French';

  static const theSource = AudioSource.microphone;

  bool isRecording = false;

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
    openRecorder();
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  Future<void> openRecorder() async {
    await recorder.openRecorder();
    final status = await Permission.microphone.request();

    if (status.isGranted) {
      await recorder.openRecorder();
    } else if (status.isDenied) {
    } else if (status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<void> recordAudio() async {
    await recorder
        .startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    )
        .then((value) {
      setState(() {});
    });
  }

  void stopAndTranslate(String targetLanguage) async {
    final path = await recorder.stopRecorder();
    final audioFile = File(path!);
    final audioBytes = await audioFile.readAsBytes();
    final prompt = 'Translate this audio to $targetLanguage';

    final generativeModel = GenerativeModel(
      model: 'gemini-1.5-flash-001',
      apiKey: dotenv.env['API_KEY']!,
    );

    final content = [
      Content.multi([
        TextPart(prompt),
        DataPart('audio/mp3', audioBytes),
      ]),
    ];

    final response = await generativeModel.generateContent(content);
    _translatedController.text = response.text ?? 'Translation failed';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Translation'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              width: 100,
              height: 100,
              child: Microphone(
                icon: isRecording ? Icons.stop : Icons.mic_outlined,
                isRecording: isRecording,
                onPressed: () async {
                  setState(() {
                    isRecording = !isRecording;
                  });

                  if (isRecording) {
                    if (_translatedController.text.isNotEmpty) {
                      _translatedController.clear();
                    }
                    recordAudio();
                  } else {
                    stopAndTranslate(_translatedLanguage);
                  }
                },
              ),
            ),
            const SizedBox(height: 64),
            TranslationField(
              label: _translatedLanguage,
              controller: _translatedController,
              readOnly: true,
            ),
            const SizedBox(height: 32),
            LanguageSwitcher(
              inputController: _inputController,
              translateText: (string) {},
              selectedLanguage: _selectedLanguage,
              translatedLanguage: _translatedLanguage,
              onSelectedLanguageChanged: _handleSelectedLanguageChange,
              onTranslatedLanguageChanged: _handleTranslatedLanguageChange,
            ),
          ],
        ),
      ),
    );
  }
}

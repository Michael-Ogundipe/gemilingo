import 'package:flutter/material.dart';
import 'service/recording_service.dart';
import 'widgets/language_switcher.dart';
import 'widgets/microphone.dart';
import 'widgets/translation_field.dart';

class VoiceToTextPage extends StatefulWidget {
  const VoiceToTextPage({
    super.key,
    required this.recordingService,
  });

  final RecordingService recordingService;

  @override
  State<VoiceToTextPage> createState() => _VoiceToTextPageState();
}

class _VoiceToTextPageState extends State<VoiceToTextPage>
    with SingleTickerProviderStateMixin {
  final _translatedController = TextEditingController();

  String _selectedLanguage = 'English';
  String _translatedLanguage = 'French';
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
    widget.recordingService.openRecorder();
  }

  @override
  void dispose() {
    _translatedController.dispose();
    widget.recordingService.recorder.closeRecorder();
    super.dispose();
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
                    widget.recordingService.recordAudio();
                  } else {
                    _translatedController.text = await widget.recordingService
                        .stopAndTranslate(_translatedLanguage);
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

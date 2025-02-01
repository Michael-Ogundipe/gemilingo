import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:permission_handler/permission_handler.dart';

class RecordingService {
  final recorder = FlutterSoundRecorder();
  final _codec = Codec.aacMP4;
  final _mPath = 'audio_record.mp4';

  static const theSource = AudioSource.microphone;

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
    await recorder.startRecorder(
      toFile: _mPath,
      codec: _codec,
      audioSource: theSource,
    );
  }

  Future<String> stopAndTranslate(String targetLanguage) async {
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
    return response.text ?? 'Translation failed';
  }
}

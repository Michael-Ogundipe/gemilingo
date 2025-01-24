import 'dart:io';
import 'dart:math' show pi;

import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';

import 'package:flutter/material.dart';
import 'package:gemilingo/widgets/translation_field.dart';
import 'package:path_provider/path_provider.dart';

import 'widgets/blob.dart';

class VoiceToTextPage extends StatefulWidget {
  const VoiceToTextPage({super.key});

  @override
  State<VoiceToTextPage> createState() => _VoiceToTextPageState();
}

class _VoiceToTextPageState extends State<VoiceToTextPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;
  late Animation<double> _animation;
  double _scale = 0.85;

  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  final recorder = FlutterSoundRecorder();
  final  _codec = Codec.aacMP4;
  final  _mPath = 'audio_record.mp4';
  static const theSource = AudioSource.microphone;


  bool isRecording = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation =
        Tween<double>(begin: 0.0, end: 2 * pi).animate(_rotationController);

    _rotationController.repeat();
    openRecorder();
  }

  Future<void> openRecorder()async {
    await recorder.openRecorder();
    await _mPlayer!.openPlayer();
  }


  Future<void> recordAudio() async {

    await recorder.startRecorder(
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

    print('audio mie');
    print(audioFile);

    // Future.delayed(Duration(seconds: 2), (){
    //   _mPlayer!
    //       .startPlayer(
    //       fromURI: _mPath,
    //       //codec: kIsWeb ? Codec.opusWebM : Codec.aacADTS,
    //       whenFinished: () {
    //         setState(() {});
    //       })
    //       .then((value) {
    //     setState(() {});
    //   });
    // });

    // final audioBytes = await audioFile.readAsBytes();
    // final prompt = 'Translate this audio to $targetLanguage';
    // final generativeModel = GenerativeModel(
    //   model: 'gemini-pro-vision',
    //   apiKey: dotenv.env['API_KEY']!,
    // );
    //
    // final content = [
    //   Content.multi([
    //     TextPart(prompt),
    //     DataPart('audio/mp3', audioBytes),
    //   ]),
    // ];
    //
    // final response = await generativeModel.generateContent(content);
    // final translatedText = response.text ?? 'Translation failed';
    //
    // print('Translated text: $translatedText');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              width: 100,
              height: 100,
              child: AnimatedBuilder(
                  animation: _rotationController,
                  builder: (context, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        if (isRecording) ...[
                          Blob(
                              color: Color(0xff0092ff),
                              scale: _scale,
                              rotation: _animation.value),
                          Blob(
                              color: Color(0xff4ac7b7),
                              scale: _scale,
                              rotation: _animation.value * 2 - 30),
                          Blob(
                              color: Color(0xffa4a6f6),
                              scale: _scale,
                              rotation: _animation.value * 3 - 45),
                        ],
                        Container(
                          padding: const EdgeInsets.all(20.0),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Color(0XFF5CABC0)),
                          child: InkWell(
                            onTap: () async {
                            setState(() {
                              isRecording =! isRecording;
                            });

                            if(isRecording){
                              print('will start');
                              recordAudio();
                            } else{
                              print('will stop');
                              stopAndTranslate('English');
                            }

                            },
                            child: const Icon(
                              Icons.mic_outlined,
                              size: 36,
                            ),
                          ),
                        )
                        //   ],
                      ],
                    );
                  }),
            ),
            const SizedBox(height: 64),
            TranslationField(label: 'Language')
          ],
        ),
      ),
    );
  }
}

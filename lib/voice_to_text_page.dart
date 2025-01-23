import 'dart:math' show pi;

import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:gemilingo/widgets/translation_field.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

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

  final audioRecorder = AudioRecorder();
  final audioPlayer = AudioPlayer();

  String? recordingPath;
  bool isRecording = false, isPlaying = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _animation = Tween<double>(begin: 0.0, end: 2 * pi).animate(
      _rotationController,
    );

    _rotationController.repeat();
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
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Color(0XFF5CABC0)),
                          child: InkWell(
                            onTap: () async {
                              if (isRecording) {
                                String? filePath = await audioRecorder.stop();
                                if (filePath != null) {
                                  setState(() {
                                    isRecording = false;
                                    recordingPath = filePath;
                                  });
                                }
                              } else {
                                if (await audioRecorder.hasPermission()) {
                                  final appDocumentDir =
                                      await getApplicationDocumentsDirectory();
                                  final filePath = p.join(
                                      appDocumentDir.path, "recording.wav");
                                  await audioRecorder.start(
                                    const RecordConfig(),
                                    path: filePath,
                                  );
                                  setState(() {
                                    isRecording = true;
                                    recordingPath = null;
                                  });
                                }
                              }
                            },
                            child: Icon(
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
            if (recordingPath != null)
              MaterialButton(
                onPressed: () async {
                  if (audioPlayer.playing) {
                    audioPlayer.stop();
                    setState(() {
                      isPlaying = false;
                    });
                  } else {
                    await audioPlayer.setFilePath(recordingPath!);
                    audioPlayer.play();
                    setState(() {
                      isPlaying = true;
                    });
                  }
                },
                color: Colors.green,
                child: Text(isPlaying ? 'Stop Playing' : 'Start Playing'),
              ),
            const SizedBox(height: 16),
            TranslationField(label: 'Language')
          ],
        ),
      ),
    );
  }
}

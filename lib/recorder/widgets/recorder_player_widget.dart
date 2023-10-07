import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:logger/logger.dart';
import 'package:voice_recorder_app/main.dart';
import 'package:voice_recorder_app/recorder/store/recorder_store.dart';

class RecorderPlayerWidget extends StatefulWidget {
  const RecorderPlayerWidget({Key? key}) : super(key: key);

  @override
  State<RecorderPlayerWidget> createState() => _RecorderPlayerWidgetState();
}

enum RecordingState {
  unSet,
  set,
  recording,
  stopped,
}

class _RecorderPlayerWidgetState extends State<RecorderPlayerWidget> {
  IconData _recordIcon = Icons.mic_none;
  String _recordText = 'Click To Start';
  RecordingState _recordingState = RecordingState.unSet;
  bool _isRecorderReady = false;
  final _recorder = FlutterSoundRecorder(logLevel: Level.nothing);
  final RecorderStore _recorderStore = getIt<RecorderStore>();

  @override
  void initState() {
    super.initState();

    _recordingState = RecordingState.set;
    _recordIcon = Icons.mic;
    _recordText = 'Record';
  }

  @override
  void dispose() {
    _recordingState = RecordingState.unSet;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        MaterialButton(
          onPressed: () async {
            await _onRecordButtonPressed();
            setState(() {});
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: SizedBox(
            width: 150,
            height: 150,
            child: Icon(
              _recordIcon,
              size: 50,
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(_recordText),
          ),
        )
      ],
    );
  }

  Future<void> _onRecordButtonPressed() async {
    switch (_recordingState) {
      case RecordingState.set:
        await _recordVoice();
        break;

      case RecordingState.recording:
        await _stopRecording();
        _recordingState = RecordingState.stopped;
        _recordIcon = Icons.mic;
        _recordText = '';
        break;

      case RecordingState.stopped:
        await _recordVoice();
        break;

      case RecordingState.unSet:
        if (!context.mounted) return;

        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please allow recording from settings.'),
        ));
        break;
    }
  }

  Future _initRecorder() async {
    await _recorder.openRecorder();
    _isRecorderReady = true;
    _recorder.setSubscriptionDuration(const Duration(milliseconds: 500));
  }

  Future _startRecording() async {
    if (!_isRecorderReady) return;
    Directory appDirectory = await getApplicationDocumentsDirectory();
    String filePath =
        '${appDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
    await _recorder.startRecorder(toFile: filePath);
  }

  _stopRecording() async {
    await _recorder.stopRecorder();
    _recorderStore.loadRecordFiles();
  }

  Future<void> _recordVoice() async {
    final status = await Permission.microphone.request();
    if (status == PermissionStatus.granted) {
      await _initRecorder();
      await _startRecording();

      _recordingState = RecordingState.recording;
      _recordIcon = Icons.stop;
      _recordText = 'Recording';
    } else {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please allow recording from settings.'),
      ));
    }
  }
}

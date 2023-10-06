import 'package:flutter/material.dart';
import 'package:voice_recorder_app/main.dart';
import 'package:voice_recorder_app/recorder/recorder_list_view.dart';
import 'package:voice_recorder_app/recorder/store/recorder_store.dart';
import 'package:voice_recorder_app/recorder/widgets/recorder_player_widget.dart';

class RecorderPage extends StatefulWidget {
  const RecorderPage({Key? key}) : super(key: key);

  @override
  State<RecorderPage> createState() => _RecorderPageState();
}

class _RecorderPageState extends State<RecorderPage> {
  final RecorderStore _recorderStore = getIt<RecorderStore>();

  @override
  void initState() {
    _recorderStore.loadRecordFiles();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Voice Recorder'),
      ),
      body: const Column(
        children: [
          Expanded(
            flex: 2,
            child: RecorderListView(),
          ),
          Expanded(
            flex: 1,
            child: RecorderPlayerWidget(),
          ),
        ],
      ),
    );
  }
}

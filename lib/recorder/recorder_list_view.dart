import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:voice_recorder_app/main.dart';
import 'package:voice_recorder_app/models/recorder_file.dart';
import 'package:voice_recorder_app/recorder/modals/recorder_modal.dart';
import 'package:voice_recorder_app/recorder/store/recorder_store.dart';

class RecorderListView extends StatefulWidget {
  const RecorderListView({Key? key}) : super(key: key);

  @override
  State<RecorderListView> createState() => _RecorderListViewState();
}

class _RecorderListViewState extends State<RecorderListView> {
  final RecorderStore _recorderStore = getIt<RecorderStore>();

  late int _totalDuration;
  late int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return ListView.builder(
        itemCount: _recorderStore.records.length,
        shrinkWrap: true,
        reverse: true,
        itemBuilder: (BuildContext context, int i) {
          final RecorderFile item = _recorderStore.records[i];
          return ExpansionTile(
            title: Text('New recoding ${_recorderStore.records.length - i}'),
            subtitle: Text(_formatDate(recordedDate: item.dtCreate)),
            trailing: IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                showModalBottomSheet<void>(
                  context: context,
                  builder: (context) => RecorderModal(recorderFile: item),
                );
              },
            ),
            onExpansionChanged: ((newState) {
              if (newState) {
                setState(() {
                  _selectedIndex = i;
                });
              }
            }),
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LinearProgressIndicator(
                      minHeight: 5,
                      backgroundColor: Colors.black,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.green),
                      value: _selectedIndex == i ? _completedPercentage : 0,
                    ),
                    IconButton(
                      icon: _selectedIndex == i
                          ? _isPlaying
                              ? const Icon(Icons.pause)
                              : const Icon(Icons.play_arrow)
                          : const Icon(Icons.play_arrow),
                      onPressed: () => _onPlay(filePath: item.path, index: i),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      );
    });
  }

  Future<void> _onPlay({required String filePath, required int index}) async {
    AudioPlayer audioPlayer = AudioPlayer();

    if (!_isPlaying) {
      audioPlayer.play(DeviceFileSource(filePath));
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerComplete.listen((_) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }
  }

  String _formatDate({required DateTime recordedDate}) {
    return (DateFormat('EEE, MMM d, ' 'yyyy, HH:mm').format(recordedDate));
  }
}

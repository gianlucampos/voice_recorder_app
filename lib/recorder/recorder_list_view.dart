import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
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
  final AudioPlayer _audioPlayer = AudioPlayer();

  int _selectedIndex = -1;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        _duration = newDuration;
      });
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        _position = newPosition;
      });
    });
    // _audioPlayer.onPlayerComplete.listen((_) {
    //   setState(() {
    //     _isPlaying = false;
    //   });
    // });
  }

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
            subtitle: Text(item.dtCreateFormatted),
            trailing: SizedBox(
              width: 90,
              child: Row(
                children: [
                  Column(
                    children: [
                      const Text('0:24'),
                      const SizedBox(height: 10),
                      Text('${item.sizeInMb} MB')
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (context) => RecorderModal(recorderFile: item),
                      );
                    },
                  ),
                ],
              ),
            ),
            onExpansionChanged: ((newState) {
              if (newState) {
                setState(() {
                  _selectedIndex = i;
                });
              }
            }),
            children: [
              _buildPositionBar(i, item),
            ],
          );
        },
      );
    });
  }

  Widget _buildPositionBar(int i, RecorderFile item) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Slider(
            min: 0,
            max: _duration.inSeconds.toDouble(),
            value: _position.inSeconds.toDouble(),
            onChanged: (value) async {
              // if (_selectedIndex == i) return;
              final position = Duration(seconds: value.toInt());
              await _audioPlayer.seek(position);
              await _audioPlayer.resume();
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatTime(_position)),
                Text(_formatTime(_duration - _position)),
              ],
            ),
          ),
          IconButton(
            icon: _selectedIndex == i
                ? _isPlaying
                    ? const Icon(Icons.pause)
                    : const Icon(Icons.play_arrow)
                : const Icon(Icons.play_arrow),
            iconSize: 35,
            onPressed: () async {
              if (_isPlaying) {
                await _audioPlayer.pause();
              } else {
                await _audioPlayer.play(DeviceFileSource(item.path));
                setState(() {
                  _selectedIndex = i;
                });
              }
            },
          )
        ],
      ),
    );
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    final twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}

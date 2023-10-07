import 'package:flutter/material.dart';
import 'package:voice_recorder_app/main.dart';
import 'package:voice_recorder_app/recorder/store/recorder_store.dart';

class RecorderModalEditName extends StatelessWidget {
  RecorderModalEditName({super.key, required String recorderName})
      : _recorderName = recorderName;

  final String _recorderName;
  final RecorderStore _recorderStore = getIt<RecorderStore>();
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Rename recording',
        style: Theme.of(context).textTheme.titleLarge!,
      ),
      content: TextField(
        controller: _controller,
      ),
      actions: [
        TextButton(
            onPressed: () {
              _recorderStore.updateRecorderFileName(
                oldName: _recorderName,
                newName: _controller.text,
              );
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Rename')),
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel')),
      ],
    );
  }
}

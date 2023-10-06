import 'package:flutter/material.dart';
import 'package:voice_recorder_app/main.dart';
import 'package:voice_recorder_app/models/recorder_file.dart';
import 'package:voice_recorder_app/recorder/store/recorder_store.dart';

class RecorderModal extends StatelessWidget {
  RecorderModal({super.key, required RecorderFile recorderFile})
      : _recorderFile = recorderFile;

  final RecorderFile _recorderFile;
  final RecorderStore _recorderStore = getIt<RecorderStore>();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            'Name of recorder.wav',
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Colors.blue),
          ),
          const SizedBox(height: 20),
          TextButton(
            child: Text(
              'Export',
              style: Theme.of(context).textTheme.labelLarge!,
            ),
            onPressed: () {
              //TODO widget to share audio in social media
              Navigator.of(context).pop();

            },
          ),
          TextButton(
            child: Text(
              'Rename',
              style: Theme.of(context).textTheme.labelLarge!,
            ),
            onPressed: () {
              //TODO create another modal with input name then call store to update
              Navigator.of(context).pop();

            },
          ),
          TextButton(
            child: Text(
              'Delete',
              style: Theme.of(context).textTheme.labelLarge!,
            ),
            onPressed: () {
              _recorderStore.removeRecorderFile(_recorderFile);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}

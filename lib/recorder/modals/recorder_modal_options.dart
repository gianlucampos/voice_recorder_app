import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:voice_recorder_app/main.dart';
import 'package:voice_recorder_app/models/recorder_file.dart';
import 'package:voice_recorder_app/recorder/modals/recorder_modal_edit_name.dart';
import 'package:voice_recorder_app/recorder/store/recorder_store.dart';

class RecorderModalOptions extends StatelessWidget {
  RecorderModalOptions({super.key, required RecorderFile recorderFile})
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
            _recorderFile.nameWithoutExtension,
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
            onPressed: () async {
              final XFile xfile = XFile(_recorderFile.path);
              await Share.shareXFiles(
                [xfile],
                text: 'Audio',
                subject: 'Subject',
              );
              if (context.mounted) Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text(
              'Rename',
              style: Theme.of(context).textTheme.labelLarge!,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) =>
                    RecorderModalEditName(recorderName: _recorderFile.name),
              );
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

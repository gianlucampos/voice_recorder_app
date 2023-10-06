// ignore_for_file: library_private_types_in_public_api
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:voice_recorder_app/models/recorder_file.dart';

import 'package:mobx/mobx.dart';

part 'recorder_store.g.dart';

class RecorderStore = _RecorderStore with _$RecorderStore;

abstract class _RecorderStore with Store {

  @readonly
  List<RecorderFile> _records = [];

  get records => _records;

  @action
  void loadRecordFiles() {
    _records.clear();
    getApplicationDocumentsDirectory().then((value) {
      value.list().listen((onData) async {
        if (onData.path.contains('.aac')) await _addRecorderFile(onData);
      }).onDone(() {
        _sortList();
        _reverseListOrder();
      });
    });
  }

  @action
  void removeRecorderFile(RecorderFile recorderFile) {
    File(recorderFile.path).deleteSync();
    _records.remove(recorderFile);
    _sortList();
    _reverseListOrder();
  }

  @action
  void updateRecorderFileName({
    required String oldName,
    required String newName,
  }) {
    File(oldName).renameSync(newName);
    final index = _records.indexWhere((elem) => elem.path == oldName);
    _records[index].path = newName;
  }

  void _sortList() {
    _records.sort((a, b) => a.dtCreate.compareTo(b.dtCreate));
  }

  void _reverseListOrder() {
    _records = _records.reversed.toList();
  }

  Future<void> _addRecorderFile(FileSystemEntity onData) async {
    final stats = await onData.stat();
    final recorderFile = RecorderFile(
        path: onData.path, size: stats.size, dtCreate: stats.changed);
    _records.add(recorderFile);
  }
}

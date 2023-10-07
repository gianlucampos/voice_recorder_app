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
        _reverseListOrder();
        _sortList();
      });
    });
  }

  @action
  void removeRecorderFile(RecorderFile recorderFile) {
    File(recorderFile.path).deleteSync();
    _records.remove(recorderFile);
    _reverseListOrder();
    _sortList();
  }

  @action
  void updateRecorderFileName({
    required String oldName,
    required String newName,
  }) {
    final index = _records.indexWhere((elem) => elem.name == oldName);
    final oldPath = _records[index].path;
    final newPath = _records[index].path.replaceAll(oldName, '$newName.aac');
    File(oldPath).renameSync(newPath);
    _records[index].path = newPath;
    loadRecordFiles();
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
        path: onData.path, size: stats.size, dtCreate: stats.modified);
    _records.add(recorderFile);
  }
}

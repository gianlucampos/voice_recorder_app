// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recorder_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RecorderStore on _RecorderStore, Store {
  late final _$_recordsAtom =
      Atom(name: '_RecorderStore._records', context: context);

  List<RecorderFile> get records {
    _$_recordsAtom.reportRead();
    return super._records;
  }

  @override
  List<RecorderFile> get _records => records;

  @override
  set _records(List<RecorderFile> value) {
    _$_recordsAtom.reportWrite(value, super._records, () {
      super._records = value;
    });
  }

  late final _$_RecorderStoreActionController =
      ActionController(name: '_RecorderStore', context: context);

  @override
  void loadRecordFiles() {
    final _$actionInfo = _$_RecorderStoreActionController.startAction(
        name: '_RecorderStore.loadRecordFiles');
    try {
      return super.loadRecordFiles();
    } finally {
      _$_RecorderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void removeRecorderFile(RecorderFile recorderFile) {
    final _$actionInfo = _$_RecorderStoreActionController.startAction(
        name: '_RecorderStore.removeRecorderFile');
    try {
      return super.removeRecorderFile(recorderFile);
    } finally {
      _$_RecorderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateRecorderFileName(
      {required String oldName, required String newName}) {
    final _$actionInfo = _$_RecorderStoreActionController.startAction(
        name: '_RecorderStore.updateRecorderFileName');
    try {
      return super.updateRecorderFileName(oldName: oldName, newName: newName);
    } finally {
      _$_RecorderStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}

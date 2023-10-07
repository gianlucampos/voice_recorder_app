import 'package:intl/intl.dart';

class RecorderFile {
  String path;
  final int size;
  final DateTime dtCreate;

  RecorderFile({
    required this.path,
    required this.size,
    required this.dtCreate,
  });

  String get name => path.split('/').last;

  String get nameWithoutExtension =>
      path.split('/').last.replaceAll('.aac', '');

  int get sizeInMb => size ~/ 1024;

  String get dtCreateFormatted =>
      DateFormat('EEE, MMM d, ' 'yyyy, HH:mm').format(dtCreate);

  @override
  String toString() {
    return 'RecorderFile{path: $path, size: $size, dtCreate: $dtCreate}';
  }
}

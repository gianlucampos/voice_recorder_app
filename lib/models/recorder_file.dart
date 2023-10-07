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

  get name => path.split('/').last;

  get sizeInMb => size ~/ 1024;

  get dtCreateFormatted =>
      DateFormat('EEE, MMM d, ' 'yyyy, HH:mm').format(dtCreate);

  @override
  String toString() {
    return 'RecorderFile{path: $path, size: $size, dtCreate: $dtCreate}';
  }
}

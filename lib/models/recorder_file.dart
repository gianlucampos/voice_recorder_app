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

  @override
  String toString() {
    return 'RecorderFile{path: $path, size: $size, dtCreate: $dtCreate}';
  }
}

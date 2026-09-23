class AppPickedFile {
  final String name;
  final List<int> bytes;
  final int size;
  final String? path;

  const AppPickedFile({
    required this.name,
    required this.bytes,
    required this.size,
    this.path,
  });
}

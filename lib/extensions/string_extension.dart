import 'dart:io';

extension StringExtension on String {
  bool isValidUrl() {
    final Uri? uri = Uri.tryParse(this);
    return !uri!.hasAbsolutePath ? true : false;
  }

  bool isURL() {
    final pattern = RegExp(
        r'^(http(s)?:\/\/)?(www\.)?[a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)$');
    return pattern.hasMatch(this);
  }

  String getFullFilePath(String basePath) {
    final fileUrl = isURL()
        ? "$basePath/${split("-fkey-").last}"
        : "$basePath/${split("/").last}";
    return fileUrl;
  }

  bool fileExistLocally(String basePath) {
    final fileUrl = isURL()
        ? "$basePath/${split("-fkey-").last}"
        : "$basePath/${split("/").last}";
    return File(fileUrl).existsSync();
  }
}

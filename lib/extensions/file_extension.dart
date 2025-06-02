import 'dart:io';

extension FileExtention on FileSystemEntity {
  String get name {
    return path.split("/").last;
  }

  String get ext {
    return path.split(".").last;
  }

  double get size {
    return File(path).lengthSync() / 1024;
  }

  bool fileExists() {
    return File(path).existsSync();
  }

  bool isImage() {
    return ext.toLowerCase() == "jpg" || ext.toLowerCase() == "png" || ext.toLowerCase() == "jpeg";
  }
}

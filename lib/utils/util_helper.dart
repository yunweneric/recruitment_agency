import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:recruitment_agents/utils/logger.dart';
import 'package:recruitment_agents/utils/toast.dart';

class UtilHelper {
  static String getMimeType(String ext) {
    final lowerExt = ext.toLowerCase().replaceAll('.', '');

    switch (lowerExt) {
      case 'pdf':
        return 'application/pdf';
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'webp':
        return 'image/webp';
      case 'gif':
        return 'image/gif';
      case 'svg':
        return 'image/svg+xml';
      case 'mp4':
        return 'video/mp4';
      default:
        return 'application/pdf'; // More general fallback
    }
  }

  static Future<List<PlatformFile>> pickFile({
    String? initialDirectory,
    bool? allowMultiple,
    List<String>? allowedExtensions,
    FileType? fileType,
    double? maxSizeInMB,
  }) async {
    final Directory documentsDir = await getApplicationDocumentsDirectory();

    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple ?? true,
        initialDirectory: '${documentsDir.path}/Downloads',
        type: fileType ?? FileType.any,
        allowedExtensions: allowedExtensions,
      );
      List<PlatformFile> allFiles = [];
      if (result != null) {
        List<PlatformFile> files = result.files;
        if (maxSizeInMB == null) {
          return files;
        }
        for (var file in files) {
          final size = file.size / (1024 * 1024);
          if (size > maxSizeInMB) {
            AppToast.showToastError(
              '${file.name} size exceeds $maxSizeInMB MB',
            );
          } else {
            allFiles.add(file);
          }
        }
        return allFiles;
      } else {
        return [];
      }
    } catch (e) {
      AppLogger.e(e);
      throw Exception(e);
    }
  }
}

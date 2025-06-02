import 'package:dio/dio.dart';
import 'package:firebase_vertexai/firebase_vertexai.dart';

class AppException implements Exception {
  AppException({required this.error, this.message});
  final dynamic error;
  final String? message;

  Map<String, dynamic> toJson() {
    return {'error': error};
  }

  static String getMessage(dynamic e) {
    String message = "There was an error processing your request. Please try again later!";
    if (e.runtimeType == DioException) {
      return e.message;
    }

    if (e.runtimeType == ServerException) {
      return e.message;
    }
    if (e is AppException) {
      AppException? current = e;

      while (current?.error is AppException) {
        // Update message if available
        if (current?.message != null) {
          message = current!.message!;
        }
        // Move to the next nested AppException
        current = current!.error as AppException;
      }

      // Capture the deepest message (if it exists)
      if (current?.message != null) {
        message = current!.message!;
      }
    }
    return message;
  }
}

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class FilePickerHelper {
  // Pick a document file (PDF, DOC, DOCX, etc.)
  static Future<File?> pickDocument({
    List<String> allowedExtensions = const ['pdf', 'doc', 'docx', 'jpg', 'jpeg', 'png'],
    BuildContext? context,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking file: $e');
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking file: $e')),
        );
      }
      return null;
    }
  }

  // Pick an image file
  static Future<File?> pickImage({
    BuildContext? context,
  }) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return File(result.files.single.path!);
      }
      return null;
    } catch (e) {
      debugPrint('Error picking image: $e');
      if (context != null && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
      return null;
    }
  }

  // Validate file size (in bytes)
  static bool validateFileSize(File file, int maxSizeInBytes) {
    final fileSize = file.lengthSync();
    return fileSize <= maxSizeInBytes;
  }

  // Get file extension
  static String getFileExtension(File file) {
    return file.path.split('.').last.toLowerCase();
  }

  // Check if file type is valid
  static bool isValidFileType(File file, List<String> allowedExtensions) {
    final extension = getFileExtension(file);
    return allowedExtensions.contains(extension);
  }

  // Get file name from path
  static String getFileName(File file) {
    return file.path.split('/').last;
  }

  // Format file size for display
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  // Get file size in bytes
  static int getFileSize(File file) {
    return file.lengthSync();
  }

  // Validate and get file info
  static Map<String, dynamic> validateFile(
    File file, {
    int maxSizeInBytes = 5 * 1024 * 1024, // 5MB default
    List<String> allowedExtensions = const ['pdf', 'jpg', 'jpeg', 'png'],
  }) {
    final isValidSize = validateFileSize(file, maxSizeInBytes);
    final isValidType = isValidFileType(file, allowedExtensions);
    final fileSize = getFileSize(file);
    final fileName = getFileName(file);
    final extension = getFileExtension(file);

    return {
      'isValid': isValidSize && isValidType,
      'isValidSize': isValidSize,
      'isValidType': isValidType,
      'fileName': fileName,
      'fileSize': fileSize,
      'fileSizeFormatted': formatFileSize(fileSize),
      'extension': extension,
      'maxSize': maxSizeInBytes,
      'maxSizeFormatted': formatFileSize(maxSizeInBytes),
      'allowedExtensions': allowedExtensions,
      'errorMessage': !isValidSize
          ? 'File size exceeds ${formatFileSize(maxSizeInBytes)}'
          : !isValidType
              ? 'Invalid file type. Allowed: ${allowedExtensions.join(', ')}'
              : null,
    };
  }
}

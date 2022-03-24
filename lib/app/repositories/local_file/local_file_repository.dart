import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/local_file/local_file_interface.dart';

final localFileRepositoryProvider = Provider<LocalFileRepository>(
  (ref) => LocalFileRepository(ref.read(localFileInterfaceProvider)),
);

class LocalFileRepository {
  const LocalFileRepository(this._localFileInterface);

  final LocalFileInterface _localFileInterface;

  Future<PlatformFile?> pickGlbFile() async {
    final result = await _localFileInterface.pickGlbFile();
    if (result == null) {
      return null;
    }
    return result.files.single;
  }

  MemoryImage? _handlePickedImageBytes(Uint8List? bytes) {
    if (bytes == null) {
      return null;
    }
    final image = MemoryImage(bytes);
    return image;
  }

  Future<MemoryImage?> pickPngFile() async {
    final result = await _localFileInterface.pickPngFile();
    if (result == null) {
      return null;
    }
    return _handlePickedImageBytes(result.files.single.bytes);
  }

  Future<MemoryImage?> pickJpegFile() async {
    final result = await _localFileInterface.pickJpegFile();
    if (result == null) {
      return null;
    }
    return _handlePickedImageBytes(result.files.single.bytes);
  }

  Future<List<MemoryImage>> pickJpegFiles() async {
    final result = await _localFileInterface.pickJpegFiles();
    if (result == null) {
      return [];
    }
    final images = result.files
        .map((file) => _handlePickedImageBytes(file.bytes))
        .whereType<MemoryImage>()
        .toList();
    return images;
  }
}

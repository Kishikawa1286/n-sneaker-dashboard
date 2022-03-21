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

  Future<MemoryImage?> pickImageFile() async {
    final result = await _localFileInterface.pickImageFile();
    if (result == null) {
      return null;
    }
    final bytes = result.files.single.bytes;
    if (bytes == null) {
      return null;
    }
    final image = MemoryImage(bytes);
    return image;
  }

  Future<List<MemoryImage>> pickImageFiles() async {
    final result = await _localFileInterface.pickImageFiles();
    if (result == null) {
      return [];
    }
    final bytesList =
        result.files.map((file) => file.bytes).whereType<Uint8List>().toList();
    final images = bytesList.map(MemoryImage.new).toList();
    return images;
  }
}

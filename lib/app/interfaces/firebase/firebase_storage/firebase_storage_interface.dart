// ignore: avoid_web_libraries_in_flutter
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final firebaseStorageInterface =
    Provider<FirebaseStorageInterface>((ref) => FirebaseStorageInterface());

class FirebaseStorageInterface {
  FirebaseStorageInterface();

  final _storage = FirebaseStorage.instance;

  Future<String> uploadFile({
    required String path,
    required Uint8List bytes,
    required String contentType,
  }) async {
    final ref = _storage.ref(path);

    final task =
        await ref.putData(bytes, SettableMetadata(contentType: contentType));

    final downloadUrl = await task.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> deleteFile({required String path}) async {
    final ref = _storage.ref(path);
    await ref.delete();
  }

  Future<void> deleteDirectory({required String path}) async {
    final directoryRef = _storage.ref(path);
    final listResult = await directoryRef.listAll();
    listResult.items.forEach((item) => deleteFile(path: item.fullPath));
    listResult.prefixes.forEach((ref) => deleteDirectory(path: ref.fullPath));
  }

  Future<String?> generateDownloadUrlFromImageProvider({
    required String filePath,
    required ImageProvider image,
    required String contentType,
  }) async {
    if (image is NetworkImage) {
      return image.url;
    }

    if (image is MemoryImage) {
      final url = await uploadFile(
        path: filePath,
        bytes: image.bytes,
        contentType: contentType,
      );
      return url;
    }

    return null;
  }
}

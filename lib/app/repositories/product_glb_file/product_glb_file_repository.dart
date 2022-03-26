import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/random_string.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import '../../interfaces/firebase/firebase_storage/content_type.dart';
import '../../interfaces/firebase/firebase_storage/firebase_storage_interface.dart';
import '../../interfaces/firebase/firebase_storage/firebase_storage_paths.dart';
import '../product/product_model.dart';
import 'product_glb_file.dart';

final productGlbFileRepositoryProvider = Provider<ProductGlbFileRepository>(
  (ref) => ProductGlbFileRepository(
    ref.read(cloudFirestoreInterfaceProvider),
    ref.read(firebaseStorageInterface),
  ),
);

class ProductGlbFileRepository {
  const ProductGlbFileRepository(
    this._cloudFirestoreInterface,
    this._firebaseStorageInterface,
  );

  final CloudFirestoreInterface _cloudFirestoreInterface;
  final FirebaseStorageInterface _firebaseStorageInterface;

  Future<ProductGlbFileModel> _convertDocumentSnapshotToProductGlbFileModel(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final data = doc.data();
    if (data == null) {
      throw Exception('DocumentSnapshot has no data.');
    }
    final id = data['id'] as String?;
    final productId = data['product_id'] as String?;
    if (id == null || productId == null) {
      throw Exception(
        'DocumentSnapshot does not have required id data.',
      );
    }
    return ProductGlbFileModel.fromDocumentSnapshotAndFileData(
      snapshot: doc,
      filePath: '',
      fileExists: false,
    );
  }

  Future<List<ProductGlbFileModel>>
      _convertDocumentSnapshotListToProductGlbFileModelList(
    List<DocumentSnapshot<Map<String, dynamic>>> docs,
  ) async =>
          (await Future.wait(
            docs.map((documentSnapshot) async {
              try {
                final productGlbFileModel =
                    await _convertDocumentSnapshotToProductGlbFileModel(
                  documentSnapshot,
                );
                return productGlbFileModel;
              } on Exception catch (e) {
                print(e);
                return null;
              }
            }).toList(),
          ))
              .whereType<ProductGlbFileModel>()
              .toList();

  Future<ProductGlbFileModel> fetchProductsGlbFileById({
    required String productId,
    required String productGlbFileId,
  }) async {
    final snapshot = await _cloudFirestoreInterface.fetchDocumentSnapshot(
      documentPath: productGlbFileDocumentPath(productId, productGlbFileId),
    );
    return _convertDocumentSnapshotToProductGlbFileModel(snapshot);
  }

  Future<List<ProductGlbFileModel>> fetchProductsGlbFiles(
    String productId, {
    int limit = 16,
    ProductGlbFileModel? startAfter,
  }) async {
    if (startAfter == null) {
      // startAfterを指定しない
      final snapshot =
          await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
        collectionPath: productGlbFilesCollectionPath(productId),
        queryBuilder: (query) =>
            query.orderBy('created_at', descending: true).limit(limit),
      );
      return _convertDocumentSnapshotListToProductGlbFileModelList(
        snapshot.docs,
      );
    }
    final startAfterDocumentSnapshot = startAfter.documentSnapshot;
    if (startAfterDocumentSnapshot == null) {
      return [];
    }
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: productGlbFilesCollectionPath(productId),
      queryBuilder: (query) => query
          .orderBy('created_at', descending: true)
          .limit(limit)
          .startAfterDocument(startAfterDocumentSnapshot),
    );
    return _convertDocumentSnapshotListToProductGlbFileModelList(snapshot.docs);
  }

  Future<void> addProductGlbFile({
    required bool availableForViewer,
    required bool availableForAr,
    required ProductModel product,
    required String title,
    required String titleJp,
    required List<ImageProvider> images,
    required PlatformFile productGlbFile,
  }) async {
    final bytes = productGlbFile.bytes;
    if (bytes == null) {
      return;
    }
    final glbFileId = lowercaseAlphabetRandomString();
    await _cloudFirestoreInterface.setData(
      documentPath: productGlbFileDocumentPath(product.id, glbFileId),
      data: <String, dynamic>{
        'id': glbFileId,
        'created_at': Timestamp.now(),
      },
    );
    final storagePath = productGlbFilePath(product.id, glbFileId);
    await _firebaseStorageInterface.uploadFile(
      path: storagePath,
      bytes: bytes,
      contentType: ContentType.glb,
    );
    await updateProductGlbFile(
      availableForViewer: availableForViewer,
      availableForAr: availableForAr,
      product: product,
      productGlbFileId: glbFileId,
      title: title,
      titleJp: titleJp,
      images: images,
    );
    await _cloudFirestoreInterface.setData(
      documentPath: productDocumentPath(product.id),
      data: <String, dynamic>{'number_of_glb_files': FieldValue.increment(1)},
    );
  }

  Future<void> updateProductGlbFile({
    required bool availableForViewer,
    required bool availableForAr,
    required ProductModel product,
    required String productGlbFileId,
    required String title,
    required String titleJp,
    required List<ImageProvider> images,
  }) async {
    final documentPath =
        productGlbFileDocumentPath(product.id, productGlbFileId);
    final imageUrls = (await Future.wait(
      images
          .map(
            (image) =>
                _firebaseStorageInterface.generateDownloadUrlFromImageProvider(
              filePath: productGlbFileImagePath(
                product.id,
                productGlbFileId,
                '${randomString()}.jpeg',
              ),
              image: image,
              contentType: ContentType.jpeg,
            ),
          )
          .toList(),
    ))
        .whereType<String>()
        .toList();
    if (imageUrls.isEmpty) {
      throw Exception('failed to upload images.');
    }
    await _cloudFirestoreInterface.setData(
      documentPath: documentPath,
      data: <String, dynamic>{
        'title': title,
        'title_jp': titleJp,
        'images': imageUrls,
        'last_edited_at': Timestamp.now(),
        'product_id': product.id,
        'product_title': product.title,
        'product_vendor': product.vendor,
        'product_series': product.series,
        'product_tags': product.tags,
        'product_title_jp': product.titleJp,
        'product_vendor_jp': product.vendorJp,
        'product_series_jp': product.seriesJp,
        'product_tags_jp': product.tagsJp,
      },
    );
  }

  Future<void> deleteProductGlbFile({
    required String productId,
    required String productGlbFileId,
  }) async {
    await _firebaseStorageInterface.deleteFile(
      path: productGlbFilePath(productId, productGlbFileId),
    );
    await _cloudFirestoreInterface.deleteData(
      documentPath: productGlbFileDocumentPath(productId, productGlbFileId),
    );
    await _cloudFirestoreInterface.setData(
      documentPath: productDocumentPath(productId),
      data: <String, dynamic>{'number_of_glb_files': FieldValue.increment(-1)},
    );
  }
}

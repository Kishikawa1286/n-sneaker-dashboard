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

  Future<String?> _generateDownloadUrlFromImageProvider(
    String productId,
    String productGlbFileId,
    ImageProvider image,
    String contentType,
  ) async {
    if (image is NetworkImage) {
      return image.url;
    }

    // Image Picker で png 画像以外を弾くので png 固定でよい
    if (image is MemoryImage) {
      final storagePath = productGlbFileImagePath(
        productId,
        productGlbFileId,
        '${randomString()}.png',
      );
      final url = await _firebaseStorageInterface.uploadFile(
        path: storagePath,
        bytes: image.bytes,
        contentType: contentType,
      );
      return url;
    }

    return null;
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
    final documentRef = await _cloudFirestoreInterface.addData(
      collectionPath: productGlbFilesCollectionPath(product.id),
      data: <String, dynamic>{},
    );
    final storagePath = productGlbFilePath(
      product.id,
      documentRef.id,
    );
    await _firebaseStorageInterface.uploadFile(
      path: storagePath,
      bytes: bytes,
      contentType: ContentType.glb,
    );
    try {
      await updateProductGlbFile(
        product: product,
        productGlbFileId: documentRef.id,
        title: title,
        titleJp: titleJp,
        images: images,
      );
    } on Exception catch (e) {
      print(e);
    }
  }

  Future<void> updateProductGlbFile({
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
            (image) => _generateDownloadUrlFromImageProvider(
              product.id,
              productGlbFileId,
              image,
              ContentType.jpeg,
            ),
          )
          .toList(),
    ))
        .whereType<String>()
        .toList();
    if (imageUrls.isEmpty) {
      throw Exception('failed to upload images.');
    }
    final productGlbFile = ProductGlbFileModel(
      id: productGlbFileId,
      filePath: '',
      fileExists: false,
      title: title,
      titleJp: titleJp,
      imageUrls: imageUrls,
      createdAt: Timestamp.now(),
      lastEditedAt: Timestamp.now(),
      productId: product.id,
      productTitle: product.title,
      productVendor: product.vendor,
      productSeries: product.series,
      productTags: product.tags,
      productTitleJp: product.titleJp,
      productVendorJp: product.vendorJp,
      productSeriesJp: product.seriesJp,
      productTagsJp: product.tagsJp,
    );
    await _cloudFirestoreInterface.updateData(
      documentPath: documentPath,
      data: productGlbFile.toMap(),
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
  }
}

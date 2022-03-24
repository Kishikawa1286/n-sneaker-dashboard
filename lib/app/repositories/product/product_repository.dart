import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/random_string.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import '../../interfaces/firebase/firebase_storage/content_type.dart';
import '../../interfaces/firebase/firebase_storage/firebase_storage_interface.dart';
import '../../interfaces/firebase/firebase_storage/firebase_storage_paths.dart';
import 'product_model.dart';

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => ProductRepository(
    ref.read(cloudFirestoreInterfaceProvider),
    ref.read(firebaseStorageInterface),
  ),
);

class ProductRepository {
  const ProductRepository(
    this._cloudFirestoreInterface,
    this._firebaseStorageInterface,
  );

  final CloudFirestoreInterface _cloudFirestoreInterface;
  final FirebaseStorageInterface _firebaseStorageInterface;

  List<ProductModel> _convertDocumentSnapshotListToProductModelList(
    List<DocumentSnapshot<Map<String, dynamic>>> docs,
  ) =>
      docs
          .map((documentSnapshot) {
            try {
              return ProductModel.fromDocumentSnapshot(documentSnapshot);
            } on Exception catch (e) {
              print(e);
              return null;
            }
          })
          .toList()
          .whereType<ProductModel>()
          .toList();

  Future<String?> _generateDownloadUrlFromImageProvider(
    String productId,
    ImageProvider image,
    String contentType,
  ) async {
    if (image is NetworkImage) {
      return image.url;
    }

    // Image Picker で png 画像以外を弾くので png 固定でよい
    if (image is MemoryImage) {
      final storagePath = productImagePath(
        productId,
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

  Future<ProductModel> fetchProductById(String id) async {
    final snapshot = await _cloudFirestoreInterface.fetchDocumentSnapshot(
      documentPath: productDocumentPath(id),
    );
    return ProductModel.fromDocumentSnapshot(snapshot);
  }

  Future<List<ProductModel>> fetchProducts({
    int limit = 16,
    ProductModel? startAfter,
  }) async {
    if (startAfter == null) {
      // startAfterを指定しない
      final snapshot =
          await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
        collectionPath: productsCollectionPath,
        queryBuilder: (query) => query
            .orderBy('title', descending: true)
            .orderBy('created_at', descending: true)
            .limit(limit),
      );
      final products =
          _convertDocumentSnapshotListToProductModelList(snapshot.docs);
      return products;
    }
    final startAfterDocumentSnapshot = startAfter.documentSnapshot;
    if (startAfterDocumentSnapshot == null) {
      return [];
    }
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: productsCollectionPath,
      queryBuilder: (query) => query
          .orderBy('title', descending: true)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .startAfterDocument(startAfterDocumentSnapshot),
    );
    return _convertDocumentSnapshotListToProductModelList(snapshot.docs);
  }

  Future<void> addProduct({
    required bool visible,
    required String title,
    required String vendor,
    required String series,
    required List<String> tags,
    required String description,
    required String collectionProductStatement,
    required String arStatement,
    required String otherStatement,
    required String titleJp,
    required String vendorJp,
    required String seriesJp,
    required List<String> tagsJp,
    required String descriptionJp,
    required String collectionProductStatementJp,
    required String arStatementJp,
    required String otherStatementJp,
    required List<ImageProvider> images,
    required ImageProvider tileImage,
    required ImageProvider transparentBackgroundImage,
    required int priceJpy,
  }) async {
    final documentRef = await _cloudFirestoreInterface.addData(
      collectionPath: productsCollectionPath,
      data: <String, dynamic>{},
    );
    try {
      await updateProduct(
        visible: visible,
        id: documentRef.id,
        title: title,
        vendor: vendor,
        series: series,
        tags: tags,
        description: description,
        collectionProductStatement: collectionProductStatement,
        arStatement: arStatement,
        otherStatement: otherStatement,
        titleJp: titleJp,
        vendorJp: vendorJp,
        seriesJp: seriesJp,
        tagsJp: tagsJp,
        descriptionJp: descriptionJp,
        collectionProductStatementJp: collectionProductStatementJp,
        arStatementJp: arStatementJp,
        otherStatementJp: otherStatementJp,
        images: images,
        tileImage: tileImage,
        transparentBackgroundImage: transparentBackgroundImage,
        priceJpy: priceJpy,
      );
    } on Exception catch (e) {
      print(e);
      await _cloudFirestoreInterface.deleteData(documentPath: documentRef.path);
    }
  }

  Future<void> updateProduct({
    required bool visible,
    required String id,
    required String title,
    required String vendor,
    required String series,
    required List<String> tags,
    required String description,
    required String collectionProductStatement,
    required String arStatement,
    required String otherStatement,
    required String titleJp,
    required String vendorJp,
    required String seriesJp,
    required List<String> tagsJp,
    required String descriptionJp,
    required String collectionProductStatementJp,
    required String arStatementJp,
    required String otherStatementJp,
    required List<ImageProvider> images,
    required ImageProvider tileImage,
    required ImageProvider transparentBackgroundImage,
    required int priceJpy,
  }) async {
    final documentPath = productDocumentPath(id);
    final imageUrls = (await Future.wait(
      images
          .map(
            (image) => _generateDownloadUrlFromImageProvider(
              id,
              image,
              ContentType.jpeg,
            ),
          )
          .toList(),
    ))
        .whereType<String>()
        .toList();
    final tileImageUrl = await _generateDownloadUrlFromImageProvider(
      id,
      tileImage,
      ContentType.jpeg,
    );
    final transparentBackgroundImageUrl =
        await _generateDownloadUrlFromImageProvider(
      id,
      transparentBackgroundImage,
      ContentType.png,
    );
    if (imageUrls.isEmpty ||
        tileImageUrl == null ||
        transparentBackgroundImageUrl == null) {
      throw Exception('failed to upload images.');
    }
    final product = ProductModel(
      visible: visible,
      id: id,
      title: title,
      vendor: vendor,
      series: series,
      tags: tags,
      description: description,
      collectionProductStatement: collectionProductStatement,
      arStatement: arStatement,
      otherStatement: otherStatement,
      titleJp: titleJp,
      vendorJp: vendorJp,
      seriesJp: seriesJp,
      tagsJp: tagsJp,
      descriptionJp: descriptionJp,
      collectionProductStatementJp: collectionProductStatementJp,
      arStatementJp: arStatementJp,
      otherStatementJp: otherStatementJp,
      imageUrls: imageUrls,
      tileImageUrls: [tileImageUrl],
      transparentBackgroundImageUrls: [transparentBackgroundImageUrl],
      priceJpy: priceJpy,
      numberOfFavorite: 0,
      numberOfHolders: 0,
      numberOfGlbFiles: 0,
      createdAt: Timestamp.now(),
      lastEditedAt: Timestamp.now(),
    );
    await _cloudFirestoreInterface.updateData(
      documentPath: documentPath,
      data: product.toMap(),
    );
  }
}

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

  Future<String?> _generateDownloadUrlFromImageProvider({
    required String productId,
    required String fileName,
    required ImageProvider image,
    required String contentType,
  }) =>
      _firebaseStorageInterface.generateDownloadUrlFromImageProvider(
        filePath: productImagePath(productId, fileName),
        image: image,
        contentType: contentType,
      );

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

  Future<List<ProductModel>> fetchAll({
    int limit = 128,
    ProductModel? startAfter,
  }) async {
    final fetched = await fetchProducts(limit: limit, startAfter: startAfter);
    if (fetched.length < limit) {
      return fetched;
    }
    return [
      ...fetched,
      ...await fetchAll(limit: limit, startAfter: fetched.last),
    ];
  }

  Future<void> addProduct({
    required String adaptyPaywallId,
    required String restorableAdaptyVendorProductIdsAsString,
    required bool visibleInMarket,
    required bool availableInTrial,
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
    final id = lowercaseAlphabetRandomString();
    await _cloudFirestoreInterface.setData(
      documentPath: productDocumentPath(id),
      data: <String, dynamic>{
        'id': id,
        'number_of_favorite': 0,
        'number_of_holders': 0,
        'number_of_glb_files': 0,
        'created_at': Timestamp.now(),
      },
    );
    try {
      await updateProduct(
        adaptyPaywallId: adaptyPaywallId,
        restorableAdaptyVendorProductIdsAsString:
            restorableAdaptyVendorProductIdsAsString,
        visibleInMarket: visibleInMarket,
        availableInTrial: availableInTrial,
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
        images: images,
        tileImage: tileImage,
        transparentBackgroundImage: transparentBackgroundImage,
        priceJpy: priceJpy,
      );
    } on Exception catch (e) {
      print(e);
      await _cloudFirestoreInterface.deleteData(
        documentPath: productDocumentPath(id),
      );
    }
  }

  Future<void> updateProduct({
    required String adaptyPaywallId,
    required String restorableAdaptyVendorProductIdsAsString,
    required bool visibleInMarket,
    required bool availableInTrial,
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
              productId: id,
              fileName: '${randomString()}.jpeg',
              image: image,
              contentType: ContentType.jpeg,
            ),
          )
          .toList(),
    ))
        .whereType<String>()
        .toList();
    final tileImageUrl = await _generateDownloadUrlFromImageProvider(
      productId: id,
      fileName: '${randomString()}.jpeg',
      image: tileImage,
      contentType: ContentType.jpeg,
    );
    final transparentBackgroundImageUrl =
        await _generateDownloadUrlFromImageProvider(
      productId: id,
      fileName: '${randomString()}.png',
      image: transparentBackgroundImage,
      contentType: ContentType.png,
    );
    if (imageUrls.isEmpty ||
        tileImageUrl == null ||
        transparentBackgroundImageUrl == null) {
      throw Exception('failed to upload images.');
    }
    final restorableAdaptyVendorProductIds =
        restorableAdaptyVendorProductIdsAsString.split(',');
    await _cloudFirestoreInterface.setData(
      documentPath: documentPath,
      data: <String, dynamic>{
        'adapty_paywall_id': adaptyPaywallId,
        'restorable_adapty_vendor_product_ids':
            restorableAdaptyVendorProductIds,
        'title': title,
        'vendor': vendor,
        'series': series,
        'tags': tags,
        'description': description,
        'collection_product_statement': collectionProductStatement,
        'ar_statement': arStatement,
        'other_statement': otherStatement,
        'title_jp': titleJp,
        'vendor_jp': vendorJp,
        'series_jp': seriesJp,
        'tags_jp': tagsJp,
        'description_jp': descriptionJp,
        'collection_product_statement_jp': collectionProductStatementJp,
        'ar_statement_jp': arStatementJp,
        'other_statement_jp': otherStatementJp,
        'images': imageUrls,
        'tile_images': [tileImageUrl],
        'transparent_background_images': [transparentBackgroundImageUrl],
        'price_jpy': priceJpy,
        'vivsible_in_market': visibleInMarket,
        'available_in_trial': availableInTrial,
        'last_edited_at': Timestamp.now(),
      },
    );
  }
}

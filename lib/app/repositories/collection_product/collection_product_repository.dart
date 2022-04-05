import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/enum_to_string.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import '../product/product_model.dart';
import 'collection_product_model.dart';
import 'payment_method.dart';

final collectionProductRepositoryProvider =
    Provider<CollectionProductRepository>(
  (ref) =>
      CollectionProductRepository(ref.read(cloudFirestoreInterfaceProvider)),
);

class CollectionProductRepository {
  const CollectionProductRepository(this._cloudFirestoreInterface);

  final CloudFirestoreInterface _cloudFirestoreInterface;

  List<CollectionProductModel>
      _convertDocumentSnapshotListToCollectionProductModelList(
    List<DocumentSnapshot<Map<String, dynamic>>> docs,
  ) =>
          docs
              .map((documentSnapshot) {
                try {
                  return CollectionProductModel.fromDocumentSnapshot(
                    documentSnapshot,
                  );
                } on Exception catch (e) {
                  print(e);
                  return null;
                }
              })
              .toList()
              .whereType<CollectionProductModel>()
              .toList();

  Future<bool> checkIfDocumentExists({
    required String accountId,
    required String productId,
  }) async {
    final querySnapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: collectionProductsCollectionPath,
      queryBuilder: (query) => query
          .where('account_id', isEqualTo: accountId)
          .where('product_id', isEqualTo: productId)
          .limit(1),
    );
    final docs = querySnapshot.docs;
    if (docs.isEmpty) {
      return false;
    }
    return true;
  }

  Future<List<CollectionProductModel>> fetchFromFirestore(
    String accountId, {
    int limit = 16,
    CollectionProductModel? startAfter,
  }) async {
    if (startAfter == null) {
      // startAfterを指定しない
      final snapshot =
          await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
        collectionPath: collectionProductsCollectionPath,
        queryBuilder: (query) => query
            .where('account_id', isEqualTo: accountId)
            .orderBy('created_at', descending: true)
            .limit(limit),
      );
      return _convertDocumentSnapshotListToCollectionProductModelList(
        snapshot.docs,
      );
    }
    final startAfterDocumentSnapshot = startAfter.documentSnapshot;
    // 通常 not null だが nullble を解除するためにチェック
    if (startAfterDocumentSnapshot == null) {
      return [];
    }
    final snapshot =
        await _cloudFirestoreInterface.collectionFuture<Map<String, dynamic>>(
      collectionPath: collectionProductsCollectionPath,
      queryBuilder: (query) => query
          .where('account_id', isEqualTo: accountId)
          .orderBy('created_at', descending: true)
          .limit(limit)
          .startAfterDocument(startAfterDocumentSnapshot),
    );
    return _convertDocumentSnapshotListToCollectionProductModelList(
      snapshot.docs,
    );
  }

  Future<List<CollectionProductModel>> _fetchAll(
    String accountId, {
    int limit = 128,
    CollectionProductModel? startAfter,
  }) async {
    final fetched = await fetchFromFirestore(
      accountId,
      limit: limit,
      startAfter: startAfter,
    );
    if (fetched.length < limit) {
      return fetched;
    }
    return [
      ...fetched,
      ...await _fetchAll(accountId, limit: limit, startAfter: fetched.last),
    ];
  }

  Future<void> addCollectionProduct({
    required String accountId,
    required ProductModel product,
    bool skipValidation = false, // 確認済みの場合にスキップする
    bool changeNumberOfHolders = true, // アドミンはカウントしない
  }) async {
    if (!skipValidation) {
      // 既に存在するなら実行しない
      // 多重登録防止
      if (await checkIfDocumentExists(
        accountId: accountId,
        productId: product.id,
      )) {
        return;
      }
    }
    final documentRef = await _cloudFirestoreInterface.addData(
      collectionPath: collectionProductsCollectionPath,
      data: <String, dynamic>{
        'account_id': accountId,
        'payment_method': enumToString(PaymentMethod.dashboard),
        'created_at': Timestamp.now(),
        'last_edited_at': Timestamp.now(),
        'product_id': product.id,
        'title': product.title,
        'vendor': product.vendor,
        'series': product.series,
        'tags': product.tags,
        'description': product.description,
        'collection_product_statement': product.collectionProductStatement,
        'ar_statement': product.arStatement,
        'other_statement': product.otherStatement,
        'title_jp': product.titleJp,
        'vendor_jp': product.vendorJp,
        'series_jp': product.seriesJp,
        'tags_jp': product.tagsJp,
        'description_jp': product.descriptionJp,
        'collection_product_statement_jp': product.collectionProductStatementJp,
        'ar_statement_jp': product.arStatementJp,
        'other_statement_jp': product.otherStatementJp,
        'images': product.imageUrls,
        'tile_images': product.tileImageUrls,
        'transparent_background_images': product.transparentBackgroundImageUrls,
      },
    );
    await _cloudFirestoreInterface.setData(
      documentPath: collectionProductDocumentPath(documentRef.id),
      data: <String, dynamic>{'id': documentRef.id},
    );
    await _cloudFirestoreInterface.setData(
      documentPath: accountDocumentPath(accountId),
      data: <String, dynamic>{
        'number_of_collection_products': FieldValue.increment(1),
      },
    );
    if (changeNumberOfHolders) {
      await _cloudFirestoreInterface.setData(
        documentPath: productDocumentPath(product.id),
        data: <String, dynamic>{
          'number_of_holders': FieldValue.increment(1),
        },
      );
    }
  }

  Future<void> addCollectionProducts({
    required String accountId,
    required List<ProductModel> products,
  }) async {
    final currentAllCollectionProducts = await _fetchAll(accountId);
    final productIdsOfcurrentAllCollectionProducts =
        currentAllCollectionProducts
            .map((collectionProduct) => collectionProduct.productId)
            .toList();
    // 未登録のものだけ取り出す
    final targetCollectionProducts = products
        .where(
          (product) =>
              !productIdsOfcurrentAllCollectionProducts.contains(product.id),
        )
        .toList();
    await Future.wait(
      targetCollectionProducts.map(
        (product) async => addCollectionProduct(
          accountId: accountId,
          product: product,
          skipValidation: true,
          changeNumberOfHolders: false,
        ),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import 'product_glb_file.dart';

final productGlbFileRepositoryProvider = Provider<ProductGlbFileRepository>(
  (ref) => ProductGlbFileRepository(ref.read(cloudFirestoreInterfaceProvider)),
);

class ProductGlbFileRepository {
  const ProductGlbFileRepository(this._cloudFirestoreInterface);

  final CloudFirestoreInterface _cloudFirestoreInterface;

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
}

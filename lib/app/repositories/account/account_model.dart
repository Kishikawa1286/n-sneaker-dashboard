import 'package:cloud_firestore/cloud_firestore.dart';

class AccountModel {
  const AccountModel({
    required this.id,
    required this.numberOfProductsPurchased,
    required this.createdAt,
    required this.lastEditedAt,
  });

  factory AccountModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
  ) {
    final data = snapshot.data();
    if (data == null) {
      throw Exception('DocumentSnapshot has no data.');
    }
    return AccountModel(
      id: data['id'] as String,
      numberOfProductsPurchased:
          int.tryParse(data['number_of_products_purchased'].toString()) ?? 0,
      createdAt: data['created_at'] as Timestamp,
      lastEditedAt: data['last_edited_at'] as Timestamp,
    );
  }

  final String id;
  final int numberOfProductsPurchased;
  final Timestamp createdAt;
  final Timestamp lastEditedAt;
}

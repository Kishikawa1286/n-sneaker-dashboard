import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../interfaces/firebase/cloud_firestore/cloud_firestore_interface.dart';
import '../../interfaces/firebase/cloud_firestore/cloud_firestore_paths.dart';
import '../../interfaces/firebase/cloud_functions/cloud_functions_interface.dart';
import '../../interfaces/firebase/firebase_auth/firebase_auth_interface.dart';
import 'account_model.dart';

final accountRepositoryProvider = Provider<AccountRepository>(
  (ref) => AccountRepository(
    ref.read(firebaseAuthInterfaceProvider),
    ref.read(cloudFirestoreInterfaceProvider),
    ref.read(cloudFunctionsInterfaceProvider),
  ),
);

class AccountRepository {
  const AccountRepository(
    this._firebaseAuthInterface,
    this._cloudFirestoreInterface,
    this._cloudFunctionsInterface,
  );

  final FirebaseAuthInterface _firebaseAuthInterface;
  final CloudFirestoreInterface _cloudFirestoreInterface;
  final CloudFunctionsInterface _cloudFunctionsInterface;

  User? getCurrentUser() => _firebaseAuthInterface.getCurrentUser();

  Future<AccountModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Firebase Authでログインを試みる
      // 未登録ならば新規作成される
      final userCredential =
          await _firebaseAuthInterface.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = userCredential.user?.uid;
      // nullになるのは例外のとき
      // userIdをString?からStringにするためのコード
      if (userId == null) {
        throw Exception('uid is null. something went wrong.');
      }
      final documentSnapshot =
          await _cloudFirestoreInterface.fetchDocumentSnapshot(
        documentPath: accountDocumentPath(userId),
      );
      return AccountModel.fromDocumentSnapshot(documentSnapshot);
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) =>
      _firebaseAuthInterface.sendPasswordResetEmail(email: email);

  Future<void> signOut() => _firebaseAuthInterface.signOut();
}

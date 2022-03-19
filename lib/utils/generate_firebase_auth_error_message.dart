import 'package:firebase_auth/firebase_auth.dart';

String generateFirebaseAuthErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
    case 'invalid-email':
      return 'email address is invalid.';
    case 'wrong-password':
      return 'password is wrong.';
    case 'user-disabled':
      return 'account is disabled by admin.';
    case 'user-not-found':
      return 'account does not found.';
    case 'operation-not-allowed':
      return 'you do not have enough permission.';
    case 'too-many-requests':
      return 'too many requests. try later.';
    case 'email-already-exists':
      return 'the email address already exists.';
    case 'email-already-in-use':
      return 'the email address is already used.';
    default:
      return 'configure email and password.';
  }
}

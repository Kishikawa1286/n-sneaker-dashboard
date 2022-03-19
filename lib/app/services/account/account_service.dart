import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../repositories/account/account_model.dart';
import '../../repositories/account/account_repository.dart';

final accountServiceProvider = Provider<AccountService>(
  (ref) => AccountService(ref.read(accountRepositoryProvider)),
);

class AccountService {
  AccountService(this._accountRepository) {
    _authStateController.add(AuthState.signOut);
  }

  final AccountRepository _accountRepository;

  final StreamController<AuthState?> _authStateController =
      StreamController<AuthState?>();

  AccountModel? _account;

  AccountModel? get account => _account;
  Stream<AuthState?> get authStateStream => _authStateController.stream;

  void dispose() {
    _authStateController.close();
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      _account = await _accountRepository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _authStateController.add(AuthState.signIn);
    } on Exception catch (e) {
      print(e);
      rethrow;
    }
  }
}

enum AuthState { signIn, signOut }

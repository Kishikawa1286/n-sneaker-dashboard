import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/generate_firebase_auth_error_message.dart';
import '../../../utils/view_model_change_notifier.dart';
import '../../services/account/account_service.dart';

final signInPageViewModelProvider =
    ChangeNotifierProvider.autoDispose<SignInPageViewModel>(
  (ref) => SignInPageViewModel(
    ref.read(accountServiceProvider),
  ),
);

class SignInPageViewModel extends ViewModelChangeNotifier {
  SignInPageViewModel(this._accountService);

  final AccountService _accountService;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  TextEditingController get emailController => _emailController;
  TextEditingController get passwordController => _passwordController;

  String _errorMessage = '';
  int _carouselIndex = 0;

  String get errorMessage => _errorMessage;
  int get carouselIndex => _carouselIndex;

  void setCarouselIndex(int index) {
    _carouselIndex = index;
    notifyListeners();
  }

  Future<void> signIn() async {
    try {
      await _accountService.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } on FirebaseAuthException catch (e) {
      _errorMessage = generateFirebaseAuthErrorMessage(e);
      notifyListeners();
    } on Exception catch (e) {
      print(e);
    }
  }
}

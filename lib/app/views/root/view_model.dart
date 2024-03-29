import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../services/account/account_service.dart';

final rootViewModelProvider = ChangeNotifierProvider(
  (ref) => RootViewModel(ref.watch(accountServiceProvider)),
);

class RootViewModel extends ViewModelChangeNotifier {
  RootViewModel(this._accountService);

  final AccountService _accountService;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 0;

  Stream<AuthState?> get authStateStream => _accountService.authStateStream;
  int get selectedIndex => _selectedIndex;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void select(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

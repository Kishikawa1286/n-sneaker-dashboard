import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/common_widgets/loading_page.dart';
import '../../services/account/account_service.dart';
import '../sign_in_page/sign_in_page.dart';
import 'view_model.dart';

class Root extends HookConsumerWidget {
  const Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(rootViewModelProvider);
    return StreamBuilder<AuthState?>(
      stream: viewModel.authStateStream,
      builder: (context, snapshot) {
        final authState = snapshot.data;
        if (authState == null || authState == AuthState.notChecked) {
          return const LoadingPage();
        }
        if (authState == AuthState.signOut) {
          return const SignInPage();
        }
        return const LoadingPage();
      },
    );
  }
}

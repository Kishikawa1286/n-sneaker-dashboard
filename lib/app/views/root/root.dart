import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/common_widgets/loading_page.dart';
import '../../services/account/account_service.dart';
import '../sign_in_page/sign_in_page.dart';
import 'components/drawer_list_tile.dart';
import 'view_model.dart';

const _titles = ['add product', 'add glb file'];

class Root extends HookConsumerWidget {
  const Root();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(rootViewModelProvider);
    return StreamBuilder<AuthState?>(
      stream: viewModel.authStateStream,
      builder: (context, snapshot) {
        final authState = snapshot.data;
        if (authState == null || authState == AuthState.signOut) {
          return const SignInPage();
        }
        return Scaffold(
          drawer: Drawer(
            child: ListView(
              children: _titles
                  .asMap()
                  .map(
                    (index, title) => MapEntry(
                      index,
                      RootDrawerListTile(
                        index: index,
                        text: title,
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ),
          body: Builder(
            builder: (context) {
              final selectedIndex = viewModel.selectedIndex;
              if (selectedIndex == 0) {}
              if (selectedIndex == 1) {}
              return const LoadingPage();
            },
          ),
        );
      },
    );
  }
}

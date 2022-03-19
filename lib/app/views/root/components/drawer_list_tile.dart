import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../view_model.dart';

class RootDrawerListTile extends HookConsumerWidget {
  const RootDrawerListTile({
    required this.text,
    required this.index,
  });

  final String text;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(rootViewModelProvider);
    return ListTile(
      title: Text(text),
      onTap: () {
        viewModel.select(index);
      },
    );
  }
}

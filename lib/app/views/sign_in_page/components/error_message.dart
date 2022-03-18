import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../utils/common_style.dart';
import '../view_model.dart';

class SignInPageErrorMessage extends HookConsumerWidget {
  const SignInPageErrorMessage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(signInPageViewModelProvider);
    final errorMessage = viewModel.errorMessage;
    if (errorMessage.isEmpty) {
      return const SizedBox();
    }
    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(
        style: const TextStyle(
          color: CommonStyle.errorColor,
          fontSize: 12,
        ),
        text: errorMessage,
      ),
    );
  }
}

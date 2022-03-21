import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

import '../../../utils/common_style.dart';
import 'components/error_message.dart';
import 'components/heading.dart';
import 'components/text_form_field.dart';
import 'view_model.dart';

class SignInPage extends HookConsumerWidget {
  const SignInPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(signInPageViewModelProvider);
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: FocusScope.of(context).unfocus,
        child: Center(
          child: Container(
            height: 300,
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const SignInPageHeading(text: 'Sign in (admin only)'),
                    SignInPageTextFormField(
                      hintText: 'email',
                      controller: viewModel.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SignInPageTextFormField(
                      hintText: 'password',
                      controller: viewModel.passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                    ),
                    const SignInPageErrorMessage(),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                      child: SocialLoginButton(
                        height: 50,
                        text: 'sign in',
                        borderRadius: 10,
                        backgroundColor: CommonStyle.black,
                        buttonType: SocialLoginButtonType.generalLogin,
                        onPressed: viewModel.signIn,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/common_widgets/edit_page_text_form_field.dart';
import '../../../utils/common_widgets/overlay_loading.dart';
import 'view_model.dart';

class CollectionProductManagePage extends HookConsumerWidget {
  const CollectionProductManagePage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(collectionProductManagePageViewModelProvider);
    return OverlayLoading(
      visible: viewModel.processing,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 40),
          child: Column(
            children: [
              const Text(
                'Grant all product to the account currently logged in',
              ),
              ElevatedButton(
                onPressed: viewModel.addAllCollectionProductForCurrentAccount,
                child: const Text('Start'),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 80),
                child: Text(
                  'Grant a product to an account (both are specified by id)',
                ),
              ),
              EditPageTextFormField(
                controller: viewModel.accountIdController,
                hintText: 'accountId',
              ),
              EditPageTextFormField(
                controller: viewModel.productIdController,
                hintText: 'productId',
              ),
              ElevatedButton(
                onPressed: viewModel.addCollectionProduct,
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

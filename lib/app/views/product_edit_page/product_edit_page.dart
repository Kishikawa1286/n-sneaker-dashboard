import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'components/text_form_field.dart';
import 'view_model.dart';

void pushProductEditPage(BuildContext context, {required String productId}) =>
    Navigator.of(context).pushNamed('edit_product/$productId');

class ProductEditPage extends HookConsumerWidget {
  const ProductEditPage({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(productEditPageViewModelProvider(productId));
    return Scaffold(
      appBar: AppBar(
        title: Text(productId.isEmpty ? 'Add Product' : 'Edit Product'),
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: FocusScope.of(context).unfocus,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
          child: ListView(
            children: [
              ProductEditPageTextFormField(
                controller: viewModel.titleController,
                hintText: 'title',
              ),
              ProductEditPageTextFormField(
                controller: viewModel.vendorController,
                hintText: 'vendor',
              ),
              ProductEditPageTextFormField(
                controller: viewModel.seriesController,
                hintText: 'series',
              ),
              ProductEditPageTextFormField(
                controller: viewModel.descriptionController,
                hintText: 'description',
                multiline: true,
              ),
              ProductEditPageTextFormField(
                controller: viewModel.collectionProductStatementController,
                hintText: 'collectionProductStatement',
                multiline: true,
              ),
              ProductEditPageTextFormField(
                controller: viewModel.arStatementController,
                hintText: 'arStatement',
                multiline: true,
              ),
              ProductEditPageTextFormField(
                controller: viewModel.otherStatementController,
                hintText: 'otherStatement',
                multiline: true,
              ),
              ProductEditPageTextFormField(
                controller: viewModel.titleJpController,
                hintText: 'titleJp',
              ),
              ProductEditPageTextFormField(
                controller: viewModel.vendorJpController,
                hintText: 'vendorJp',
              ),
              ProductEditPageTextFormField(
                controller: viewModel.seriesJpController,
                hintText: 'seriesJp',
              ),
              ProductEditPageTextFormField(
                controller: viewModel.descriptionJpController,
                hintText: 'descriptionJp',
                multiline: true,
              ),
              ProductEditPageTextFormField(
                controller: viewModel.collectionProductStatementJpController,
                hintText: 'collectionProductStatementJp',
                multiline: true,
              ),
              ProductEditPageTextFormField(
                controller: viewModel.arStatementJpController,
                hintText: 'arStatementJp',
                multiline: true,
              ),
              ProductEditPageTextFormField(
                controller: viewModel.otherStatementJpController,
                hintText: 'otherStatementJp',
                multiline: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

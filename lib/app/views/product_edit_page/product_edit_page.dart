import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'components/image_picker.dart';
import 'components/multiple_images_picker.dart';
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
      body: SingleChildScrollView(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: FocusScope.of(context).unfocus,
          child: Container(
            padding: const EdgeInsets.only(
              top: 25,
              right: 25,
              bottom: 100,
              left: 25,
            ),
            child: Column(
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
                  keyboardType: TextInputType.multiline,
                ),
                ProductEditPageTextFormField(
                  controller: viewModel.collectionProductStatementController,
                  hintText: 'collectionProductStatement',
                  keyboardType: TextInputType.multiline,
                ),
                ProductEditPageTextFormField(
                  controller: viewModel.arStatementController,
                  hintText: 'arStatement',
                  keyboardType: TextInputType.multiline,
                ),
                ProductEditPageTextFormField(
                  controller: viewModel.otherStatementController,
                  hintText: 'otherStatement',
                  keyboardType: TextInputType.multiline,
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
                  keyboardType: TextInputType.multiline,
                ),
                ProductEditPageTextFormField(
                  controller: viewModel.collectionProductStatementJpController,
                  hintText: 'collectionProductStatementJp',
                  keyboardType: TextInputType.multiline,
                ),
                ProductEditPageTextFormField(
                  controller: viewModel.arStatementJpController,
                  hintText: 'arStatementJp',
                  keyboardType: TextInputType.multiline,
                ),
                ProductEditPageTextFormField(
                  controller: viewModel.otherStatementJpController,
                  hintText: 'otherStatementJp',
                  keyboardType: TextInputType.multiline,
                ),
                ProductEditPageTextFormField(
                  controller: viewModel.priceJpyController,
                  hintText: 'priceJpy',
                  keyboardType: TextInputType.number,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Text('Market Page Images'),
                ),
                MultipleImagesPicker(
                  images: viewModel.marketImages,
                  add: viewModel.addMarketImages,
                  delete: viewModel.deleteMarketImage,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Text('Market List Page Image'),
                ),
                ProductEditPageImagePicker(
                  image: viewModel.marketTileImage,
                  onTap: viewModel.setMarketTileImage,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Text('Collection Page Image'),
                ),
                ProductEditPageImagePicker(
                  image: viewModel.transparentBackgroundImage,
                  onTap: viewModel.setTransparentBackgroundImage,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: ElevatedButton(
                    onPressed: () async {
                      await viewModel.submit();
                      Navigator.of(context).pop();
                    },
                    child: const Text('submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

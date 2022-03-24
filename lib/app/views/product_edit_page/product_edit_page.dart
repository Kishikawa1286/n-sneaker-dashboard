import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/common_widgets/edit_page_image_picker.dart';
import '../../../utils/common_widgets/edit_page_text_form_field.dart';
import 'components/multiple_images_picker.dart';
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
                EditPageTextFormField(
                  controller: viewModel.titleController,
                  hintText: 'title',
                ),
                EditPageTextFormField(
                  controller: viewModel.vendorController,
                  hintText: 'vendor',
                ),
                EditPageTextFormField(
                  controller: viewModel.seriesController,
                  hintText: 'series',
                ),
                EditPageTextFormField(
                  controller: viewModel.descriptionController,
                  hintText: 'description',
                  keyboardType: TextInputType.multiline,
                ),
                EditPageTextFormField(
                  controller: viewModel.collectionProductStatementController,
                  hintText: 'collectionProductStatement',
                  keyboardType: TextInputType.multiline,
                ),
                EditPageTextFormField(
                  controller: viewModel.arStatementController,
                  hintText: 'arStatement',
                  keyboardType: TextInputType.multiline,
                ),
                EditPageTextFormField(
                  controller: viewModel.otherStatementController,
                  hintText: 'otherStatement',
                  keyboardType: TextInputType.multiline,
                ),
                EditPageTextFormField(
                  controller: viewModel.titleJpController,
                  hintText: 'titleJp',
                ),
                EditPageTextFormField(
                  controller: viewModel.vendorJpController,
                  hintText: 'vendorJp',
                ),
                EditPageTextFormField(
                  controller: viewModel.seriesJpController,
                  hintText: 'seriesJp',
                ),
                EditPageTextFormField(
                  controller: viewModel.descriptionJpController,
                  hintText: 'descriptionJp',
                  keyboardType: TextInputType.multiline,
                ),
                EditPageTextFormField(
                  controller: viewModel.collectionProductStatementJpController,
                  hintText: 'collectionProductStatementJp',
                  keyboardType: TextInputType.multiline,
                ),
                EditPageTextFormField(
                  controller: viewModel.arStatementJpController,
                  hintText: 'arStatementJp',
                  keyboardType: TextInputType.multiline,
                ),
                EditPageTextFormField(
                  controller: viewModel.otherStatementJpController,
                  hintText: 'otherStatementJp',
                  keyboardType: TextInputType.multiline,
                ),
                EditPageTextFormField(
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
                EditPageImagePicker(
                  image: viewModel.marketTileImage,
                  onTap: viewModel.setMarketTileImage,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Text('Collection Page Image'),
                ),
                EditPageImagePicker(
                  image: viewModel.transparentBackgroundImage,
                  onTap: viewModel.setTransparentBackgroundImage,
                ),
                CheckboxListTile(
                  value: viewModel.visibleInMarket,
                  title: const Text(
                    'visibleInMarket',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: viewModel.setVisibleInMarket,
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

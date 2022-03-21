import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/common_style.dart';
import '../../../utils/common_widgets/edit_page_image_picker.dart';
import '../../../utils/common_widgets/edit_page_text_form_field.dart';
import 'view_model.dart';

void pushProductGlbFileEditPage(
  BuildContext context, {
  required String productId,
  required String productGlbFileId,
}) =>
    Navigator.of(context)
        .pushNamed('edit_product_glb_file/$productId/$productGlbFileId');

class ProductGlbFileEditPage extends HookConsumerWidget {
  const ProductGlbFileEditPage({
    required this.productId,
    required this.productGlbFileId,
  });

  final String productId;
  final String productGlbFileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(
      productGlbFileEditPageViewModelProvider('$productId,$productGlbFileId'),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          productGlbFileId.isEmpty
              ? 'Add Product Glb File'
              : 'Edit Product Glb File',
        ),
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
                  hintText: 'title',
                  controller: viewModel.titleController,
                ),
                EditPageTextFormField(
                  hintText: 'titleJp',
                  controller: viewModel.titleJpController,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 25),
                  child: Text('Product Glb File Image'),
                ),
                EditPageImagePicker(
                  image: viewModel.image,
                  onTap: viewModel.setImage,
                ),
                viewModel.editing
                    ? const SizedBox()
                    : const Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Text('Product Glb File'),
                      ),
                viewModel.editing
                    ? const SizedBox()
                    : ListTile(
                        title: Text(viewModel.fileName),
                        tileColor: CommonStyle.grey,
                        onTap: viewModel.setProductGlbFile,
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

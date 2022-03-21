import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../repositories/product_glb_file/product_glb_file.dart';
import '../product_glb_file_edit_page/product_glb_file_edit_page.dart';
import 'components/list_tile.dart';
import 'view_model.dart';

void pushProductGlbFileListPage(
  BuildContext context, {
  required String productId,
}) =>
    Navigator.of(context).pushNamed('product_glb_file_list/$productId');

class ProductGlbFileListPage extends HookConsumerWidget {
  const ProductGlbFileListPage({required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel =
        ref.watch(productGlbFileListPageViewModelProvider(productId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Glb File List'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: viewModel.refresh,
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  pushProductGlbFileEditPage(
                    context,
                    productId: productId,
                    productGlbFileId: '',
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: PagedListView(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 8,
              ),
              pagingController: viewModel.pagingController,
              builderDelegate: PagedChildBuilderDelegate<ProductGlbFileModel>(
                itemBuilder: (context, productGlbFile, index) =>
                    ProductGlbFileListPageListTile(
                  productGlbFile: productGlbFile,
                  delete: (id) {
                    viewModel.deleteProductGlbFile(id);
                    viewModel.refresh();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

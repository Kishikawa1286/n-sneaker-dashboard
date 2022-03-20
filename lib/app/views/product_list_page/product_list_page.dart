import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../repositories/product/product_model.dart';
import '../product_edit_page/product_edit_page.dart';
import 'components/list_tile.dart';
import 'view_model.dart';

class ProductListPage extends HookConsumerWidget {
  const ProductListPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(productListPageViewModelProvider);
    return Scaffold(
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
                  pushProductEditPage(context, productId: '');
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
              builderDelegate: PagedChildBuilderDelegate<ProductModel>(
                itemBuilder: (context, product, index) =>
                    ProductListPageListTile(product: product),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

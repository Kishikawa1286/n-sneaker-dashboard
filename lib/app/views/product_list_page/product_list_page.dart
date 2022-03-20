import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../repositories/product/product_model.dart';
import 'components/list_tile.dart';
import 'view_model.dart';

class ProductListPage extends HookConsumerWidget {
  const ProductListPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(productListPageViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: PagedListView(
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
    );
  }
}

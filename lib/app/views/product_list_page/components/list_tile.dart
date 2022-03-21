import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../repositories/product/product_model.dart';
import '../../product_edit_page/product_edit_page.dart';

class ProductListPageListTile extends StatelessWidget {
  const ProductListPageListTile({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Image.network(product.tileImageUrls.first),
        title: Text(product.titleJp),
        subtitle: Text(product.id),
        onTap: () {
          pushProductEditPage(context, productId: product.id);
        },
      );
}

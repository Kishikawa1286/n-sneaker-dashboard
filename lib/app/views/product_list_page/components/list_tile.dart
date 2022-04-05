import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../repositories/product/product_model.dart';
import '../../product_edit_page/product_edit_page.dart';
import '../../product_glb_file_list_page.dart/product_glb_file_list_page.dart';

class ProductListPageListTile extends StatelessWidget {
  const ProductListPageListTile({required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Image.network(product.tileImageUrls.first),
        title: SelectableText(product.titleJp),
        subtitle: SelectableText(product.id),
        onTap: () {},
        trailing: Container(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  pushProductEditPage(context, productId: product.id);
                },
                child: const Text('edit'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: ElevatedButton(
                  onPressed: () {
                    pushProductGlbFileListPage(context, productId: product.id);
                  },
                  child: const Text('manage glb files'),
                ),
              ),
            ],
          ),
        ),
      );
}

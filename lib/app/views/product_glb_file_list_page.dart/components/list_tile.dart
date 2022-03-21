import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../repositories/product_glb_file/product_glb_file.dart';
import '../../product_glb_file_edit_page/product_glb_file_edit_page.dart';

class ProductGlbFileListPageListTile extends StatelessWidget {
  const ProductGlbFileListPageListTile({
    required this.productGlbFile,
    required this.delete,
  });

  final ProductGlbFileModel productGlbFile;
  final void Function(String id) delete;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Image.network(productGlbFile.imageUrls.first),
        title: Text(productGlbFile.titleJp),
        subtitle: Text(productGlbFile.id),
        onTap: () {},
        trailing: Container(
          constraints: const BoxConstraints(maxWidth: 250),
          child: Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  pushProductGlbFileEditPage(
                    context,
                    productId: productGlbFile.productId,
                    productGlbFileId: productGlbFile.id,
                  );
                },
                child: const Text('edit'),
              ),
              ElevatedButton(
                onPressed: () {
                  delete(productGlbFile.id);
                },
                child: const Text('delete'),
              ),
            ],
          ),
        ),
      );
}

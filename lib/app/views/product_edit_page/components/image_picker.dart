import 'package:flutter/material.dart';

import '../../../../utils/common_style.dart';

class ProductEditPageImagePicker extends StatelessWidget {
  const ProductEditPageImagePicker({required this.image, required this.onTap});

  final ImageProvider? image;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 120,
          height: 120,
          child: Card(
            elevation: 5,
            child: Builder(
              builder: (context) {
                final im = image;
                if (im == null) {
                  return Container(color: CommonStyle.grey);
                }
                return Image(image: im, fit: BoxFit.contain);
              },
            ),
          ),
        ),
      );
}

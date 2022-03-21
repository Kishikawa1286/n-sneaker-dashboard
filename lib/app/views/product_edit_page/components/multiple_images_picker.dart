import 'package:flutter/material.dart';

class MultipleImagesPicker extends StatelessWidget {
  const MultipleImagesPicker({
    required this.images,
    required this.add,
    required this.delete,
  });

  final List<ImageProvider> images;
  final void Function() add;
  final void Function(int index) delete;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ...images
              .asMap()
              .map(
                (index, image) => MapEntry(
                  index,
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      delete(index);
                    },
                    child: SizedBox(
                      width: 120,
                      height: 120,
                      child: Card(
                        elevation: 5,
                        child: Image(image: images[index], fit: BoxFit.contain),
                      ),
                    ),
                  ),
                ),
              )
              .values
              .toList(),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: add,
            child: const SizedBox(
              width: 120,
              height: 120,
              child: Card(
                elevation: 5,
                child: Center(child: Icon(Icons.add)),
              ),
            ),
          )
        ],
      );
}

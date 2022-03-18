import 'package:flutter/material.dart';

import '../common_style.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    required this.title,
    this.showBackButton = false,
  });

  final String title;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 80,
            alignment: Alignment.bottomCenter,
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: CommonStyle.grey)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                title,
                style: const TextStyle(
                  color: CommonStyle.black,
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          showBackButton
              ? Positioned(
                  top: 32,
                  left: 0,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: Navigator.of(context).pop,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                      child: Icon(Icons.arrow_back_ios_new),
                    ),
                  ),
                )
              : const SizedBox(),
        ],
      );
}

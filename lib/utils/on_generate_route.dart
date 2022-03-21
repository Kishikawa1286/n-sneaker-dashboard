import 'package:flutter/material.dart';

import '../app/views/product_edit_page/product_edit_page.dart';
import '../app/views/product_glb_file_edit_page/product_glb_file_edit_page.dart';
import '../app/views/product_glb_file_list_page.dart/product_glb_file_list_page.dart';
import '../app/views/root/root.dart';
import 'common_widgets/loading_page.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) =>
    PageRouteBuilder<Widget>(
      settings: settings,
      pageBuilder: (_, __, ___) {
        final name = settings.name;
        if (name == null || name == 'root') {
          return const Root();
        }

        if (name.startsWith('product_glb_file_list')) {
          final productId = RegExp('(?<=product_glb_file_list/)(.*)')
              .firstMatch(name)
              ?.group(0);
          if (productId == null) {
            return const LoadingPage();
          }
          return ProductGlbFileListPage(productId: productId);
        }

        if (name.startsWith('edit_product_glb_file')) {
          final productId = RegExp('(?<=edit_product_glb_file/)(.*)(?=/)')
              .firstMatch(name)
              ?.group(0);
          if (productId == null) {
            return const LoadingPage();
          }
          final productGlbFileId =
              RegExp('(?<=edit_product_glb_file/$productId/)(.*)')
                  .firstMatch(name)
                  ?.group(0);
          if (productGlbFileId == null) {
            return ProductGlbFileEditPage(
              productId: productId,
              productGlbFileId: '',
            );
          }
          return ProductGlbFileEditPage(
            productId: productId,
            productGlbFileId: productGlbFileId,
          );
        }

        // edit_product_glb_file あり注意
        if (name.startsWith('edit_product')) {
          final productId =
              RegExp('(?<=edit_product/)(.*)').firstMatch(name)?.group(0);
          if (productId == null) {
            return const LoadingPage();
          }
          return ProductEditPage(productId: productId);
        }

        return const LoadingPage();
      },
    );

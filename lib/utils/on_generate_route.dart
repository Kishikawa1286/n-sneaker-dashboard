import 'package:flutter/material.dart';

import '../app/views/product_edit_page/product_edit_page.dart';
import '../app/views/root/root.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) =>
    PageRouteBuilder<Widget>(
      settings: settings,
      pageBuilder: (_, __, ___) {
        final name = settings.name;
        if (name == null || name == 'root') {
          return const Root();
        }

        if (name.startsWith('edit_product')) {
          final productId =
              RegExp('(?<=edit_product/)(.*)').firstMatch(name)?.group(0);
          if (productId == null) {
            return const Root();
          }
          return ProductEditPage(productId: productId);
        }

        return const Root();
      },
    );

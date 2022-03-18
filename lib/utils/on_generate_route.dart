import 'package:flutter/material.dart';

import '../app/views/root/root.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) =>
    PageRouteBuilder<Widget>(
      settings: settings,
      pageBuilder: (_, __, ___) {
        final name = settings.name;
        if (name == null || name == 'root') {
          return const Root();
        }

        return const Root();
      },
    );

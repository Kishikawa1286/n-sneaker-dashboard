// ignore_for_file: avoid_web_libraries_in_flutter
import 'dart:async';
import 'dart:html' as html;
import 'dart:js' as js;

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'utils/on_generate_route.dart';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      // https://stackoverflow.com/questions/65647090/access-dart-define-environment-variables-inside-index-html
      // ignore: do_not_use_environment
      js.context['FLAVOR'] = const String.fromEnvironment('FLAVOR');
      html.document.dispatchEvent(html.CustomEvent('dart_loaded'));
      runApp(
        ProviderScope(
          child: MaterialApp(
            title: 'n-sneaker',
            onGenerateRoute: onGenerateRoute,
            initialRoute: 'root',
            theme: ThemeData.light(),
          ),
        ),
      );
    },
    (error, stackTrace) async {
      print('runZonedGuarded: Caught error in my root zone.');
      print('error\n$error');
      print('stacktrace\n$stackTrace');
    },
  );
}

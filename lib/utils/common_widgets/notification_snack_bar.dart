import 'package:flutter/material.dart';

SnackBar notificationSnackBar({String content = ''}) => SnackBar(
      content: Text(content),
      duration: const Duration(seconds: 5),
    );

import 'dart:math';

String randomString([int length = 16]) {
  const charset =
      '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz';
  final random = Random.secure();
  final randomStr =
      List.generate(length - 1, (_) => charset[random.nextInt(charset.length)])
          .join();
  return '0$randomStr';
}

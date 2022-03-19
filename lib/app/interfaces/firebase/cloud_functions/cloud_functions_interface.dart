import 'package:cloud_functions/cloud_functions.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'cloud_functions_names.dart';

final cloudFunctionsInterfaceProvider =
    Provider<CloudFunctionsInterface>((ref) => CloudFunctionsInterface());

class CloudFunctionsInterface {
  CloudFunctionsInterface();

  final _firebaseFunctions =
      FirebaseFunctions.instanceFor(region: 'asia-northeast1');

  Future<dynamic> _call(
    String functionName, {
    HttpsCallableOptions? options,
    Map<String, dynamic>? parameters,
  }) =>
      _firebaseFunctions
          .httpsCallable(functionName, options: options)
          .call<dynamic>(parameters);

  Future<HttpsCallableResult<dynamic>> checkAdminAccount() =>
      _call(CloudFunctionsNames.checkAdminAccount)
          as Future<HttpsCallableResult<dynamic>>;
}

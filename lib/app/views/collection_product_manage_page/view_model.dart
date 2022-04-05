import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/collection_product/collection_product_repository.dart';
import '../../repositories/product/product_repository.dart';
import '../../services/account/account_service.dart';

final collectionProductManagePageViewModelProvider =
    AutoDisposeChangeNotifierProvider<CollectionProductManagePageViewModel>(
  (ref) => CollectionProductManagePageViewModel(
    ref.read(productRepositoryProvider),
    ref.read(collectionProductRepositoryProvider),
    ref.watch(accountServiceProvider),
  ),
);

class CollectionProductManagePageViewModel extends ViewModelChangeNotifier {
  CollectionProductManagePageViewModel(
    this._productRepository,
    this._collectionProductRepository,
    this._accountService,
  );

  final ProductRepository _productRepository;
  final CollectionProductRepository _collectionProductRepository;
  final AccountService _accountService;

  final _accountIdController = TextEditingController();
  final _productIdController = TextEditingController();

  TextEditingController get accountIdController => _accountIdController;
  TextEditingController get productIdController => _productIdController;

  bool _processing = false;
  String _errorMessage = '';

  bool get processing => _processing;
  String get errorMessage => _errorMessage;

  Future<void> addCollectionProduct() async {
    _processing = true;
    notifyListeners();
    try {
      final product =
          await _productRepository.fetchProductById(_productIdController.text);
      await _collectionProductRepository.addCollectionProduct(
        accountId: _accountIdController.text,
        product: product,
      );
    } on Exception catch (e) {
      print(e);
      _errorMessage = e.toString();
    }
    _processing = false;
    notifyListeners();
  }

  Future<void> addAllCollectionProductForCurrentAccount() async {
    final account = _accountService.account;
    if (account == null) {
      return;
    }
    _processing = true;
    notifyListeners();
    try {
      final allProducts = await _productRepository.fetchAll();
      await _collectionProductRepository.addCollectionProducts(
        accountId: account.id,
        products: allProducts,
      );
    } on Exception catch (e) {
      print(e);
    }
    _processing = false;
    notifyListeners();
  }
}

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/product/product_model.dart';
import '../../repositories/product/product_repository.dart';

final productListPageViewModelProvider = AutoDisposeChangeNotifierProvider(
  (ref) => ProductListPageViewModel(
    ref.watch(productRepositoryProvider),
  ),
);

class ProductListPageViewModel extends ViewModelChangeNotifier {
  ProductListPageViewModel(this._productRepository) {
    _pagingController.addPageRequestListener(_fetchProducts);
  }

  static const _limit = 16;

  final ProductRepository _productRepository;

  final PagingController<int, ProductModel> _pagingController =
      PagingController<int, ProductModel>(firstPageKey: 0);

  PagingController<int, ProductModel> get pagingController => _pagingController;

  void refresh() {
    _pagingController.refresh();
    notifyListeners();
  }

  Future<void> _fetchProducts(int pageKey) async {
    try {
      final startAfter = pagingController.itemList?.last;
      final fetchedProducts =
          await _productRepository.fetchProducts(startAfter: startAfter);
      if (fetchedProducts.length != _limit) {
        _pagingController.appendLastPage(fetchedProducts);
      } else {
        _pagingController.appendPage(fetchedProducts, pageKey + _limit);
      }
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      _pagingController.error = e;
    }
  }
}

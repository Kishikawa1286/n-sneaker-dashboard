import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/product_glb_file/product_glb_file.dart';
import '../../repositories/product_glb_file/product_glb_file_repository.dart';

final productGlbFileListPageViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<ProductGlbFileListPageViewModel,
        String>(
  (ref, productId) => ProductGlbFileListPageViewModel(
    productId,
    ref.read(productGlbFileRepositoryProvider),
  ),
);

class ProductGlbFileListPageViewModel extends ViewModelChangeNotifier {
  ProductGlbFileListPageViewModel(
    this._productId,
    this._productGlbFileRepository,
  ) {
    _pagingController.addPageRequestListener(_fetchProductGlbFiles);
  }

  static const _limit = 16;

  final String _productId;

  final ProductGlbFileRepository _productGlbFileRepository;

  final PagingController<int, ProductGlbFileModel> _pagingController =
      PagingController<int, ProductGlbFileModel>(firstPageKey: 0);

  PagingController<int, ProductGlbFileModel> get pagingController =>
      _pagingController;

  void refresh() {
    _pagingController.refresh();
    notifyListeners();
  }

  Future<void> _fetchProductGlbFiles(int pageKey) async {
    try {
      final startAfter = pagingController.itemList?.last;
      final fetched = await _productGlbFileRepository
          .fetchProductsGlbFiles(_productId, startAfter: startAfter);
      if (fetched.length != _limit) {
        _pagingController.appendLastPage(fetched);
      } else {
        _pagingController.appendPage(fetched, pageKey + _limit);
      }
      notifyListeners();
    } on Exception catch (e) {
      print(e);
      _pagingController.error = e;
    }
  }

  void deleteProductGlbFile(String productGlbFileId) {
    try {
      _productGlbFileRepository.deleteProductGlbFile(
        productId: _productId,
        productGlbFileId: productGlbFileId,
      );
    } on Exception catch (e) {
      print(e);
    }
  }
}

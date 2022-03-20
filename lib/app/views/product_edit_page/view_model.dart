import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/product/product_repository.dart';

final productEditPageViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<ProductEditPageViewModel, String>(
  (ref, id) => ProductEditPageViewModel(
    id,
    ref.read(productRepositoryProvider),
  ),
);

class ProductEditPageViewModel extends ViewModelChangeNotifier {
  ProductEditPageViewModel(this._productId, this._productRepository);

  final String _productId;
  final ProductRepository _productRepository;

  final titleController = TextEditingController();
  final vendorController = TextEditingController();
  final seriesController = TextEditingController();
  final descriptionController = TextEditingController();
  final collectionProductStatementController = TextEditingController();
  final arStatementController = TextEditingController();
  final otherStatementController = TextEditingController();

  final titleJpController = TextEditingController();
  final vendorJpController = TextEditingController();
  final seriesJpController = TextEditingController();
  final descriptionJpController = TextEditingController();
  final collectionProductStatementJpController = TextEditingController();
  final arStatementJpController = TextEditingController();
  final otherStatementJpController = TextEditingController();
}

import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/local_file/local_file_repository.dart';
import '../../repositories/product/product_repository.dart';

final productEditPageViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<ProductEditPageViewModel, String>(
  (ref, id) => ProductEditPageViewModel(
    id,
    ref.read(productRepositoryProvider),
    ref.read(localFileRepositoryProvider),
  ),
);

class ProductEditPageViewModel extends ViewModelChangeNotifier {
  ProductEditPageViewModel(
    this._productId,
    this._productRepository,
    this._localFileRepository,
  ) {
    _init();
  }

  final String _productId;
  final ProductRepository _productRepository;
  final LocalFileRepository _localFileRepository;

  final _titleController = TextEditingController();
  final _vendorController = TextEditingController();
  final _seriesController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _collectionProductStatementController = TextEditingController();
  final _arStatementController = TextEditingController();
  final _otherStatementController = TextEditingController();

  final _titleJpController = TextEditingController();
  final _vendorJpController = TextEditingController();
  final _seriesJpController = TextEditingController();
  final _descriptionJpController = TextEditingController();
  final _collectionProductStatementJpController = TextEditingController();
  final _arStatementJpController = TextEditingController();
  final _otherStatementJpController = TextEditingController();
  final _priceJpyController = TextEditingController();

  TextEditingController get titleController => _titleController;
  TextEditingController get vendorController => _vendorController;
  TextEditingController get seriesController => _seriesController;
  TextEditingController get descriptionController => _descriptionController;
  TextEditingController get collectionProductStatementController =>
      _collectionProductStatementController;
  TextEditingController get arStatementController => _arStatementController;
  TextEditingController get otherStatementController =>
      _otherStatementController;
  TextEditingController get titleJpController => _titleJpController;
  TextEditingController get vendorJpController => _vendorJpController;
  TextEditingController get seriesJpController => _seriesJpController;
  TextEditingController get descriptionJpController => _descriptionJpController;
  TextEditingController get collectionProductStatementJpController =>
      _collectionProductStatementJpController;
  TextEditingController get arStatementJpController => _arStatementJpController;
  TextEditingController get otherStatementJpController =>
      _otherStatementJpController;
  TextEditingController get priceJpyController => _priceJpyController;

  List<ImageProvider> _marketImages = [];
  ImageProvider? _marketTileImage;
  ImageProvider? _transparentBackgroundImage;

  List<ImageProvider> get marketImages => _marketImages;
  ImageProvider? get marketTileImage => _marketTileImage;
  ImageProvider? get transparentBackgroundImage => _transparentBackgroundImage;

  Future<void> _init() async {
    if (_productId.isEmpty) {
      return;
    }
    final product = await _productRepository.fetchProductById(_productId);
    _titleController.text = product.title;
    _vendorController.text = product.vendor;
    _seriesController.text = product.series;
    _descriptionController.text = product.description;
    _collectionProductStatementController.text =
        product.collectionProductStatement;
    _arStatementController.text = product.arStatement;
    _otherStatementController.text = product.otherStatement;

    _titleJpController.text = product.titleJp;
    _vendorJpController.text = product.vendorJp;
    _seriesJpController.text = product.seriesJp;
    _descriptionJpController.text = product.descriptionJp;
    _collectionProductStatementJpController.text =
        product.collectionProductStatementJp;
    _arStatementJpController.text = product.arStatementJp;
    _otherStatementJpController.text = product.otherStatementJp;
    _priceJpyController.text = product.priceJpy.toString();
    _marketImages = product.imageUrls.map(NetworkImage.new).toList();
    _marketTileImage = NetworkImage(product.tileImageUrls.first);
    _transparentBackgroundImage =
        NetworkImage(product.transparentBackgroundImageUrls.first);
    notifyListeners();
  }

  Future<void> addMarketImages() async {
    final images = await _localFileRepository.pickImageFiles();
    if (images.isEmpty) {
      return;
    }
    _marketImages = [..._marketImages, ...images];
    notifyListeners();
  }

  void deleteMarketImage(int index) {
    _marketImages.removeAt(index);
    notifyListeners();
  }

  Future<void> setMarketTileImage() async {
    final image = await _localFileRepository.pickImageFile();
    if (image == null) {
      return;
    }
    _marketTileImage = image;
    notifyListeners();
  }

  Future<void> setTransparentBackgroundImage() async {
    final image = await _localFileRepository.pickImageFile();
    if (image == null) {
      return;
    }
    _transparentBackgroundImage = image;
    notifyListeners();
  }

  Future<void> submit() async {
    try {
      final tile = _marketTileImage;
      final transparentBg = _transparentBackgroundImage;
      if (_marketImages.isEmpty || tile == null || transparentBg == null) {
        return;
      }
      if (_productId.isEmpty) {
        await _productRepository.addProduct(
          title: _titleController.text,
          vendor: _vendorController.text,
          series: _seriesController.text,
          tags: [],
          description: _descriptionController.text,
          collectionProductStatement:
              _collectionProductStatementController.text,
          arStatement: _arStatementController.text,
          otherStatement: _otherStatementController.text,
          titleJp: _titleJpController.text,
          vendorJp: _vendorJpController.text,
          seriesJp: _seriesJpController.text,
          tagsJp: [],
          descriptionJp: _descriptionJpController.text,
          collectionProductStatementJp:
              _collectionProductStatementJpController.text,
          arStatementJp: _arStatementJpController.text,
          otherStatementJp: _otherStatementJpController.text,
          images: _marketImages,
          tileImage: tile,
          transparentBackgroundImage: transparentBg,
          priceJpy: int.tryParse(priceJpyController.text) ?? 0,
        );
      } else {
        await _productRepository.updateProduct(
          id: _productId,
          title: _titleController.text,
          vendor: _vendorController.text,
          series: _seriesController.text,
          tags: [],
          description: _descriptionController.text,
          collectionProductStatement:
              _collectionProductStatementController.text,
          arStatement: _arStatementController.text,
          otherStatement: _otherStatementController.text,
          titleJp: _titleJpController.text,
          vendorJp: _vendorJpController.text,
          seriesJp: _seriesJpController.text,
          tagsJp: [],
          descriptionJp: _descriptionJpController.text,
          collectionProductStatementJp:
              _collectionProductStatementJpController.text,
          arStatementJp: _arStatementJpController.text,
          otherStatementJp: _otherStatementJpController.text,
          images: _marketImages,
          tileImage: tile,
          transparentBackgroundImage: transparentBg,
          priceJpy: int.tryParse(priceJpyController.text) ?? 0,
        );
      }
    } on Exception catch (e) {
      print(e);
    }
  }
}

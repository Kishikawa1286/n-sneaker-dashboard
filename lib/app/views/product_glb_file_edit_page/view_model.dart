import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../utils/view_model_change_notifier.dart';
import '../../repositories/local_file/local_file_repository.dart';
import '../../repositories/product/product_repository.dart';
import '../../repositories/product_glb_file/product_glb_file_repository.dart';

final productGlbFileEditPageViewModelProvider =
    AutoDisposeChangeNotifierProviderFamily<ProductGlbFileEditPageViewModel,
        String>((ref, ids) {
  final idsAsList = ids.split(',');
  final productId = idsAsList[0];
  final productGlbFileId = idsAsList.length == 2 ? idsAsList[1] : '';
  return ProductGlbFileEditPageViewModel(
    productId,
    productGlbFileId,
    ref.read(productRepositoryProvider),
    ref.read(productGlbFileRepositoryProvider),
    ref.read(localFileRepositoryProvider),
  );
});

class ProductGlbFileEditPageViewModel extends ViewModelChangeNotifier {
  ProductGlbFileEditPageViewModel(
    this._productId,
    this._productGlbFileId,
    this._productRepository,
    this._productGlbFileRepository,
    this._localFileRepository,
  ) {
    _init();
  }

  final String _productId;
  final String _productGlbFileId;

  final ProductRepository _productRepository;
  final ProductGlbFileRepository _productGlbFileRepository;
  final LocalFileRepository _localFileRepository;

  final _titleController = TextEditingController();
  final _titleJpController = TextEditingController();

  TextEditingController get titleController => _titleController;
  TextEditingController get titleJpController => _titleJpController;

  ImageProvider? _image;
  PlatformFile? _productGlbFile;
  bool _availableForViewer = true;
  bool _availableForAr = true;

  ImageProvider? get image => _image;
  String get fileName => _productGlbFile?.name ?? '';
  bool get availableForViewer => _availableForViewer;
  bool get availableForAr => _availableForAr;
  bool get editing => _productGlbFileId.isNotEmpty;
  bool _uploading = false;

  Future<void> _init() async {
    if (_productGlbFileId.isEmpty) {
      return;
    }
    final productGlbFile =
        await _productGlbFileRepository.fetchProductsGlbFileById(
      productId: _productId,
      productGlbFileId: _productGlbFileId,
    );
    _titleController.text = productGlbFile.title;
    _titleJpController.text = productGlbFile.titleJp;
    _image = NetworkImage(productGlbFile.imageUrls.first);
    notifyListeners();
  }

  Future<void> setImage() async {
    final im = await _localFileRepository.pickJpegFile();
    if (im == null) {
      return;
    }
    _image = im;
    notifyListeners();
  }

  Future<void> setProductGlbFile() async {
    final file = await _localFileRepository.pickGlbFile();
    if (file == null) {
      return;
    }
    _productGlbFile = file;
    notifyListeners();
  }

  // ignore: avoid_positional_boolean_parameters
  void setAvailableForViewer(bool? value) {
    _availableForViewer = value ?? false;
    notifyListeners();
  }

  // ignore: avoid_positional_boolean_parameters
  void setAvailableForAr(bool? value) {
    _availableForAr = value ?? false;
    notifyListeners();
  }

  Future<void> submit() async {
    if (_uploading) {
      return;
    }
    final im = _image;
    if (im == null) {
      return;
    }
    _uploading = true;
    try {
      final product = await _productRepository.fetchProductById(_productId);
      if (_productGlbFileId.isEmpty) {
        final file = _productGlbFile;
        if (file == null) {
          _uploading = false;
          return;
        }
        await _productGlbFileRepository.addProductGlbFile(
          availableForViewer: availableForViewer,
          availableForAr: availableForAr,
          product: product,
          title: titleController.text,
          titleJp: titleJpController.text,
          images: [im],
          productGlbFile: file,
        );
      } else {
        await _productGlbFileRepository.updateProductGlbFile(
          availableForViewer: availableForViewer,
          availableForAr: availableForAr,
          product: product,
          productGlbFileId: _productGlbFileId,
          title: titleController.text,
          titleJp: titleJpController.text,
          images: [im],
        );
      }
    } on Exception catch (e) {
      print(e);
    }
    _uploading = false;
  }
}

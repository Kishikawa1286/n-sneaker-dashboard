String productImagePath(String productId, String fileName) =>
    'product_images/$productId/$fileName';

String productGlbFileImageDirectoryPath(
  String productId,
  String productGlbFileId,
) =>
    'product_glb_file_images/$productId/$productGlbFileId';

String productGlbFileImagePath(
  String productId,
  String productGlbFileId,
  String fileName,
) =>
    '${productGlbFileImageDirectoryPath(productId, productGlbFileId)}/$fileName';

String productGlbFileImagesFolderPath(
  String productId,
  String productGlbFileId,
) =>
    'product_images/$productId/$productGlbFileId';

String productGlbFilePath(
  String productId,
  String productGlbFileId,
) =>
    'product_glb_files/$productId/$productGlbFileId.glb';

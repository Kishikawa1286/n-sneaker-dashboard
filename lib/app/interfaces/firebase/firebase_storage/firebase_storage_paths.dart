String productImagePath(String productId, String fileName) =>
    'product_images/$productId/$fileName';

String productGlbFileImagePath(
  String productId,
  String productGlbFileId,
  String fileName,
) =>
    'product_images/$productId/$productGlbFileId/$fileName';

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

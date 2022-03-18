// ignore_for_file: do_not_use_environment

/// Firestoreの'accounts'コレクションのバージョン
const String firestoreAccountsCollectionVersion = 'v1';

/// Firestoreの'products'コレクションのバージョン
const String firestoreProductsCollectionVersion = 'v1';

/// Firestoreの'products/{doc}/product_glb_files'コレクションのバージョン
const String firestoreProductGlbFilesVersion = 'v1';

/// Firestoreの'collection_products'コレクションのバージョン
const String firestoreCollectionProductsVersion = 'v1';

/// AlgoliaのApplication ID
const String algoliaApplicationId = 'EHWBNFTR66';

/// AlgoliaのAPIキー
const String algoliaApikey = '1b42b72bcb9325502450036567af273d';

/// String.fromEnvironment('env') の値
const String flavor = String.fromEnvironment('FLAVOR');

const isEnabledAnalytics = !(String.fromEnvironment('ANALYTICS') == 'false');

const privacyPolicy = 'https://nanal.tokyo/policies/privacy-policy';

const legalNotice = 'https://nanal.tokyo/policies/legal-notice';

const termsOfService = 'https://nanal.tokyo/policies/terms-of-service';

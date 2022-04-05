// ignore_for_file: do_not_use_environment

/* Firestore */

/// Firestoreの'accounts'コレクションのバージョン
const String firestoreAccountsCollectionVersion = 'v1';

/// Firestoreの'products'コレクションのバージョン
const String firestoreProductsCollectionVersion = 'v1';

/// Firestoreの'products/{doc}/product_glb_files'コレクションのバージョン
const String firestoreProductGlbFilesVersion = 'v1';

/// Firestoreの'collection_products'コレクションのバージョン
const String firestoreCollectionProductsVersion = 'v1';

/// Firestoreの'market_page_tabs'コレクションのバージョン
const String firestoreMarketPageTabsVersion = 'v1';

/// Firestoreの'launch_configs'コレクションのバージョン
const String firestoreLaunchConfigsVersion = 'v1';

/* Algolia */

/// AlgoliaのApplication ID
const String algoliaApplicationId = 'EHWBNFTR66';

/// AlgoliaのAPIキー
const String algoliaApikey = '1b42b72bcb9325502450036567af273d';

/* dart-define */

/// String.fromEnvironment('env') の値
const String flavor = String.fromEnvironment('FLAVOR');

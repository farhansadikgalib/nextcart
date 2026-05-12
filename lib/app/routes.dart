class Routes {
  Routes._();

  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';

  // Shell tabs
  static const String home = '/';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String profile = '/profile';

  // Sub-routes
  static const String products = '/products';
  static const String productDetail = '/product/:id';
  static const String search = '/search';
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String orderDetail = '/orders/:id';
  static const String address = '/address';
  static const String privacy = '/privacy';
  static const String help = '/help';
  static const String terms = '/terms';

  static String productDetailPath(String id) => '/product/$id';
  static String productsByCategoryPath(String categoryId) =>
      '/products?category=$categoryId';
  static String orderDetailPath(String id) => '/orders/$id';
}

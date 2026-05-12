import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/app/main_shell.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/core/providers/firebase_providers.dart';
import 'package:nextcart/features/auth/presentation/views/auth_view.dart';
import 'package:nextcart/features/cart/presentation/views/cart_view.dart';
import 'package:nextcart/features/categories/presentation/views/categorie_view.dart';
import 'package:nextcart/features/checkout/presentation/views/checkout_view.dart';
import 'package:nextcart/features/home/presentation/views/home_view.dart';
import 'package:nextcart/features/onboarding/presentation/views/onboarding_view.dart';
import 'package:nextcart/features/orders/presentation/views/order_detail_view.dart';
import 'package:nextcart/features/orders/presentation/views/order_view.dart';
import 'package:nextcart/features/product_detail/presentation/views/product_detail_view.dart';
import 'package:nextcart/features/products/presentation/views/product_view.dart';
import 'package:nextcart/features/profile/presentation/views/address_view.dart';
import 'package:nextcart/features/profile/presentation/views/info_view.dart';
import 'package:nextcart/features/profile/presentation/views/profile_view.dart';
import 'package:nextcart/features/search/presentation/views/search_view.dart';
import 'package:nextcart/features/splash/presentation/views/splash_view.dart';
import 'package:nextcart/features/notifications/presentation/views/notification_view.dart';
import 'package:nextcart/features/wishlist/presentation/views/wishlist_view.dart';

CustomTransitionPage<T> _slidePage<T>({required Widget child, LocalKey? key}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondary, child) {
      return CupertinoPageTransition(
        primaryRouteAnimation: animation,
        secondaryRouteAnimation: secondary,
        linearTransition: false,
        child: child,
      );
    },
  );
}

class _RefreshListenable extends ChangeNotifier {
  _RefreshListenable(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  final refresh = _RefreshListenable(auth.authStateChanges());
  ref.onDispose(refresh.dispose);

  return GoRouter(
    initialLocation: Routes.splash,
    debugLogDiagnostics: false,
    refreshListenable: refresh,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isLoggedIn = auth.currentUser != null;
      final isAuthRoute = loc == Routes.auth || loc == Routes.onboarding;
      final isSplash = loc == Routes.splash;

      if (isSplash) return null;
      if (!isLoggedIn && !isAuthRoute) return Routes.auth;
      if (isLoggedIn && isAuthRoute) return Routes.home;
      return null;
    },
    routes: [
      GoRoute(
        path: Routes.splash,
        pageBuilder: (_, _) => _slidePage(child: const SplashView()),
      ),
      GoRoute(
        path: Routes.onboarding,
        pageBuilder: (_, _) => _slidePage(child: const OnboardingView()),
      ),
      GoRoute(
        path: Routes.auth,
        pageBuilder: (_, _) => _slidePage(child: const AuthView()),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.home,
                pageBuilder: (_, _) =>
                    const NoTransitionPage(child: HomeView()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.categories,
                pageBuilder: (_, _) =>
                    const NoTransitionPage(child: CategorieView()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.cart,
                pageBuilder: (_, _) =>
                    const NoTransitionPage(child: CartView()),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: Routes.profile,
                pageBuilder: (_, _) =>
                    const NoTransitionPage(child: ProfileView()),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.notifications,
        pageBuilder: (_, _) =>
            _slidePage(child: const NotificationView()),
      ),
      GoRoute(
        path: Routes.wishlist,
        pageBuilder: (_, _) => _slidePage(child: const WishlistView()),
      ),
      GoRoute(
        path: Routes.products,
        pageBuilder: (_, state) => _slidePage(
          child: ProductView(
            categoryId: state.uri.queryParameters['category'],
          ),
        ),
      ),
      GoRoute(
        path: Routes.productDetail,
        pageBuilder: (_, state) => _slidePage(
          child: ProductDetailView(productId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: Routes.search,
        pageBuilder: (_, _) => _slidePage(child: const SearchView()),
      ),
      GoRoute(
        path: Routes.checkout,
        pageBuilder: (_, _) => _slidePage(child: const CheckoutView()),
      ),
      GoRoute(
        path: Routes.orders,
        pageBuilder: (_, _) => _slidePage(child: const OrderView()),
      ),
      GoRoute(
        path: Routes.orderDetail,
        pageBuilder: (_, state) => _slidePage(
          child: OrderDetailView(orderId: state.pathParameters['id']!),
        ),
      ),
      GoRoute(
        path: Routes.address,
        pageBuilder: (_, _) => _slidePage(child: const AddressView()),
      ),
      GoRoute(
        path: Routes.privacy,
        pageBuilder: (_, _) =>
            _slidePage(child: const InfoView(kind: InfoKind.privacy)),
      ),
      GoRoute(
        path: Routes.help,
        pageBuilder: (_, _) =>
            _slidePage(child: const InfoView(kind: InfoKind.help)),
      ),
      GoRoute(
        path: Routes.terms,
        pageBuilder: (_, _) =>
            _slidePage(child: const InfoView(kind: InfoKind.terms)),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('Route not found: ${state.uri}')),
    ),
  );
});

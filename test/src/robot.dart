import 'package:ecommerce_app/src/app.dart';
import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_sync_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/fake_local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/fake_remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/more_menu_button.dart';
import 'package:ecommerce_app/src/features/reviews/data/fake_reviews_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_sync_service.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/fake_focal_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/local_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/remote/fake_remote_wishlist_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'features/authentication/auth_robot.dart';
import 'features/cart/cart_robot.dart';
import 'features/checkout/checkout_robot.dart';
import 'features/orders/orders_robot.dart';
import 'features/products/products_robot.dart';
import 'features/reviews/reviews_robot.dart';
import 'features/wishlist/presentation/wishlist_robot.dart';
import 'goldens/golden_robot.dart';

class Robot {
  Robot(this.tester)
      : auth = AuthRobot(tester),
        products = ProductsRobot(tester),
        cart = CartRobot(tester),
        wishlist = WishlistRobot(tester),
        checkout = CheckoutRobot(tester),
        orders = OrdersRobot(tester),
        reviews = ReviewsRobot(tester),
        golden = GoldenRobot(tester);
  final WidgetTester tester;
  final AuthRobot auth;
  final ProductsRobot products;
  final CartRobot cart;
  final WishlistRobot wishlist;
  final CheckoutRobot checkout;
  final OrdersRobot orders;
  final ReviewsRobot reviews;
  final GoldenRobot golden;

  Future<void> pumpMyApp() async {
    // ensure URL changes in the address bar when using push / pushNamed
    // more info here: https://docs.google.com/document/d/1VCuB85D5kYxPR3qYOjVmw8boAGKb7k62heFyfFHTOvw/edit
    GoRouter.optionURLReflectsImperativeAPIs = true;
    // Override repositories
    final productsRepository = FakeProductsRepository(addDelay: false);
    final authRepository = FakeAuthRepository(addDelay: false);
    final localCartRepository = FakeLocalCartRepository(addDelay: false);
    final remoteCartRepository = FakeRemoteCartRepository(addDelay: false);
    final localWishlistRepository =
        FakeLocalWishlistRepository(addDelay: false);
    final remoteWishlistRepository =
        FakeRemoteWishlistRepository(addDelay: false);
    final ordersRepository = FakeOrdersRepository(addDelay: false);
    final reviewsRepository = FakeReviewsRepository(addDelay: false);

    // * Create ProviderContainer with any required overrides
    final container = ProviderContainer(
      overrides: [
        productsRepositoryProvider.overrideWithValue(productsRepository),
        authRepositoryProvider.overrideWithValue(authRepository),
        localCartRepositoryProvider.overrideWithValue(localCartRepository),
        remoteCartRepositoryProvider.overrideWithValue(remoteCartRepository),
        localWishlistRepositoryProvider
            .overrideWithValue(localWishlistRepository),
        remoteWishlistRepositoryProvider
            .overrideWithValue(remoteWishlistRepository),
        ordersRepositoryProvider.overrideWithValue(ordersRepository),
        reviewsRepositoryProvider.overrideWithValue(reviewsRepository),
      ],
    );
    // * Initialize CartSyncService to start the listener
    container.read(cartSyncServiceProvider);
    container.read(wishlistSyncServiceProvider);
    // * Entry point of the app
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> openPopupMenu() async {
    final finder = find.byType(MoreMenuButton);
    final matches = finder.evaluate();
    // if an item is found, it means that we're running
    // on a small window and can tap to reveal the menu
    if (matches.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
    // else no-op, as the items are already visible
  }

  // navigation
  Future<void> closePage() async {
    final finder = find.byTooltip('Close');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> goBack() async {
    final finder = find.byTooltip('Back');
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
}

import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';

void main() {
  group('wishlist screen', () {
    // * Note: All tests are wrapped with `runAsync` to prevent this error:
    // * A Timer is still pending even after the widget tree was disposed.
    testWidgets('Empty wishlist', (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester);
        await r.pumpMyApp();
        r.products.expectFindNProductCards(14); // check all products are found
        await r.wishlist.openWishlist();
        r.wishlist.expectWishlistIsEmpty();
      });
    });

    testWidgets('Add product to wishlist from ProductScreen', (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester);
        await r.pumpMyApp();
        await r.products.selectProduct();
        await r.wishlist.addToWishlistOnProductScreen();
        await r.wishlist.openWishlist();
        r.wishlist.expectFindNWishlistItems(count: 1);
      });
    });

    testWidgets('Remove product from wishlist from ProductScreen',
        (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester);
        await r.pumpMyApp();
        await r.products.selectProduct();
        await r.wishlist.addToWishlistOnProductScreen();
        await r.wishlist.removeFromWishlistOnProductScreen();
        await r.wishlist.openWishlist();
        r.wishlist.expectWishlistIsEmpty();
      });
    });

    testWidgets(
        'Add product to wishlist from ProductScreen then unfavorite it on Wishlistscreen',
        (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester);
        await r.pumpMyApp();
        await r.products.selectProduct();
        await r.wishlist.addToWishlistOnProductScreen();
        await r.wishlist.openWishlist();
        r.wishlist.expectFindNWishlistItems(count: 1);
        await r.wishlist.removeFromWishlistOnHomeScreen();
        r.wishlist.expectWishlistIsEmpty();
      });
    });

    testWidgets(
        'Add product to wishlist from HomeScreen then unfavorite it on WishlistScreen',
        (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester);
        await r.pumpMyApp();
        await r.wishlist.addToWishlistOnHomeScreen(atIndex: 0);
        await r.wishlist.openWishlist();
        r.wishlist.expectFindNWishlistItems(count: 1);
        await r.wishlist.removeFromWishlistOnWishlistScreen(atIndex: 0);
        r.wishlist.expectWishlistIsEmpty();
      });
    });

    testWidgets('Add two products to wishlist from Home Screen',
        (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester);
        await r.pumpMyApp();
        // add first product
        await r.wishlist.addToWishlistOnHomeScreen(atIndex: 0);
        // add second product
        await r.wishlist.addToWishlistOnHomeScreen(atIndex: 1);
        await r.wishlist.openWishlist();
        r.wishlist.expectFindNWishlistItems(count: 2);
      });
    });

    testWidgets(
        'Add two products to wishlist from Home Screen, remove the second from WishlistScreen',
        (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester);
        await r.pumpMyApp();
        // add first product
        await r.wishlist.addToWishlistOnHomeScreen(atIndex: 0);
        // add second product
        await r.wishlist.addToWishlistOnHomeScreen(atIndex: 1);
        await r.wishlist.openWishlist();
        r.wishlist.expectFindNWishlistItems(count: 2);

        // remove second product from WishlistScreen
        await r.wishlist.removeFromWishlistOnWishlistScreen(atIndex: 1);
        r.wishlist.expectFindNWishlistItems(count: 1);
      });
    });
  });
}

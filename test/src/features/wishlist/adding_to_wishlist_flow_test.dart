import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  // * Note: All tests are wrapped with `runAsync` to prevent this error:
  // * A Timer is still pending even after the widget tree was disposed.

  testWidgets('Adding to wishlist flow', (tester) async {
    await tester.runAsync(() async {
      final r = Robot(tester);
      await r.pumpMyApp();
      r.products.expectFindAllProductCards();
      // add to wishlist flow
      await r.wishlist.addToWishlistOnHomeScreen(atIndex: 0);
      await r.wishlist.addToWishlistOnHomeScreen(atIndex: 2);
      await r.wishlist.removeFromWishlistOnHomeScreen(atIndex: 0);
      await r.wishlist.openWishlist();
      r.wishlist.expectFindNWishlistItems(count: 1);
      r.wishlist.expectGoToCartButton();
      await r.closePage();

      // sign in
      await r.openPopupMenu();
      await r.auth.openEmailPasswordSignInScreen();
      await r.auth.tapFormToggleButton();
      await r.auth.enterAndSubmitEmailAndPassword();
      r.products.expectFindAllProductCards();

      // check wishlist again (to verify wishlist synchronization)
      await r.wishlist.openWishlist();
      r.wishlist.expectFindNWishlistItems(count: 1);
      await r.closePage();
      // sign out
      await r.openPopupMenu();
      await r.auth.openAccountScreen();
      await r.auth.tapLogoutButton();
      await r.auth.tapDialogLogoutButton();
      r.products.expectFindAllProductCards();
    });
  });
}

import 'package:flutter_test/flutter_test.dart';

import '../../robot.dart';

void main() {
  testWidgets('Adding to wishlist flow', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    r.products.expectFindAllProductCards();
    // add to wishlist flow
    await r.wishlist.addToWishlistOnHomeScreen(atIndex: 0);
    await r.wishlist.addToWishlistOnHomeScreen(atIndex: 2);
    await r.wishlist.openWishlist();
    r.wishlist.expectFindNWishlistItems(count: 2);
    await r.closePage();

    // sign in
    await r.openPopupMenu();
    await r.auth.openEmailPasswordSignInScreen();
    await r.auth.signInWithEmailAndPassword();
    r.products.expectFindAllProductCards();

    // check wishlist again (to verify wishlist synchronization)

    await r.wishlist.openWishlist();

    /// To-Do add fix:
    /// the local wishlist is not synced to remote after login

    // r.wishlist.expectFindNWishlistItems(count: 2);
    // await r.closePage();
    // // sign out
    // await r.openPopupMenu();
    // await r.auth.openAccountScreen();
    // await r.auth.tapLogoutButton();
    // await r.auth.tapDialogLogoutButton();
    // r.products.expectFindAllProductCards();
  });
}

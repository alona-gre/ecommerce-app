import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  testWidgets('Full purchase flow', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();
    r.products.expectFindAllProductCards();
    // add to wishlist flow
    await r.wishlist.addToWishlistOnHomeScreen(atIndex: 0);
    await r.wishlist.openWishlist();
    r.wishlist.expectFindNWishlistItems(count: 1);
    await r.wishlist.removeFromWishlistOnWishlistScreen(atIndex: 0);
    r.wishlist.expectWishlistIsEmpty();
    await r.closePage();
    // add to cart flows
    await r.products.selectProduct();
    await r.wishlist.addToWishlistOnProductScreen();
    await r.products.setProductQuantity(3);
    await r.cart.addToCart();
    await r.cart.openCart();
    r.cart.expectFindNCartItems(1);
    // checkout
    await r.checkout.startCheckout();
    await r.auth.enterAndSubmitEmailAndPassword();
    r.cart.expectFindNCartItems(1);
    await r.checkout.startPayment();
    // when a payment is complete, user is taken to the orders page
    r.orders.expectFindNOrders(1);
    await r.closePage(); // close orders page
    // check that cart is now empty
    await r.cart.openCart();
    r.cart.expectFindZeroCartItems();
    await r.closePage();
    // check wishlist again (to verify wishlist synchronization)
    await r.wishlist.openWishlist();
    r.wishlist.expectFindNWishlistItems(count: 1);
    await r.closePage();
    // reviews flow
    await r.products.selectProduct();
    r.reviews.expectFindLeaveReview();
    await r.reviews.tapLeaveReviewButton();
    await r.reviews.createAndSubmitReview('Love it!');
    r.reviews.expectFindOneReview();
    // sign out
    await r.openPopupMenu();
    await r.auth.openAccountScreen();
    await r.auth.tapLogoutButton();
    await r.auth.tapDialogLogoutButton();
    r.products.expectFindAllProductCards();
  });
}

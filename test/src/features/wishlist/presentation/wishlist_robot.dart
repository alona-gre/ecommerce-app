import 'package:ecommerce_app/src/common_widgets/favorite_button.dart';
import 'package:ecommerce_app/src/features/cart/presentation/cart_total/cart_total_text.dart';
import 'package:ecommerce_app/src/features/products/presentation/home_app_bar/wishlist_icon.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/wishlist/wishlist_item.dart';
import 'package:flutter_test/flutter_test.dart';

class WishlistRobot {
  final WidgetTester tester;

  WishlistRobot(this.tester);

  Future<void> addToWishlistOnProductScreen() async {
    final finder = find.byKey(FavoriteButton.addToWishlistButtonKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> removeFromWishlistOnProductScreen() async {
    final finder = find.byKey(FavoriteButton.removeFromWishlistButtonKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> addToWishlistOnHomeScreen({int atIndex = 0}) async {
    final finder = find.byKey(FavoriteButton.addToWishlistButtonKey);
    await tester.tap(finder.at(atIndex));
    await tester.pumpAndSettle();
  }

  Future<void> removeFromWishlistOnHomeScreen({int atIndex = 0}) async {
    final finder = find.byKey(FavoriteButton.removeFromWishlistButtonKey);
    await tester.tap(finder.at(atIndex));
    await tester.pumpAndSettle();
  }

  Future<void> removeFromWishlistOnWishlistScreen({int atIndex = 1}) async {
    final finder = find.byKey(FavoriteButton.removeFromWishlistButtonKey);
    await tester.tap(finder.at(atIndex));
    await tester.pumpAndSettle();
  }

  // wishlist screen
  Future<void> openWishlist() async {
    final finder = find.byKey(WishlistIcon.wishlistIconKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // void expectWishlistIsLoading() {
  //   final finder = find.byType(CircularProgressIndicator);
  //   expect(finder, findsOneWidget);
  // }

  void expectWishlistIsEmpty() {
    final finder = find.text('Your wishlist is empty');
    expect(finder, findsOneWidget);
  }

  // void expectFindZeroWishlistItems() {
  //   final finder = find.byType(WishlistItemWidget);
  //   expect(finder, findsNothing);
  // }

  void expectFindNWishlistItems({required int count}) {
    final finder = find.byType(WishlistItemWidget);
    expect(finder, findsNWidgets(count));
  }

  void expectGoToCartButton() {
    final finder = find.byType(CartTotalText);
    expect(finder, findsOneWidget);
  }
}

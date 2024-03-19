import 'package:ecommerce_app/src/features/wishlist/domain/mutable_wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist_item.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('set favorite', () {
    test('empty wishlist - add a favorite product', () {
      final wishlist = const Wishlist().setFavoriteItem(
        WishlistItem(
          productId: '1',
        ),
      );
      expect(wishlist.items, {'1': true});
    });

    test(
        'wishlist already has this favorite product  - change it to not favotite',
        () {
      final wishlist = const Wishlist({'1': true}).removeFromWishlistById(
        '1',
      );
      expect(wishlist.items, {});
    });

    test('wishlist with one favorite product - add another favorite product',
        () {
      final wishlist = const Wishlist({'1': true}).setFavoriteItem(
        WishlistItem(
          productId: '2',
        ),
      );
      expect(wishlist.items, {'1': true, '2': true});
    });

    test('wishlist with two favorite products - remove one favorite product',
        () {
      final wishlist = const Wishlist({'1': true}).removeFromWishlistById(
        '2',
      );
      expect(wishlist.items, {'1': true});
    });
  });
}

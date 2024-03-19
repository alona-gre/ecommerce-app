import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist_item.dart';

/// Helper extension used to mutate the items in the wishlist.
extension MutableWishlist on Wishlist {
  /// set a product as favorite
  Wishlist setFavoriteItem(WishlistItem wishlistItem) {
    final copy = Map<ProductID, bool>.from(items);
    copy[wishlistItem.productId] = true;
    return Wishlist(copy);
  }

  /// if an item with the given productId is found, remove it
  Wishlist removeFromWishlistById(ProductID productId) {
    final copy = Map<ProductID, bool>.from(items);
    copy.remove(productId);
    return Wishlist(copy);
  }

  /// adds a list of wishlistItems by updating isFavorite value
  /// used when syncing local to remote wishlist
  Wishlist addWishlistItems(List<WishlistItem> itemsToAdd) {
    final copy = Map<ProductID, bool>.from(items);
    for (var item in itemsToAdd) {
      copy.update(
        item.productId,
        // if there is already a value, update it by adding the isFavorite value
        (value) => item.isFavorite,
        ifAbsent: () => item.isFavorite,
      );
    }
    return Wishlist(copy);
  }
}

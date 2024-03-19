import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/local_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/mutable_wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wishlist_service.g.dart';

class WishlistService {
  final Ref ref;
  WishlistService(this.ref);

  /// fetch the Wishlist from remote or local repository
  /// depending on the user auth state
  Future<Wishlist> _fetchWishlist() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteWishlistRepositoryProvider).fetchWishlist(user.uid);
    } else {
      return ref.read(localWishlistRepositoryProvider).fetchWishlist();
    }
  }

  /// sets the Wishlist to remote or local repository
  /// depending on the user auth state
  Future<void> _setWishlist(Wishlist wishlist) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref
          .read(remoteWishlistRepositoryProvider)
          .setWishlist(user.uid, wishlist);
    } else {
      await ref.read(localWishlistRepositoryProvider).setWishlist(wishlist);
    }
  }

  /// adds a product to wishlist in remote or local repository
  /// depending on the user auth state
  Future<void> setWishlistProduct(WishlistItem wishlistItem) async {
    final wishlist = await _fetchWishlist();
    final updatedWishlist = wishlist.setFavoriteItem(wishlistItem);
    await _setWishlist(updatedWishlist);
  }

  // removes a Product from wishlist in remote or local repository
  // depending on the user auth state
  Future<void> removeWishlistProduct(WishlistItem wishlistItem) async {
    final wishlist = await _fetchWishlist();
    final updatedWishlist =
        wishlist.removeFromWishlistById(wishlistItem.productId);
    await _setWishlist(updatedWishlist);
  }

  // removes a Product from wishlist in remote or local repository
  // depending on the user auth state
  Future<void> removeWishlistProductById(ProductID productId) async {
    final wishlist = await _fetchWishlist();
    final updatedWishlist = wishlist.removeFromWishlistById(productId);
    await _setWishlist(updatedWishlist);
  }
}

@Riverpod(keepAlive: true)
WishlistService wishlistService(WishlistServiceRef ref) {
  return WishlistService(ref);
}

@Riverpod(keepAlive: true)
Stream<Wishlist> wishlist(WishlistRef ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref.read(remoteWishlistRepositoryProvider).watchWishlist(user.uid);
  } else {
    return ref.read(localWishlistRepositoryProvider).watchWishlist();
  }
}

@Riverpod(keepAlive: true)
int wishlistItemsCount(WishlistItemsCountRef ref) {
  return ref.watch(wishlistProvider).maybeMap(
        data: (cart) => cart.value.items.length,
        orElse: () => 0,
      );
}

@riverpod
bool isFavorite(IsFavoriteRef ref, ProductID productId) {
  final wishlist = ref.watch(wishlistProvider).value ?? const Wishlist();

  return wishlist.items[productId] ?? false;
}

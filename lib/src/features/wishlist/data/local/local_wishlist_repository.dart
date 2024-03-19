import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'local_wishlist_repository.g.dart';

abstract class LocalWishlistRepository {
  /// API for reading, watching and writing local wishlist data (guest user)
  Future<Wishlist> fetchWishlist();

  Stream<Wishlist> watchWishlist();

  Future<void> setWishlist(Wishlist wishlist);
}

@Riverpod(keepAlive: true)
LocalWishlistRepository localWishlistRepository(
    LocalWishlistRepositoryRef ref) {
  // * Override this in the main method
  throw UnimplementedError();
}

import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class LocalWishlistRepository {
  /// API for reading, watching and writing local wishlist data (guest user)
  Future<Wishlist> fetchWishlist();

  Stream<Wishlist> watchWishlist();

  Future<void> setWishlist(Wishlist wishlist);
}

final localWishlistRepositoryProvider = Provider<LocalWishlistRepository>(
  (ref) {
    // * Override this in the main method
    throw UnimplementedError();
  },
);

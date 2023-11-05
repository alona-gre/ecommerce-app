import 'package:ecommerce_app/src/features/wishlist/data/remote/fake_remote_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class RemoteWishlistRepository {
  /// API for reading, watching and writing wishlist data for a specific user ID
  Future<Wishlist> fetchWishlist(String uid);
  Stream<Wishlist> watchWishlist(String uid);
  Future<void> setWishlist(String uid, Wishlist wishlist);
}

final remoteWishlistRepositoryProvider =
    Provider<RemoteWishlistRepository>((ref) {
  // TODO: replace with a 'real' remote wishlist repository
  return FakeRemoteWishlistRepository();
});

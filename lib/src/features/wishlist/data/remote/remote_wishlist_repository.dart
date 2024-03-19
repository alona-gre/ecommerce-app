import 'package:ecommerce_app/src/features/wishlist/data/remote/fake_remote_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'remote_wishlist_repository.g.dart';

abstract class RemoteWishlistRepository {
  /// API for reading, watching and writing wishlist data for a specific user ID
  Future<Wishlist> fetchWishlist(String uid);
  Stream<Wishlist> watchWishlist(String uid);
  Future<void> setWishlist(String uid, Wishlist wishlist);
}

@Riverpod(keepAlive: true)
RemoteWishlistRepository remoteWishlistRepository(
    RemoteWishlistRepositoryRef ref) {
  // TODO: replace with "real" remote cart repository
  return FakeRemoteWishlistRepository(addDelay: false);
}

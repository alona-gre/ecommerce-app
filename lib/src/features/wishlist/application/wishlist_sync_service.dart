import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/local_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/mutable_wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistSyncService {
  final Ref ref;

  WishlistSyncService(this.ref) {
    _init();
  }

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider,
        (previous, next) {
      final previousUser = previous?.value;
      final user = next.value;
      if (previousUser == null && user != null) {
        _moveItemsToRemoteCart(user.uid);
      }
    });
  }

  /// moves all items from the local to remote wishlist
  void _moveItemsToRemoteCart(String uid) async {
    try {
      // get the local wishlist data
      final localWishlistRepository = ref.read(localWishlistRepositoryProvider);
      final localWishlist = await localWishlistRepository.fetchWishlist();
      if (localWishlist.items.isNotEmpty) {
        // get the remote wishlist data
        final remoteWishlistRepository =
            ref.read(remoteWishlistRepositoryProvider);
        final remoteWishlist =
            await remoteWishlistRepository.fetchWishlist(uid);
        // add all the local wishlist items to the remote wishlist
        final updatedRemoteWishlist = remoteWishlist.addWishlistItems(
          localWishlist.toWishlistItemsList(),
        );
        // write the updated remote wishlist data to the repository
        await remoteWishlistRepository.setWishlist(uid, updatedRemoteWishlist);
        // remove all the items from the local wishlist
        await localWishlistRepository.setWishlist(const Wishlist());
      }
    } catch (e) {
      /// Handle error and/or rethrow
    }
  }
}

final wishlistSyncServiceProvider = Provider<WishlistSyncService>(
  (ref) {
    return WishlistSyncService(ref);
  },
);

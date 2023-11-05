import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeRemoteWishlistRepository implements RemoteWishlistRepository {
  final bool addDelay;

  FakeRemoteWishlistRepository({this.addDelay = true});

  /// An InMemoryStore containing the shopping cart data for all users, where:
  /// key: uid of the user,
  /// value: Wishlist of that user
  final _wishlists = InMemoryStore<Map<String, Wishlist>>({});

  @override
  Future<Wishlist> fetchWishlist(String uid) {
    return Future.value(_wishlists.value[uid] ?? const Wishlist());
  }

  @override
  Stream<Wishlist> watchWishlist(String uid) {
    return _wishlists.stream
        .map((wishlistData) => wishlistData[uid] ?? const Wishlist());
  }

  @override
  Future<void> setWishlist(String uid, Wishlist wishlist) async {
    await delay(addDelay);
    // First, get the current wishlists data for all users
    final wishlists = _wishlists.value;
    // Then, set the wishlist for the given uid
    wishlists[uid] = wishlist;
    // Finally, update the wishlists data (will emit a new value)
    _wishlists.value = wishlists;
  }
}

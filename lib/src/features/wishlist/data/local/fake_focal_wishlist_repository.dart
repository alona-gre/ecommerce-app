import 'package:ecommerce_app/src/features/wishlist/data/local/local_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';

class FakeLocalWishlistRepository implements LocalWishlistRepository {
  final bool addDelay;

  FakeLocalWishlistRepository({this.addDelay = true});

  final _wishlist = InMemoryStore<Wishlist>(const Wishlist());

  /// we fetch the latest version of the Wishlist
  @override
  Future<Wishlist> fetchWishlist() => Future.value(_wishlist.value);

  /// we watch the changes to the Wishlist
  @override
  Stream<Wishlist> watchWishlist() => _wishlist.stream;

  /// we set a new value of the Wishlist
  @override
  Future<void> setWishlist(Wishlist wishlist) async {
    await delay(addDelay);
    _wishlist.value = wishlist;
  }
}

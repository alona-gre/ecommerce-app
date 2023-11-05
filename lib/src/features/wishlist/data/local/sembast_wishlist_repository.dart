import 'package:ecommerce_app/src/features/wishlist/data/local/local_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastWishlistRepository implements LocalWishlistRepository {
  final Database db;
  SembastWishlistRepository(this.db);

  final store = StoreRef.main();

  static Future<Database> createDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  static Future<SembastWishlistRepository> makeDefault() async {
    return SembastWishlistRepository(await createDatabase('wishlist.db'));
  }

  static const wishlistProductsKey = 'wishlistProducts';

  @override
  Future<Wishlist> fetchWishlist() async {
    final wishlistJson =
        await store.record(wishlistProductsKey).get(db) as String?;
    if (wishlistJson != null) {
      return Wishlist.fromJson(wishlistJson);
    } else {
      return const Wishlist();
    }
  }

  @override
  Future<void> setWishlist(Wishlist wishlist) {
    //throw Exception('');
    return store.record(wishlistProductsKey).put(db, wishlist.toJson());
  }

  @override
  Stream<Wishlist> watchWishlist() {
    final record = store.record(wishlistProductsKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Wishlist.fromJson(snapshot.value as String);
      } else {
        return const Wishlist();
      }
    });
  }
}

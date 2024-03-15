import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlistItem.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddToWishlistController extends StateNotifier<AsyncValue<bool>> {
  final WishlistService wishlistService;

  AddToWishlistController({required this.wishlistService})
      : super(const AsyncData(false));

  Future<void> addProductToWishlist(WishlistItem wishlistItem) async {
    state = const AsyncLoading<bool>().copyWithPrevious(state);
    final value = await AsyncValue.guard(
      () => wishlistService.setWishlistProduct(wishlistItem),
    );
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(true);
    }
  }

  Future<void> removeProductFromWishlist(WishlistItem wishlistItem) async {
    state = const AsyncLoading<bool>().copyWithPrevious(state);
    final value = await AsyncValue.guard(
      () => wishlistService.removeWishlistProduct(wishlistItem),
    );
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(false);
    }
  }
}

final addToWishlistControllerProvider =
    StateNotifierProvider<AddToWishlistController, AsyncValue<bool>>((ref) {
  return AddToWishlistController(
      wishlistService: ref.watch(wishlistServiceProvider));
});

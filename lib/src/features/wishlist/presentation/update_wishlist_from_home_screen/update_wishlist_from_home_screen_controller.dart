import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlistItem.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateWishlistFromHomeScreenController
    extends StateNotifier<AsyncValue<void>> {
  final WishlistService wishlistService;

  UpdateWishlistFromHomeScreenController({
    required this.wishlistService,
  }) : super(const AsyncData(null));

  Future<void> addProductToWishlistFromHomeScreen(
      WishlistItem wishlistItem) async {
    state = const AsyncLoading<void>();
    // state = const AsyncLoading<bool>().copyWithPrevious(state);
    final value = await AsyncValue.guard(
      () => wishlistService.setWishlistProduct(wishlistItem),
    );
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }

  Future<void> removeProductFromWishlistFromHomeScreen(
      ProductID productId) async {
    state = const AsyncLoading<void>();
    //state = const AsyncLoading<bool>().copyWithPrevious(state);
    final value = await AsyncValue.guard(
      () => wishlistService.removeWishlistProductById(productId),
    );
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }
}

final updateWishlistFromHomeScreenControllerProvider =
    StateNotifierProvider.autoDispose<UpdateWishlistFromHomeScreenController,
        AsyncValue<void>>((ref) {
  return UpdateWishlistFromHomeScreenController(
      wishlistService: ref.watch(wishlistServiceProvider));
});

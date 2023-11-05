import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WishlistScreenController extends StateNotifier<AsyncValue<void>> {
  final WishlistService wishlistService;

  WishlistScreenController({required this.wishlistService})
      : super(const AsyncData(null));

  Future<void> removeFromWishlistScreenById(ProductID productId) async {
    state = const AsyncLoading<bool>();
    final value = await AsyncValue.guard(
        () => wishlistService.removeWishlistProductById(productId));
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }
}

final wishlistScreenControllerProvider = StateNotifierProvider.autoDispose<
    WishlistScreenController, AsyncValue<void>>((ref) {
  return WishlistScreenController(
      wishlistService: ref.watch(wishlistServiceProvider));
});

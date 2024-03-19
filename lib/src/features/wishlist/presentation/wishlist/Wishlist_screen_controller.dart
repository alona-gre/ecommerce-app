import 'dart:async';

import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'wishlist_screen_controller.g.dart';

@riverpod
class WishlistScreenController extends _$WishlistScreenController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }

  Future<void> removeFromWishlistScreenById(ProductID productId) async {
    final wishlistService = ref.read(wishlistServiceProvider);
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

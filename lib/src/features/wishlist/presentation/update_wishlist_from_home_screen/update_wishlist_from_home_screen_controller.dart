import 'dart:async';

import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'update_wishlist_from_home_screen_controller.g.dart';

@riverpod
class UpdateWishlistFromHomeScreenController
    extends _$UpdateWishlistFromHomeScreenController {
  @override
  FutureOr<void> build() {
    // nothing to do
  }

  WishlistService get wishlistService => ref.read(wishlistServiceProvider);

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

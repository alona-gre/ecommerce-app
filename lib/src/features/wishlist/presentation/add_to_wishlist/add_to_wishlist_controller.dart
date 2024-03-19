import 'dart:async';

import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_to_wishlist_controller.g.dart';

@riverpod
class AddToWishlistController extends _$AddToWishlistController {
  @override
  FutureOr<bool> build() {
    return false;
  }

  WishlistService get wishlistService => ref.read(wishlistServiceProvider);

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

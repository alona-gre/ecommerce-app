import 'package:ecommerce_app/src/features/wishlist/domain/wishlistItem.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/update_wishlist_from_home_screen/update_wishlist_from_home_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  group('add Product to Wishlist from Home Screen', () {
    const productId = '1';
    test('add Product to Wishlist from Home Screen, success ', () async {
      // setup
      final wishlistProduct = WishlistItem(
        productId: productId,
      );
      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.setWishlistProduct(wishlistProduct),
      ).thenAnswer((_) => Future.value());

      // run & verify
      final controller = UpdateWishlistFromHomeScreenController(
        wishlistService: wishlistService,
      );
      expect(
        controller.state,
        const AsyncData<void>(null),
      );
      await controller.addProductToWishlistFromHomeScreen(
        WishlistItem(productId: productId),
      );

      verify(() => wishlistService.setWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
    });

    test('add Product to Wishlist  from Home Screen, failure ', () async {
      // setup
      final wishlistProduct = WishlistItem(
        productId: productId,
      );
      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.setWishlistProduct(wishlistProduct),
      ).thenThrow((_) => Exception('Connection failed'));

      // run & verify
      final controller = UpdateWishlistFromHomeScreenController(
        wishlistService: wishlistService,
      );

      expect(
        controller.state,
        const AsyncData<void>(null),
      );
      await controller.addProductToWishlistFromHomeScreen(
        WishlistItem(productId: productId),
      );

      verify(() => wishlistService.setWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
      expect(
        controller.state,
        predicate<AsyncValue<void>>(
          (value) {
            expect(value.hasError, true);
            return true;
          },
        ),
      );
    });
  });

  group('remove Product from Wishlist from Home Screen', () {
    const productId = '1';
    test('remove Product from Wishlist from Home Screen, success ', () async {
      // setup

      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.removeWishlistProductById(productId),
      ).thenAnswer((_) => Future.value());

      // run & verify
      final controller = UpdateWishlistFromHomeScreenController(
        wishlistService: wishlistService,
      );
      expect(
        controller.state,
        const AsyncData<void>(null),
      );
      await controller.removeProductFromWishlistFromHomeScreen(productId);

      verify(() => wishlistService.removeWishlistProductById(productId))
          .called(1);
    });

    test('remove Product from Wishlist from Home Screen, failure ', () async {
      // setup
      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.removeWishlistProductById(productId),
      ).thenThrow((_) => Exception('Connection failed'));

      // run & verify
      final controller = UpdateWishlistFromHomeScreenController(
        wishlistService: wishlistService,
      );

      expect(
        controller.state,
        const AsyncData<void>(null),
      );
      await controller.removeProductFromWishlistFromHomeScreen(productId);

      verify(() => wishlistService.removeWishlistProductById(productId))
          .called(1);
      expect(
        controller.state,
        predicate<AsyncValue<void>>(
          (value) {
            expect(value.hasError, true);
            return true;
          },
        ),
      );
    });
  });
}

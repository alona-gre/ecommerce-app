import 'package:ecommerce_app/src/features/wishlist/presentation/wishlist/Wishlist_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  group('remove Product from Wishlist on Wishlist Screen', () {
    const productId = '1';
    test('remove Product from Wishlist on Wishlist Screen, success ', () async {
      // setup

      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.removeWishlistProductById(productId),
      ).thenAnswer((_) => Future.value());

      // run & verify
      final controller = WishlistScreenController(
        wishlistService: wishlistService,
      );
      expect(
        controller.state,
        const AsyncData<void>(null),
      );
      await controller.removeFromWishlistScreenById(productId);

      verify(() => wishlistService.removeWishlistProductById(productId))
          .called(1);
    });

    test('remove Product from Wishlist on Wishlist Screen, failure ', () async {
      // setup
      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.removeWishlistProductById(productId),
      ).thenThrow((_) => Exception('Connection failed'));

      // run & verify
      final controller = WishlistScreenController(
        wishlistService: wishlistService,
      );

      expect(
        controller.state,
        const AsyncData<void>(null),
      );
      await controller.removeFromWishlistScreenById(productId);

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

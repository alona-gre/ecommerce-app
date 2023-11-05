import 'package:ecommerce_app/src/features/wishlist/domain/wishlistItem.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/add_to_wishlist/add_to_wishlist_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const productId = '1';

  group('add Product to Wishlist', () {
    test('add Product to Wishlist, success ', () async {
      // setup
      final wishlistProduct = WishlistItem(
        productId: productId,
      );
      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.setWishlistProduct(wishlistProduct),
      ).thenAnswer((_) => Future.value());

      // run & verify
      final controller = AddToWishlistController(
        wishlistService: wishlistService,
      );
      expect(
        controller.state,
        const AsyncData(false),
      );
      await controller.addProductToWishlist(
        WishlistItem(productId: productId),
      );

      verify(() => wishlistService.setWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
      expect(
        controller.state,
        const AsyncData(true),
      );
    });

    test('add Product to Wishlist, failure ', () async {
      // setup
      final wishlistProduct = WishlistItem(
        productId: productId,
      );
      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.setWishlistProduct(wishlistProduct),
      ).thenThrow((_) => Exception('Connection failed'));

      // run & verify
      final controller = AddToWishlistController(
        wishlistService: wishlistService,
      );

      expect(
        controller.state,
        const AsyncData(false),
      );
      await controller.addProductToWishlist(
        WishlistItem(productId: productId),
      );

      verify(() => wishlistService.setWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
      expect(
        controller.state,
        predicate<AsyncValue<bool>>(
          (value) {
            expect(value.hasError, true);
            return true;
          },
        ),
      );
    });
  });

  group('remove Product from Wishlist', () {
    test('add and remove Product from Wishlist, success ', () async {
      // setup
      final wishlistProduct = WishlistItem(
        productId: productId,
      );
      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.setWishlistProduct(wishlistProduct),
      ).thenAnswer((_) => Future.value());
      when(
        () => wishlistService.removeWishlistProduct(wishlistProduct),
      ).thenAnswer((_) => Future.value());

      // run & verify
      final controller = AddToWishlistController(
        wishlistService: wishlistService,
      );
      expect(
        controller.state,
        const AsyncData(false),
      );
      await controller.addProductToWishlist(
        WishlistItem(productId: productId),
      );

      verify(() => wishlistService.setWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
      expect(
        controller.state,
        const AsyncData(true),
      );

      await controller.removeProductFromWishlist(
        WishlistItem(productId: productId),
      );

      verify(() => wishlistService.removeWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
      expect(
        controller.state,
        const AsyncData(false),
      );
    });

    test('add Product to Wishlist, failure ', () async {
      // setup
      final wishlistProduct = WishlistItem(
        productId: productId,
      );
      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.setWishlistProduct(wishlistProduct),
      ).thenAnswer((_) => Future.value());
      when(
        () => wishlistService.removeWishlistProduct(wishlistProduct),
      ).thenThrow((_) => Exception('Connection failed'));

      // run & verify
      final controller = AddToWishlistController(
        wishlistService: wishlistService,
      );
      expect(
        controller.state,
        const AsyncData(false),
      );
      await controller.addProductToWishlist(
        WishlistItem(productId: productId),
      );

      verify(() => wishlistService.setWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
      expect(
        controller.state,
        const AsyncData(true),
      );

      await controller.removeProductFromWishlist(
        WishlistItem(productId: productId),
      );

      verify(() => wishlistService.removeWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
      expect(
        controller.state,
        predicate<AsyncValue<bool>>(
          (value) {
            expect(value.hasError, true);
            return true;
          },
        ),
      );
    });
  });
}

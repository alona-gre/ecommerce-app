import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist_item.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/update_wishlist_from_home_screen/update_wishlist_from_home_screen_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks.dart';

void main() {
  const productId = '1';

  ProviderContainer makeProviderContainer(MockWishlistService wishlistService) {
    final container = ProviderContainer(
      overrides: [
        wishlistServiceProvider.overrideWithValue(wishlistService),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  setUpAll(() {
    registerFallbackValue(const AsyncLoading<void>());
  });
  group('add Product to Wishlist from Home Screen', () {
    test('add Product to Wishlist from Home Screen, success ', () async {
      // setup
      final wishlistProduct = WishlistItem(
        productId: productId,
      );
      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.setWishlistProduct(wishlistProduct),
      ).thenAnswer((_) => Future.value());

      final container = makeProviderContainer(wishlistService);
      final controller = container
          .read(updateWishlistFromHomeScreenControllerProvider.notifier);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        updateWishlistFromHomeScreenControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      // run
      const initialData = AsyncData<void>(null);
      // the build method returns a value immediately, so we expect AsyncData
      verify(() => listener(null, initialData));
      // add item to wishlist
      await controller.addProductToWishlistFromHomeScreen(
        WishlistItem(productId: productId),
      );
      verifyInOrder(
        [
          // the loading state is set
          () => listener(initialData, any(that: isA<AsyncLoading>())),
          // the loading is off
          () => listener(any(that: isA<AsyncLoading>()), initialData),
        ],
      );

      verifyNoMoreInteractions(listener);
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

      final container = makeProviderContainer(wishlistService);
      final controller = container
          .read(updateWishlistFromHomeScreenControllerProvider.notifier);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        updateWishlistFromHomeScreenControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      // run
      const initialData = AsyncData<void>(null);
      // the build method returns a value immediately, so we expect AsyncData
      verify(() => listener(null, initialData));
      // add item to wishlist
      await controller.addProductToWishlistFromHomeScreen(
        WishlistItem(productId: productId),
      );
      verifyInOrder(
        [
          // the loading state is set
          () => listener(
                initialData,
                any(that: isA<AsyncLoading>()),
              ),
          // the loading state is off, error

          () => listener(
              any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
        ],
      );

      verifyNoMoreInteractions(listener);
      verify(() => wishlistService.setWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
    });
  });

  group('remove Product from Wishlist from Home Screen', () {
    test('remove Product from Wishlist from Home Screen, success ', () async {
      // setup

      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.removeWishlistProductById(productId),
      ).thenAnswer((_) => Future.value());

      final container = makeProviderContainer(wishlistService);
      final controller = container
          .read(updateWishlistFromHomeScreenControllerProvider.notifier);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        updateWishlistFromHomeScreenControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      // run
      const initialData = AsyncData<void>(null);
      // the build method returns a value immediately, so we expect AsyncData
      verify(() => listener(null, initialData));
      // add item to wishlist
      await controller.removeProductFromWishlistFromHomeScreen(productId);
      verifyInOrder(
        [
          // the loading state is set
          () => listener(initialData, any(that: isA<AsyncLoading>())),
          // the loading is off
          () => listener(any(that: isA<AsyncLoading>()), initialData),
        ],
      );

      verifyNoMoreInteractions(listener);
      verify(() => wishlistService.removeWishlistProductById(productId))
          .called(1);
    });

    test('remove Product from Wishlist from Home Screen, failure ', () async {
      // setup

      final wishlistService = MockWishlistService();
      when(
        () => wishlistService.removeWishlistProductById(productId),
      ).thenThrow((_) => Exception('Connection failed'));

      final container = makeProviderContainer(wishlistService);
      final controller = container
          .read(updateWishlistFromHomeScreenControllerProvider.notifier);
      final listener = Listener<AsyncValue<void>>();
      container.listen(
        updateWishlistFromHomeScreenControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      // run
      const initialData = AsyncData<void>(null);
      // the build method returns a value immediately, so we expect AsyncData
      verify(() => listener(null, initialData));
      // add item to wishlist
      await controller.removeProductFromWishlistFromHomeScreen(productId);
      verifyInOrder(
        [
          // the loading state is set
          () => listener(initialData, any(that: isA<AsyncLoading>())),
          // the loading is off, error
          () => listener(
              any(that: isA<AsyncLoading>()), any(that: isA<AsyncError>())),
        ],
      );

      verifyNoMoreInteractions(listener);
      verify(() => wishlistService.removeWishlistProductById(productId))
          .called(1);
    });
  });
}

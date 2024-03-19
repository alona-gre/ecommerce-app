import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist_item.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/add_to_wishlist/add_to_wishlist_controller.dart';
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
    registerFallbackValue(const AsyncLoading<bool>());
  });

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

      final container = makeProviderContainer(wishlistService);
      final controller =
          container.read(addToWishlistControllerProvider.notifier);
      final listener = Listener<AsyncValue<bool>>();
      container.listen(
        addToWishlistControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      // run
      const initialData = AsyncData<bool>(false);
      // the build method returns a value immediately, so we expect AsyncData
      verify(() => listener(null, initialData));
      // add item to wishlist
      await controller.addProductToWishlist(
        WishlistItem(productId: productId),
      );
      verifyInOrder(
        [
          // the loading state is set
          () => listener(
                initialData,
                const AsyncLoading<bool>()
                    .copyWithPrevious(const AsyncData<bool>(false)),
              ),
          // the data is set to true
          () => listener(
                const AsyncLoading<bool>()
                    .copyWithPrevious(const AsyncData<bool>(false)),
                const AsyncData<bool>(true),
              ),
        ],
      );

      verifyNoMoreInteractions(listener);
      verify(() => wishlistService.setWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
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

      final container = makeProviderContainer(wishlistService);
      final controller =
          container.read(addToWishlistControllerProvider.notifier);
      final listener = Listener<AsyncValue<bool>>();
      container.listen(
        addToWishlistControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      // run
      const initialData = AsyncData<bool>(false);
      // the build method returns a value immediately, so we expect AsyncData
      verify(() => listener(null, initialData));
      // add item to wishlist
      await controller.addProductToWishlist(
        WishlistItem(productId: productId),
      );
      verifyInOrder(
        [
          // the loading state is set
          () => listener(
                initialData,
                const AsyncLoading<bool>()
                    .copyWithPrevious(const AsyncData<bool>(false)),
              ),
          // throws error
          () => listener(
                const AsyncLoading<bool>()
                    .copyWithPrevious(const AsyncData<bool>(false)),
                any(that: isA<AsyncError>()),
              ),
        ],
      );

      verifyNoMoreInteractions(listener);
      verify(() => wishlistService.setWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
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

      final container = makeProviderContainer(wishlistService);
      final controller =
          container.read(addToWishlistControllerProvider.notifier);
      final listener = Listener<AsyncValue<bool>>();
      container.listen(
        addToWishlistControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      // run
      const initialData = AsyncData<bool>(false);
      // the build method returns a value immediately, so we expect AsyncData
      verify(() => listener(null, initialData));
      // add item to wishlist
      await controller.addProductToWishlist(
        WishlistItem(productId: productId),
      );
      // remove item from wishlist
      await controller.removeProductFromWishlist(
        WishlistItem(productId: productId),
      );

      verifyInOrder(
        [
          // the loading state is set
          () => listener(
                initialData,
                const AsyncLoading<bool>()
                    .copyWithPrevious(const AsyncData<bool>(false)),
              ),
          // the data is set to true
          () => listener(
                const AsyncLoading<bool>()
                    .copyWithPrevious(const AsyncData<bool>(false)),
                const AsyncData<bool>(true),
              ),
          // the loading state is set
          () => listener(
                const AsyncData<bool>(true),
                const AsyncLoading<bool>()
                    .copyWithPrevious(const AsyncData<bool>(true)),
              ),
          // the data is set to false
          () => listener(
                const AsyncLoading<bool>()
                    .copyWithPrevious(const AsyncData<bool>(true)),
                const AsyncData<bool>(false),
              ),
        ],
      );

      verifyNoMoreInteractions(listener);
      verify(() => wishlistService.setWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
      verify(() => wishlistService.removeWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
    });

    test('add Product to Wishlist and remove, failure ', () async {
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

      final container = makeProviderContainer(wishlistService);
      final controller =
          container.read(addToWishlistControllerProvider.notifier);
      final listener = Listener<AsyncValue<bool>>();
      container.listen(
        addToWishlistControllerProvider,
        listener.call,
        fireImmediately: true,
      );
      // run
      const initialData = AsyncData<bool>(false);
      // the build method returns a value immediately, so we expect AsyncData
      verify(() => listener(null, initialData));
      // add item to wishlist
      await controller.addProductToWishlist(
        WishlistItem(productId: productId),
      );
      // remove item from wishlist
      await controller.removeProductFromWishlist(
        WishlistItem(productId: productId),
      );

      verifyInOrder(
        [
          // the loading state is set
          () => listener(
                initialData,
                const AsyncLoading<bool>()
                    .copyWithPrevious(const AsyncData<bool>(false)),
              ),
          // the data is set to true
          () => listener(
                const AsyncLoading<bool>()
                    .copyWithPrevious(const AsyncData<bool>(false)),
                const AsyncData<bool>(true),
              ),
          // the loading state is set
          () => listener(
                const AsyncData<bool>(true),
                const AsyncLoading<bool>()
                    .copyWithPrevious(const AsyncData<bool>(true)),
              ),
          // throws error
          () => listener(
                const AsyncLoading<bool>()
                    .copyWithPrevious(const AsyncData<bool>(true)),
                any(that: isA<AsyncError>()),
              ),
        ],
      );

      verifyNoMoreInteractions(listener);
      verify(() => wishlistService.setWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
      verify(() => wishlistService.removeWishlistProduct(
            WishlistItem(productId: productId),
          )).called(1);
    });
  });
}

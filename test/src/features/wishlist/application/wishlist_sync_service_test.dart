import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_sync_service.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/local_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockLocalWishlistRepository localWishlistRepository;
  late MockRemoteWishlistRepository remoteWishlistRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    localWishlistRepository = MockLocalWishlistRepository();
    remoteWishlistRepository = MockRemoteWishlistRepository();
  });

  WishlistSyncService makeWishlistSyncService() {
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      localWishlistRepositoryProvider
          .overrideWithValue(localWishlistRepository),
      remoteWishlistRepositoryProvider
          .overrideWithValue(remoteWishlistRepository),
    ]);
    addTearDown(container.dispose);
    return container.read(wishlistSyncServiceProvider);
  }

  group('WishlistSyncService', () {
    Future<void> runWishlistSyncTest({
      required Map<ProductID, bool> localWishlistItems,
      required Map<ProductID, bool> remoteWishlistItems,
      required Map<ProductID, bool> expectedRemoteWishlistItems,
    }) async {
      const uid = '123';
      when(authRepository.authStateChanges).thenAnswer(
        (_) => Stream.value(
          const AppUser(uid: uid, email: 'test@test.com'),
        ),
      );

      when(localWishlistRepository.fetchWishlist).thenAnswer(
        (_) => Future.value(Wishlist(localWishlistItems)),
      );
      when(() => remoteWishlistRepository.fetchWishlist(uid)).thenAnswer(
        (_) => Future.value(Wishlist(remoteWishlistItems)),
      );
      when(() => remoteWishlistRepository.setWishlist(
              uid, Wishlist(expectedRemoteWishlistItems)))
          .thenAnswer((_) => Future.value());
      when(() => localWishlistRepository.setWishlist(const Wishlist()))
          .thenAnswer((_) => Future.value());
      // create Wishlist sync service (not needed to return a value)
      makeWishlistSyncService();
      // wait for all the stubbed methods to return a value
      await Future.delayed(const Duration());
      // verify
      verify(
        () => remoteWishlistRepository.setWishlist(
          uid,
          Wishlist(expectedRemoteWishlistItems),
        ),
      ).called(1);
      verify(
        () => localWishlistRepository.setWishlist(const Wishlist()),
      ).called(1);
    }

    test('local wishlist is not empty, remote is empty', () async {
      await runWishlistSyncTest(
          localWishlistItems: {'1': true},
          remoteWishlistItems: {},
          expectedRemoteWishlistItems: {'1': true});
    });

    test('local and remote wishlists have the same items', () async {
      await runWishlistSyncTest(
          localWishlistItems: {'1': true},
          remoteWishlistItems: {'1': true},
          expectedRemoteWishlistItems: {'1': true});
    });

    test('multiple items in local and remote wishlists', () async {
      await runWishlistSyncTest(
        localWishlistItems: {'1': true, '2': true, '3': true},
        remoteWishlistItems: {'1': true, '4': true},
        expectedRemoteWishlistItems: {
          '1': true,
          '2': true,
          '3': true,
          '4': true
        },
      );
    });
  });
}

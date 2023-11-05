import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/authentication/domain/app_user.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/local_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlistItem.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const Wishlist());
  });
  const testUser = AppUser(uid: 'abc', email: 'abc@test.com');

  late MockAuthRepository authRepository;
  late MockRemoteWishlistRepository remoteWishlistRepository;
  late MockLocalWishlistRepository localWishlistRepository;
  setUp(() {
    authRepository = MockAuthRepository();
    remoteWishlistRepository = MockRemoteWishlistRepository();
    localWishlistRepository = MockLocalWishlistRepository();
  });

  WishlistService makeWishlistService() {
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      localWishlistRepositoryProvider
          .overrideWithValue(localWishlistRepository),
      remoteWishlistRepositoryProvider
          .overrideWithValue(remoteWishlistRepository),
    ]);
    addTearDown(container.dispose);
    return container.read(wishlistServiceProvider);
  }

  group('setWishlistProduct', () {
    test('null user, writes product to local wishlist', () async {
      // setup
      const expectedWishlist = Wishlist({'1': true});
      final wishlistService = makeWishlistService();
      when(() => authRepository.currentUser).thenReturn(null);
      when(() => localWishlistRepository.fetchWishlist()).thenAnswer(
        (_) => Future.value(const Wishlist()),
      );
      when(() => localWishlistRepository.setWishlist(expectedWishlist))
          .thenAnswer(
        (_) => Future.value(),
      );
      // run
      await wishlistService.setWishlistProduct(
        WishlistItem(productId: '1'),
      );
      // verify
      verify(
        () => localWishlistRepository.setWishlist(expectedWishlist),
      ).called(1);
      verifyNever(
        () => remoteWishlistRepository.setWishlist(any(), any()),
      );
    });

    test('non-null user, writes product to remote cart', () async {
      const expectedWishlist = Wishlist({'1': true});
      final wishlistService = makeWishlistService();
      when(() => authRepository.currentUser).thenReturn(testUser);
      when(() => remoteWishlistRepository.fetchWishlist(testUser.uid))
          .thenAnswer(
        (_) => Future.value(const Wishlist()),
      );
      when(() => remoteWishlistRepository.setWishlist(
          testUser.uid, expectedWishlist)).thenAnswer(
        (_) => Future.value(),
      );
      // run
      await wishlistService.setWishlistProduct(
        WishlistItem(productId: '1'),
      );
      // verify
      verify(
        () => remoteWishlistRepository.setWishlist(
            testUser.uid, expectedWishlist),
      ).called(1);
      verifyNever(
        () => localWishlistRepository.setWishlist(any()),
      );
    });
  });

  group('removeWishlistProduct', () {
    test('null user, removes a product from local  Wishlist', () async {
      // setup
      const initialWishlist = Wishlist({'0': false, '1': true});
      const expectedWishlist = Wishlist({'0': false});
      final wishlistService = makeWishlistService();
      when(() => authRepository.currentUser).thenReturn(null); // null user
      when(() => localWishlistRepository.fetchWishlist()).thenAnswer(
        (_) => Future.value(initialWishlist), // empty Wishlist
      );
      when(() => localWishlistRepository.setWishlist(expectedWishlist))
          .thenAnswer(
        (_) => Future.value(),
      );
      // run
      await wishlistService.removeWishlistProduct(WishlistItem(productId: '1'));

      // verify
      verify(
        () => localWishlistRepository.setWishlist(expectedWishlist),
      ).called(1);
      verifyNever(
        () => remoteWishlistRepository.setWishlist(any(), any()),
      );
    });

    test('non-null user, adds item to remote Wishlist', () async {
      // setup
      const initialWishlist = Wishlist({'0': false, '1': true});
      const expectedWishlist = Wishlist({'0': false});
      final wishlistService = makeWishlistService();
      when(() => authRepository.currentUser).thenReturn(testUser); // null user
      when(() => remoteWishlistRepository.fetchWishlist(testUser.uid))
          .thenAnswer(
        (_) => Future.value(initialWishlist), // empty Wishlist
      );
      when(() => remoteWishlistRepository.setWishlist(
          testUser.uid, expectedWishlist)).thenAnswer(
        (_) => Future.value(),
      );
      // run
      await wishlistService.removeWishlistProduct(WishlistItem(productId: '1'));
      // verify
      verifyNever(
        () => localWishlistRepository.setWishlist(any()),
      );
      verify(
        () => remoteWishlistRepository.setWishlist(
            testUser.uid, expectedWishlist),
      ).called(1);
    });
  });

  group('removeWishlistProductById', () {
    test('null user, removes a product from local  Wishlist', () async {
      // setup
      const initialWishlist = Wishlist({'0': false, '1': true});
      const expectedWishlist = Wishlist({'0': false});
      final wishlistService = makeWishlistService();
      when(() => authRepository.currentUser).thenReturn(null); // null user
      when(() => localWishlistRepository.fetchWishlist()).thenAnswer(
        (_) => Future.value(initialWishlist), // empty Wishlist
      );
      when(() => localWishlistRepository.setWishlist(expectedWishlist))
          .thenAnswer(
        (_) => Future.value(),
      );
      // run
      await wishlistService.removeWishlistProductById('1');

      // verify
      verify(
        () => localWishlistRepository.setWishlist(expectedWishlist),
      ).called(1);
      verifyNever(
        () => remoteWishlistRepository.setWishlist(any(), any()),
      );
    });

    test('non-null user, adds item to remote Wishlist', () async {
      // setup
      const initialWishlist = Wishlist({'0': false, '1': true});
      const expectedWishlist = Wishlist({'0': false});
      final wishlistService = makeWishlistService();
      when(() => authRepository.currentUser).thenReturn(testUser); // null user
      when(() => remoteWishlistRepository.fetchWishlist(testUser.uid))
          .thenAnswer(
        (_) => Future.value(initialWishlist), // empty Wishlist
      );
      when(() => remoteWishlistRepository.setWishlist(
          testUser.uid, expectedWishlist)).thenAnswer(
        (_) => Future.value(),
      );
      // run
      await wishlistService.removeWishlistProductById('1');
      // verify
      verifyNever(
        () => localWishlistRepository.setWishlist(any()),
      );
      verify(
        () => remoteWishlistRepository.setWishlist(
            testUser.uid, expectedWishlist),
      ).called(1);
    });
  });
}

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/application/cart_service.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/features/wishlist/data/local/local_wishlist_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/data/remote/remote_wishlist_repository.dart';

import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

class MockRemoteCartRepository extends Mock implements RemoteCartRepository {}

class MockLocalCartRepository extends Mock implements LocalCartRepository {}

class MockCartService extends Mock implements CartService {}

class MockRemoteWishlistRepository extends Mock
    implements RemoteWishlistRepository {}

class MockLocalWishlistRepository extends Mock
    implements LocalWishlistRepository {}

class MockWishlistService extends Mock implements WishlistService {}

class MockProductsRepository extends Mock implements FakeProductsRepository {}

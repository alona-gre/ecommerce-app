import 'dart:math';

import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/local/local_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/data/remote/remote_cart_repository.dart';
import 'package:ecommerce_app/src/features/cart/domain/cart.dart';
import 'package:ecommerce_app/src/features/cart/domain/item.dart';
import 'package:ecommerce_app/src/features/cart/domain/mutable_cart.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CartService {
  final Ref ref;

  CartService({required this.ref});

  /// fetch the Cart from remote or local repository
  /// depending on the user auth state
  Future<Cart> _fetchCart() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteCartRepositoryProvider).fetchCart(user.uid);
    } else {
      return ref.read(localCartRepositoryProvider).fetchCart();
    }
  }

  /// set the Cart to remote or local repository
  /// depending on the user auth state
  Future<void> _setCart(Cart cart) {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteCartRepositoryProvider).setCart(user.uid, cart);
    } else {
      return ref.read(localCartRepositoryProvider).setCart(cart);
    }
  }

  /// sets an Item to remote or local repository
  /// depending on the user auth state
  Future<void> setItem(Item item) async {
    final cart = await _fetchCart();
    final updatedCart = cart.setItem(item);
    await _setCart(updatedCart);
  }

  /// adds an Item to remote or local repository
  /// depending on the user auth state
  Future<void> addItem(Item item) async {
    final cart = await _fetchCart();
    final updatedCart = cart.addItem(item);
    await _setCart(updatedCart);
  }

  /// removes an Item from remote or local repository
  /// depending on the user auth state
  Future<void> removeItemById(ProductID productId) async {
    final cart = await _fetchCart();
    final updatedCart = cart.removeItemById(productId);
    await _setCart(updatedCart);
  }
}

final cartServiceProvider = Provider<CartService>((ref) {
  return CartService(
    ref: ref,
  );
});

final cartProvider = StreamProvider<Cart>(
  (ref) {
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      return ref.read(remoteCartRepositoryProvider).watchCart(user.uid);
    } else {
      return ref.read(localCartRepositoryProvider).watchCart();
    }
  },
);

final cartItemsCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).maybeMap(
        data: (cart) => cart.value.items.length,
        orElse: () => 0,
      );
});

final cartTotalProvider = Provider.autoDispose<double>((ref) {
  /// We watch two providers here: cartProvider (to get the current cart)
  /// and productsListStreamProvider (to get the price of the products)
  final cart = ref.watch(cartProvider).value ?? const Cart();
  final productsList = ref.watch(productsListStreamProvider).value ?? [];
  if (cart.items.isNotEmpty && productsList.isNotEmpty) {
    var total = 0.0;
    for (var item in cart.items.entries) {
      final product =
          productsList.firstWhere((product) => product.id == item.key);
      total += product.price * item.value;
    }
    return total;
  } else {
    return 0.0;
  }
});

final itemAvailableQuantityProvider = Provider.autoDispose.family<int, Product>(
  (ref, product) {
    final cart = ref.watch(cartProvider).value;
    if (cart != null) {
      // get the current quantity for the given product in the cart
      final quantity = cart.items[product.id] ?? 0;
      // subtract it from the available quantity
      return max(0, product.availableQuantity - quantity);
    } else {
      return product.availableQuantity;
    }
  },
);

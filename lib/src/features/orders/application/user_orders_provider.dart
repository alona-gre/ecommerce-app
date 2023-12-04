import 'package:ecommerce_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:ecommerce_app/src/features/orders/data/fake_orders_repository.dart';
import 'package:ecommerce_app/src/features/orders/domain/order.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Watch the list of user orders
/// NOTE: Only watch this provider if the user is signed in.
final userOrdersProvider = StreamProvider.autoDispose<List<Order>>((ref) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    final ordersRepository = ref.watch(ordersRepositoryProvider);
    return ordersRepository.watchUserOrders(user.uid);
  } else {
    // If the user is null, just return an empty screen.
    return const Stream.empty();
  }
});

/// Check if a product was previously purchased by the user
/// NOTE: Only watch this provider if the user is signed in.
final matchingUserOrdersProvider =
    StreamProvider.autoDispose.family<List<Order>, ProductID>((ref, productId) {
  final user = ref.watch(authStateChangesProvider).value;
  if (user != null) {
    return ref
        .watch(ordersRepositoryProvider)
        .watchUserOrders(user.uid, productId: productId);
  } else {
    // If the user is null, return an empty list (no orders)
    return Stream.value([]);
  }
});

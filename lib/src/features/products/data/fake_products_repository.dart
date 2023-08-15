import 'dart:async';

import 'package:ecommerce_app/src/constants/test_products.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/product.dart';

class FakeProductsRepository {
  final bool hasDelay;
  final List<Product> _products = kTestProducts;

  FakeProductsRepository({this.hasDelay = true});

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _getProduct(_products, id);
  }

  Future<List<Product>> fetchProductsList() async {
    await delay(hasDelay);
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() async* {
    await delay(hasDelay);
    yield _products;
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList().map(
      (products) => _getProduct(products, id),
    );
  }

  static Product? _getProduct(List<Product> products, String id) {
    try {
      return products.firstWhere((prod) => prod.id == id);
    } catch (e) {
      return null;
    }
  }
}

final productsRepositoryProvider = Provider<FakeProductsRepository>((ref) {
  return FakeProductsRepository();
});

final productsListStreamProvider =
    StreamProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.watchProductsList();
});

final productsListFutureProvider =
    FutureProvider.autoDispose<List<Product>>((ref) {
  final productsRepository = ref.watch(productsRepositoryProvider);
  return productsRepository.fetchProductsList();
});

final productProvider = StreamProvider.autoDispose.family<Product?, String>(
  (ref, id) {
    final productsRepository = ref.watch(productsRepositoryProvider);
    return productsRepository.watchProduct(id);
  },
);

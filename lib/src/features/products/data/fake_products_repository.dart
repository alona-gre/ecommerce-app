import 'package:ecommerce_app/src/constants/test_products.dart';

import '../domain/product.dart';

class FakeProductsRepository {
  FakeProductsRepository._();
  static FakeProductsRepository instance = FakeProductsRepository._();

  final List<Product> _products = kTestProducts;

  List<Product> getProductsList() {
    return _products;
  }

  Product? getProduct(String id) {
    return _products.firstWhere(
      (product) => product.id == id,
    );
  }

  Future<List<Product>> fetchProducts() {
    return Future.value(_products);
  }

  Stream<List<Product>> watchProductsList() {
    return Stream.value(_products);
  }

  Stream<Product?> watchProduct(String id) {
    return watchProductsList().map(
      (products) => products.firstWhere((prod) => prod.id == id),
    );
  }
}

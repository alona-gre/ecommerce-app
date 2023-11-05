// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:ecommerce_app/src/features/products/domain/product.dart';

class WishlistItem {
  final ProductID productId;
  final bool isFavorite;

  WishlistItem({required this.productId, this.isFavorite = false});

  @override
  bool operator ==(covariant WishlistItem other) {
    if (identical(this, other)) return true;

    return other.productId == productId && other.isFavorite == isFavorite;
  }

  @override
  int get hashCode => productId.hashCode ^ isFavorite.hashCode;
}

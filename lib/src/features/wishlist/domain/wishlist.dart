// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist_item.dart';

/// Model class representing the wishlist contents.
class Wishlist {
  const Wishlist([this.items = const {}]);

  /// All the items in the wishlist, where:
  /// - key: product ID
  /// - value: bool (whether it is favorite)
  final Map<ProductID, bool> items;

  @override
  String toString() => 'Wishlist(items: $items)';

  Map<String, dynamic> toMap() {
    return {
      'items': items,
    };
  }

  factory Wishlist.fromMap(Map<String, dynamic> map) {
    return Wishlist(
      Map<ProductID, bool>.from(map['items']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Wishlist.fromJson(String source) =>
      Wishlist.fromMap(json.decode(source));

  @override
  bool operator ==(covariant Wishlist other) {
    if (identical(this, other)) return true;

    return mapEquals(other.items, items);
  }

  @override
  int get hashCode => items.hashCode;
}

extension WishlistItems on Wishlist {
  /// this method converts a Map of items into a List of items
  /// used to display all the items of the Wishlist
  List<WishlistItem> toWishlistItemsList() {
    return items.entries.map((entry) {
      return WishlistItem(
        productId: entry.key,
        isFavorite: entry.value,
      );
    }).toList();
  }
}

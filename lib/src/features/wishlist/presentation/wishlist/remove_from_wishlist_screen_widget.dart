import 'package:ecommerce_app/src/common_widgets/favorite_button.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/wishlist/Wishlist_screen_controller.dart';
import 'package:ecommerce_app/src/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that shows an [Icon] on top of the product image on the home page,
/// and next to the product title on teh ProductScreen.
/// Used to add a product to wishlist.
class RemoveFromWishlistScreenWidget extends ConsumerWidget {
  final Product product;
  const RemoveFromWishlistScreenWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wishlistScreenControllerProvider);
    final isFavorite = ref.watch(isFavoriteProvider(product.id));

    return FavoriteButton(
      isLoading: state.isLoading,
      isFavorite: isFavorite,
      onPressed: state.isLoading
          ? null
          : () {
              ref
                  .read(wishlistScreenControllerProvider.notifier)
                  .removeFromWishlistScreenById(product.id);

              state.copyWithPrevious(state).hasError
                  ? null
                  : showSnackBar(context, 'Removed from Wishlist');
            },
    );
  }
}

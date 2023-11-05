import 'package:ecommerce_app/src/common_widgets/favorite_button.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlistItem.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/add_to_wishlist/add_to_wishlist_controller.dart';
import 'package:ecommerce_app/src/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that shows an [Icon] on top of the product image on the home page,
/// and next to the product title on teh ProductScreen.
/// Used to add a product to wishlist.
class AddToWishlistWidget extends ConsumerWidget {
  final Product product;
  const AddToWishlistWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addToWishlistControllerProvider);
    // debugPrint(state.toString());
    final isFavorite = ref.watch(isFavoriteProvider(product.id));

    return FavoriteButton(
      // isLoading: state.isLoading,
      isFavorite: isFavorite,
      onPressed: !isFavorite && !state.isLoading
          ? () {
              ref
                  .read(addToWishlistControllerProvider.notifier)
                  .addProductToWishlist(
                    WishlistItem(
                      productId: product.id,
                    ),
                  );
              !state.hasError && !state.isLoading
                  ? showSnackBar(context, 'Added to Wishlist')
                  : null;
            }
          : () {
              ref
                  .read(addToWishlistControllerProvider.notifier)
                  .removeProductFromWishlist(
                    WishlistItem(
                      productId: product.id,
                    ),
                  );

              !state.hasError && !state.isLoading
                  ? showSnackBar(context, 'Removed from Wishlist')
                  : null;
            },
    );
  }
}

import 'package:ecommerce_app/src/common_widgets/favorite_button.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist_item.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/update_wishlist_from_home_screen/update_wishlist_from_home_screen_controller.dart';
import 'package:ecommerce_app/src/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// A widget that shows an [Icon] on top of the product image on the home page,
/// and next to the product title on teh ProductScreen.
/// Used to add a product to wishlist.
class UpdateWishlistFromHomeScreenWidget extends ConsumerWidget {
  final Product product;
  const UpdateWishlistFromHomeScreenWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(updateWishlistFromHomeScreenControllerProvider);
    // debugPrint(state.toString());
    final isFavorite = ref.watch(isFavoriteProvider(product.id));

    return FavoriteButton(
      isLoading: state.isLoading,
      isFavorite: isFavorite,
      onPressed: !isFavorite && !state.isLoading
          ? () {
              ref
                  .read(updateWishlistFromHomeScreenControllerProvider.notifier)
                  .addProductToWishlistFromHomeScreen(
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
                  .read(updateWishlistFromHomeScreenControllerProvider.notifier)
                  .removeProductFromWishlistFromHomeScreen(product.id);

              !state.hasError && !state.isLoading
                  ? showSnackBar(context, 'Removed from Wishlist')
                  : null;
            },
    );
  }
}

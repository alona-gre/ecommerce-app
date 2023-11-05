import 'package:ecommerce_app/src/common_widgets/error_message_widget.dart';
import 'package:ecommerce_app/src/common_widgets/shimmer_loading_cart_items_list.dart';
import 'package:ecommerce_app/src/features/products/data/fake_products_repository.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlistItem.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/wishlist/remove_from_wishlist_screen_widget.dart';
import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:ecommerce_app/src/utils/currency_formatter.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/src/common_widgets/custom_image.dart';
import 'package:ecommerce_app/src/common_widgets/responsive_two_column_layout.dart';
import 'package:ecommerce_app/src/constants/app_sizes.dart';
import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Shows a wishlist item (or loading/error UI if needed)
class WishlistItemWidget extends ConsumerWidget {
  const WishlistItemWidget({
    super.key,
    required this.wishlistItem,
    required this.itemIndex,
  });
  final WishlistItem wishlistItem;
  final int itemIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productValue = ref.watch(productProvider(wishlistItem.productId));
    return productValue.when(
        data: (product) => InkWell(
              onTap: () => context.pushNamed(
                AppRoute.product.name,
                pathParameters: {'id': product.id},
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: Sizes.p8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(Sizes.p16),
                    child: WishlistItemContents(
                      product: product!,
                      wishlistItem: wishlistItem,
                      itemIndex: itemIndex,
                    ),
                  ),
                ),
              ),
            ),
        error: (e, st) => Center(child: ErrorMessageWidget(e.toString())),
        loading: () =>
            const ShimmerLoadingCartItem(height: 220.0, margin: 16.0));
  }
}

/// Shows a wishlist item for a given product
class WishlistItemContents extends ConsumerWidget {
  const WishlistItemContents({
    super.key,
    required this.product,
    required this.wishlistItem,
    required this.itemIndex,
  });
  final Product product;
  final WishlistItem wishlistItem;
  final int itemIndex;

  // * Keys for testing using find.byKey()
  static Key deleteKey(int index) => Key('delete-$index');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceFormatted =
        ref.watch(currencyFormatterProvider).format(product.price);
    return ResponsiveTwoColumnLayout(
      startFlex: 1,
      endFlex: 2,
      breakpoint: 320,
      startContent: CustomImage(imageUrl: product.imageUrl),
      spacing: Sizes.p24,
      endContent: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(product.title,
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              RemoveFromWishlistScreenWidget(product: product),
            ],
          ),
          gapH24,
          Text(priceFormatted,
              style: Theme.of(context).textTheme.headlineSmall),
          gapH24,
        ],
      ),
    );
  }
}

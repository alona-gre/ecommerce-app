import 'package:ecommerce_app/src/common_widgets/async_value_widget.dart';
import 'package:ecommerce_app/src/common_widgets/primary_button.dart';
import 'package:ecommerce_app/src/features/wishlist/application/wishlist_service.dart';
import 'package:ecommerce_app/src/features/wishlist/domain/wishlist.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/wishlist/Wishlist_screen_controller.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/wishlist/wishlist_item.dart';
import 'package:ecommerce_app/src/features/wishlist/presentation/wishlist/wishlist_items_builder.dart';
import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:ecommerce_app/src/routing/app_router.dart';
import 'package:ecommerce_app/src/utils/async_value_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Wishlist screen showing the items in the wishlist (editable)
/// with a button to go to Cart.
class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue<void>>(
      wishlistScreenControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist'.hardcoded),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final wishlistValue = ref.watch(wishlistProvider);
          return AsyncValueWidget(
            value: wishlistValue,
            data: (wishlist) => WishlistItemsBuilder(
              items: wishlist.toWishlistItemsList(),
              itemBuilder: (_, item, index) => WishlistItemWidget(
                wishlistItem: item,
                itemIndex: index,
              ),
              ctaBuilder: (_) => PrimaryButton(
                text: 'Go to Cart'.hardcoded,
                //isLoading: state.isLoading,
                onPressed: () => context.goNamed(AppRoute.cart.name),
              ),
            ),
          );
        },
      ),
    );
  }
}

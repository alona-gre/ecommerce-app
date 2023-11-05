import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    this.isLoading = false,
    this.onPressed,
    required this.isFavorite,
  });

  final bool isLoading;
  final bool isFavorite;
  final VoidCallback? onPressed;

  // * Keys for testing using find.byKey()
  static const addToWishlistButtonKey = Key('addToWishlistButton');
  static const removeFromWishlistButtonKey = Key('removeFromWishlistButton');

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: isLoading
            ? const CircularProgressIndicator()
            : IconButton(
                icon: isFavorite
                    ? const Icon(
                        key: removeFromWishlistButtonKey,
                        Icons.favorite,
                      )
                    : const Icon(
                        key: addToWishlistButtonKey,
                        Icons.favorite_border_outlined),
                onPressed: onPressed,
              ));
  }
}

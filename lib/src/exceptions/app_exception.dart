import 'package:ecommerce_app/src/localization/string_hardcoded.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_exception.freezed.dart';

@freezed
class AppException with _$AppException {
  // Auth
  const factory AppException.emailAlreadyInUse() = EmailAlreadyInUse;
  const factory AppException.weakPassword() = WeakPassword;
  const factory AppException.wrongPassword() = WrongPassword;
  const factory AppException.userNotFound() = UserNotFound;

  // Cart
  const factory AppException.cartSyncFailed() = CartSyncFailed;
  // Wishlist
  const factory AppException.wishlistSyncFailed() = WishlistSyncFailed;
  // Checkout
  const factory AppException.paymentFailureEmptyCart() =
      PaymentFailureEmptyCart;
  // Orders
  const factory AppException.parseOrderFailure(String status) =
      ParseOrderFailure;
}

class AppExceptionData {
  final String code;
  final String message;

  AppExceptionData(this.code, this.message);

  @override
  String toString() => 'AppExceptionData(code: $code, message: $message)';
}

extension AppExceptionDetails on AppException {
  AppExceptionData get details {
    return when(
      emailAlreadyInUse: () => AppExceptionData(
          'email-already-in-use', 'Email already in use'.hardcoded),
      weakPassword: () =>
          AppExceptionData('weak-password', 'Password is too weak'.hardcoded),
      wrongPassword: () =>
          AppExceptionData('wrong-password', 'Wrong password'.hardcoded),
      userNotFound: () =>
          AppExceptionData('user-not-found', 'User not found'.hardcoded),
      cartSyncFailed: () => AppExceptionData('cart-sync-failed',
          'An error occurred while updating a shopping cart'.hardcoded),
      wishlistSyncFailed: () => AppExceptionData('wishlist-sync-failed',
          'An error occurred while updating a wishlist'.hardcoded),
      paymentFailureEmptyCart: () => AppExceptionData(
          'payment-failure-empty-cart', 'Payment Failure empty cart'.hardcoded),
      parseOrderFailure: (status) => AppExceptionData('parse-order-value',
          'Could not parse order status: $status'.hardcoded),
    );
  }
}

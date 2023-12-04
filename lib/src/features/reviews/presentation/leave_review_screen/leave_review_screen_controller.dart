import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/application/reviews_service.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/utils/current_date_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaveReviewScreenController extends StateNotifier<AsyncValue<void>> {
  final ReviewsService reviewsService;
  final DateTime Function() currentDateBuilder;
  LeaveReviewScreenController({
    required this.reviewsService,
    required this.currentDateBuilder,
  }) : super(const AsyncData(null));

  Future<void> submitReview({
    required Review? previousReview,
    required ProductID productId,
    required double rating,
    required String comment,
    required void Function() onSuccess,
  }) async {
    if (previousReview == null ||
        previousReview.comment != comment ||
        previousReview.rating != rating) {
      final review = Review(
        rating: rating,
        comment: comment,
        date: currentDateBuilder(),
      );
      state = const AsyncLoading();
      final newState = await AsyncValue.guard(() => reviewsService.submitReview(
            productId: productId,
            review: review,
          ));
      if (mounted) {
        // * only set the state if the controller is not disposed
        state = newState;
        if (state.hasError == false) {
          onSuccess();
        }
      }
    } else {
      onSuccess();
    }
  }
}

final leaveReviewScreenControllerProvider = StateNotifierProvider.autoDispose<
    LeaveReviewScreenController, AsyncValue<void>>((ref) {
  return LeaveReviewScreenController(
    currentDateBuilder: ref.watch(currentDateBuilderProvider),
    reviewsService: ref.watch(
      reviewsServiceProvider,
    ),
  );
});

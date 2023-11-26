import 'package:ecommerce_app/src/features/products/domain/product.dart';
import 'package:ecommerce_app/src/features/reviews/domain/review.dart';
import 'package:ecommerce_app/src/utils/delay.dart';
import 'package:ecommerce_app/src/utils/in_memory_store.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FakeReviewsRepository {
  final bool addDelay;

  FakeReviewsRepository({this.addDelay = true});

  /// Reviews Store, where:
  /// - key: [ProductID]
  /// - value: a map of [Review] values per each user ID
  final _reviews = InMemoryStore<Map<ProductID, Map<String, Review>>>({});

  /// Single review for a given product given by a specific user
  /// Emits non-null values if the user has reviewed the product
  Stream<Review?> watchUserReview(ProductID id, String uid) {
    return _reviews.stream.map((reviewsData) {
      // access nested maps by productId, then uid
      return reviewsData[id]?[uid];
    });
  }

  /// Single review for a given product given by a specific user
  /// Returns a non-null value if the user has reviewed the product
  Future<Review?> fetchUserReview(ProductID id, String uid) async {
    await delay(addDelay);
    // access nested maps by productId, then uid
    return _reviews.value[id]?[uid];
  }

  /// All reviews for a given product from all users
  Stream<List<Review>> watchReviews(ProductID productId) {
    return _reviews.stream.map((reviewsData) {
      final reviews = reviewsData[productId];
      if (reviews == null) {
        return [];
      } else {
        return reviews.values.toList();
      }
    });
  }

  /// Single review for a given product given by a specific user
  /// Returns a non-null value if the user has reviewed the product
  Future<List<Review>> fetchReviews(ProductID productId) {
    // access maps with reviews by productId
    final reviews = _reviews.value[productId];
    if (reviews == null) {
      return Future.value([]);
    } else {
      return Future.value(reviews.values.toList());
    }
  }

  /// Submit a new review or update an existing review for a given product
  /// @param productId the product identifier
  /// @param uid the identifier of the user who is leaving the review
  /// @param review a [Review] object with the review information
  Future<void> setReview({
    required ProductID productId,
    required String uid,
    required Review review,
  }) async {
    await delay(addDelay);
    final allReviews = _reviews.value;
    final reviews = allReviews[productId];
    if (reviews != null) {
      // reviews already exist: set the new review for the given uid
      reviews[uid] = review;
    } else {
      // reviews do not exist: create a new map with the new review
      allReviews[productId] = {uid: review};
    }
    _reviews.value = allReviews;
  }
}

final reviewsRepositoryProvider = Provider<FakeReviewsRepository>(
  ((ref) {
    return FakeReviewsRepository();
  }),
);

final productReviewsProvider = StreamProvider.autoDispose
    .family<List<Review>, ProductID>((ref, productId) {
  return ref.watch(reviewsRepositoryProvider).watchReviews(productId);
});

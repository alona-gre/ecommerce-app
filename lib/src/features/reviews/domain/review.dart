// ignore_for_file: public_member_api_docs, sort_constructors_first
/// Product review data
class Review {
  const Review({
    required this.rating,
    required this.comment,
    required this.date,
  });
  final double rating; // from 1 to 5
  final String comment;
  final DateTime date;

  @override
  bool operator ==(covariant Review other) {
    if (identical(this, other)) return true;

    return other.rating == rating &&
        other.comment == comment &&
        other.date == date;
  }

  @override
  int get hashCode => rating.hashCode ^ comment.hashCode ^ date.hashCode;

  @override
  String toString() =>
      'Review(rating: $rating, comment: $comment, date: $date)';
}

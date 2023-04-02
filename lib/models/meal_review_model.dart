class MealReviewModel {
  final String name;
  final String date;
  final String review;
  final double rate;

  MealReviewModel(
      {required this.name,
      required this.date,
      required this.review,
      required this.rate});

  factory MealReviewModel.fromJson(Map<String, dynamic> map) {
    return MealReviewModel(
      name: map["userID"],
      date: map["date"],
      review: map["review"],
      rate: double.parse(map["yourRate"].toString()),
    );
  }
}

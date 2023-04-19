import '../core/constants.dart';

class MealReviewModel {
  final String name;
  final String date;
  final String review;
  final String image;
  final double rate;
  

  MealReviewModel(
      {required this.name,
      required this.date,
      required this.review,
      required this.image,
      required this.rate});

  factory MealReviewModel.fromJson(Map<String, dynamic> map) {
    return MealReviewModel(
      name: map["userID"],
      date: map["date"],
      review: map["review"],
       image: "$IMAGE_PATH_URL${map["image"]}",
      rate: double.parse(map["yourRate"].toString()),
    );
  }
}

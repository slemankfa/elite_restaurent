import '../core/constants.dart';

class ResturantReviewModel {
  final String name;
  final String image;
  final String date;
  final String review;
  final double rate;

  ResturantReviewModel(
      {required this.name,
      required this.image, 
      required this.date,
      required this.review,
      required this.rate});

  factory ResturantReviewModel.fromJson(Map<String, dynamic> map) {
    return ResturantReviewModel(
      name: map["userID"],
      date: map["date"],
      image: "$IMAGE_PATH_URL${map["image"]}",
      review: map["review"],
      rate: double.parse(map["agvRating"].toString()),
    );
  }
}

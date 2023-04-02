class ResturantReviewModel {
  final String name;
  final String date;
  final String review;
  final double rate;

  ResturantReviewModel(
      {required this.name,
      required this.date,
      required this.review,
      required this.rate});

  factory ResturantReviewModel.fromJson(Map<String, dynamic> map) {
    return ResturantReviewModel(
      name: map["userID"],
      date: map["date"],
      review: map["review"],
      rate: double.parse(map["goodTreatment"].toString()),
    );
  }
}

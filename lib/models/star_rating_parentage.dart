class StarRatingParcentage {
  final int starRate;
  final double starPercentage;

  StarRatingParcentage({required this.starRate, required this.starPercentage});

  factory StarRatingParcentage.fromJson(Map<String, dynamic> map) {
    return StarRatingParcentage(
        starRate: map["yourRate"],
        starPercentage: double.parse(map["percentage"].toString()));
    // starPercentage: double.parse(map["percentage"].toString()));
  }
}

class StarRatingParcentage {
  final double starRate;
  final double starPercentage;

  StarRatingParcentage({required this.starRate, required this.starPercentage});

  factory StarRatingParcentage.fromJson(Map<String, dynamic> map) {
    return StarRatingParcentage(
        starRate: double.parse(map["yourRate"].toString()),
        starPercentage: double.parse(map["percentage"].toString()).roundToDouble());
  }
}

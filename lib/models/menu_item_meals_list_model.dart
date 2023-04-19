import 'package:easy_localization/easy_localization.dart';
import 'package:elite/models/star_rating_parentage.dart';
import 'package:flutter/cupertino.dart';

import '../core/constants.dart';

class MenuItemMealsListModel {
  final String mealId;
  final String mealName;
  final String mealImage;
  final String mealdescrpation;
  final String? averageRating;
  final String? totalRating;
  final List<StarRatingParcentage> starRatingParcentageList;

  MenuItemMealsListModel({
    required this.mealId,
    required this.mealName,
    required this.mealImage,
    required this.mealdescrpation,
    required this.averageRating,
    this.starRatingParcentageList = const [],
    required this.totalRating,
  });

  factory MenuItemMealsListModel.fromJson(
      Map<String, dynamic> map, BuildContext context) {
    List<StarRatingParcentage> tempStarRatingParcentageList = [];

    if (map["rating"] != null) {
      List? loadedratings = map["rating"] as List;
      for (var ratingItem in loadedratings) {
        tempStarRatingParcentageList
            .add(StarRatingParcentage.fromJson(ratingItem));
      }
    }
    return MenuItemMealsListModel(
        averageRating: map["agvRating"].toString(),
        starRatingParcentageList:
            tempStarRatingParcentageList.reversed.toList(),
        totalRating: map["maxRating"].toString(),
        mealId: map["itemID"].toString(),
        mealName: context.locale.toString() == "en"
            ? map["itemNameE"]
            : map["itemNameA"],
        mealImage: "$IMAGE_PATH_URL${map["mainImage"]}",
        mealdescrpation: map["itemComponents"].toString());
  }
}

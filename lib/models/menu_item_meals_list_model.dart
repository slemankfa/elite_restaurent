import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:elite/models/side_dishes.dart';
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
  final List<SideMealDishes> sideDhshes;
  final List<String> mealImages;

  Random random = Random();

  MenuItemMealsListModel({
    required this.mealId,
    required this.mealName,
    required this.mealImage,
    required this.mealImages,
    required this.mealdescrpation,
    required this.sideDhshes,
    required this.averageRating,
    this.starRatingParcentageList = const [],
    required this.totalRating,
  });

  factory MenuItemMealsListModel.fromJson(
      Map<String, dynamic> map, BuildContext context) {
    List<StarRatingParcentage> tempStarRatingParcentageList = [];
    List<String> tempImages = [];
    final List<SideMealDishes> tempSideDhshes= [];
    //

    if (map["extras"] != null) {
      List? loadedExtras = map["extras"] as List;
      for (var extraMap in loadedExtras) {
        tempSideDhshes.add(SideMealDishes.fromJson(extraMap));
      }
    }

    if (map["images"] != null) {
      List? loadedIamages = map["images"] as List;
      for (var imageMap in loadedIamages) {
        tempImages.add("$IMAGE_PATH_URL${imageMap["itemInages"]}");
      }
    }
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
        mealImages: tempImages,
        mealImage: "$IMAGE_PATH_URL${map["mainImage"]}",
        mealdescrpation: map["itemComponents"].toString(),
        sideDhshes: tempSideDhshes);
  }
}

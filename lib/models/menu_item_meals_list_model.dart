import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import '../core/constants.dart';

class MenuItemMealsListModel {
  final String mealId;
  final String mealName;
  final String mealImage;

  MenuItemMealsListModel({
    required this.mealId,
    required this.mealName,
    required this.mealImage,
  });

  factory MenuItemMealsListModel.fromJson(
      Map<String, dynamic> map, BuildContext context) {
    return MenuItemMealsListModel(
        mealId: map["itemID"].toString(),
        mealName: context.locale.toString() == "en"
            ? map["itemNameE"]
            : map["itemNameA"],
        mealImage: "${IMAGE_PATH_URL}${map["mainImage"]}");
  }
}

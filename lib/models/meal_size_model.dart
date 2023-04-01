import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MealSizeModel {
  final String id;
  final String name;
  final double price;

  MealSizeModel({
    required this.id,
    required this.name,
    required this.price,
  });

  factory MealSizeModel.fromJson(
      Map<String, dynamic> map, BuildContext context) {
    return MealSizeModel(
        id: map["sizeID"].toString(),
        name: context.locale.toString() == "en"
            ? map["sizeNameE"]
            : map["sizeNameA"],
        price: double.parse(map["price"].toString()));
  }
}

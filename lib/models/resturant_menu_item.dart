import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';

class ResturantMenuItemModel {
  final String id;
  final String name;
  final String image;

  ResturantMenuItemModel({
    required this.id,
    required this.name,
    required this.image,
  });

  factory ResturantMenuItemModel.fromJson(
      Map<String, dynamic> map, BuildContext context) {
    return ResturantMenuItemModel(
        id: map["catID"].toString(),
        name: context.locale.toString() == "en"
            ? map["catNameE"]
            : map["catNameA"],
        image: "${IMAGE_PATH_URL}${map["catImage"]}");
  }
}

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CityAreaModel {
  final String id;
  final String name;

  CityAreaModel({
    required this.id,
    required this.name,
  });

  factory CityAreaModel.fromJson(Map<String, dynamic> map, BuildContext context) {
    return CityAreaModel(
      id: map["areaID"].toString(),
      name: context.locale.toString() == "en"
          ? map["areaNameE"]
          : map["areaNameA"],
    );
  }
}

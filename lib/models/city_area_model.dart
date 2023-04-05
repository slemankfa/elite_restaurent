import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CityRegionModel {
  final String id;
  final String name;

  CityRegionModel({
    required this.id,
    required this.name,
  });

  factory CityRegionModel.fromJson(Map<String, dynamic> map, BuildContext context) {
    return CityRegionModel(
      id: map["areaID"].toString(),
      name: context.locale.toString() == "en"
          ? map["areaNameE"]
          : map["areaNameA"],
    );
  }
}

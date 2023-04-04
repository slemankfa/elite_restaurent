import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class CityModel {
  final String id;
  final String name;

  CityModel({
    required this.id,
    required this.name,
  });

  factory CityModel.fromJson(Map<String, dynamic> map, BuildContext context) {
    return CityModel(
      id: map["cityID"].toString(),
      name: context.locale.toString() == "en"
          ? map["cityNameE"]
          : map["cityNameA"],
    );
  }
}

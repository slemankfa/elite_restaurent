import 'package:easy_localization/easy_localization.dart';
import 'package:elite/core/constants.dart';
import 'package:flutter/material.dart';

class ResturantModel {
  final String name;
  final String id;
  final String logo;
  final String backGroundImage;
  final String traficStatus;
  final String openStatus;
  final String cousineType;
  final double? averageRating;
  final int? totalRating;
  ResurantWorkingDaysModel? resurantWorkingDaysModel;

  ResturantModel(
      {required this.name,
      required this.id,
      required this.logo,
      required this.backGroundImage,
      required this.traficStatus,
      required this.openStatus,
      required this.cousineType,
      this.averageRating,
      this.resurantWorkingDaysModel,
      this.totalRating});

  factory ResturantModel.fromJson(
      Map<String, dynamic> map, BuildContext context) {
    // print(context.locale.toString());
    return ResturantModel(
      name: context.locale.toString() == "en"
          ? map["resturantNameE"]
          : map["resturantNameA"],
      id: map["resturantID"].toString(),
      logo: "$IMAGE_PATH_URL${map["resturantLogo"]}",
      backGroundImage:
          "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
      traficStatus: "Crowded",
      openStatus: "OPEN",
      cousineType: map["restaurantTypeID"].toString(),
    );
  }
}

class ResurantWorkingDaysModel {
  final String? sundayFrom;
  final String? sundayTo;
  final String? monFrmTime;
  final String? monToTime;
  final String? tuesdayFrmTime;
  final String? tuesdayToTime;
  final String? wednesdayFrmTime;
  final String? wednesdayToTime;
  final String? thursdayFrmTime;
  final String? thursdayToTime;
  final String? fridayFrmTime;
  final String? fridayToTime;
  final String? saturdayFrmTime;
  final String? saturdayToTime;

  ResurantWorkingDaysModel(
      {required this.sundayFrom,
      required this.sundayTo,
      required this.monFrmTime,
      required this.monToTime,
      required this.tuesdayFrmTime,
      required this.tuesdayToTime,
      required this.wednesdayFrmTime,
      required this.wednesdayToTime,
      required this.thursdayFrmTime,
      required this.thursdayToTime,
      required this.fridayFrmTime,
      required this.fridayToTime,
      required this.saturdayFrmTime,
      required this.saturdayToTime});

  factory ResurantWorkingDaysModel.fromJson(Map<String, dynamic> map) {
    return ResurantWorkingDaysModel(
      sundayFrom: map["isSunday"] == true ? map["sunFrmTime"] : null,
      sundayTo: map["isSunday"] == true ? map["sunToTime"] : null,
      monFrmTime: map["isMonday"] == true ? map["monFrmTime"] : null,
      monToTime: map["isMonday"] == true ? map["monToTime"] : null,
      tuesdayFrmTime: map["isTuesday"] == true ? map["tuesdayFrmTime"] : null,
      tuesdayToTime: map["isTuesday"] == true ? map["tuesdayToTime"] : null,
      wednesdayFrmTime:
          map["isWednesday"] == true ? map["wednesdayFrmTime"] : null,
      wednesdayToTime:
          map["isWednesday"] == true ? map["wednesdayToTime"] : null,
      thursdayFrmTime:
          map["isThursday"] == true ? map["thursdayFrmTime"] : null,
      thursdayToTime: map["isThursday"] == true ? map["thursdayToTime"] : null,
      fridayFrmTime: map["isFriday"] == true ? map["fridayFrmTime"] : null,
      fridayToTime: map["isFriday"] == true ? map["fridayToTime"] : null,
      saturdayFrmTime:
          map["isSaturday"] == true ? map["saturdayFrmTime"] : null,
      saturdayToTime: map["isSaturday"] == true ? map["saturdayToTime"] : null,
    );
  }
}

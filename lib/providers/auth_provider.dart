import 'package:dio/dio.dart';
import 'package:elite/core/constants.dart';
import 'package:flutter/material.dart';

import '../core/helper_methods.dart';
import '../models/city_area_model.dart';
import '../models/city_model.dart';

class AuthProvider with ChangeNotifier {
  Dio _dio = Dio();
  HelperMethods _helperMethods = HelperMethods();

  Future<List<CityModel>> getCities(
      {required BuildContext context,}) async {
    List<CityModel> tempList = [];

    try {
      // print(employModel.toJson().toString());
      // print(token.toString());
      // return employees;
      final token = await _helperMethods.getToken();
      Response response = await _dio.get(
        "${API_URL}City",
        options: Options(
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": token
          },
          // responseType: ResponseType.json ,
        ),
      );
      // queryParameters: {"country_identifier": countryIdenifier});
      var loadedList = response.data as List;
      for (var cities in loadedList) {
        tempList.add(CityModel.fromJson(cities, context));
      }

      return tempList;
    } on DioError catch (e) {
      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      return tempList;
    }
  }

  Future<List<CityAreaModel>> getCityAreas(
      {required BuildContext context, required String cityIdenifier}) async {
    List<CityAreaModel> tempList = [];

    try {
      // print(employModel.toJson().toString());
      // print(token.toString());
      // return employees;
      final token = await _helperMethods.getToken();
      Response response = await _dio.get(
        "${API_URL}City/GetAreas?City=$cityIdenifier",
        options: Options(
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            // "Authorization": token
          },
          // responseType: ResponseType.json ,
        ),
      );
      // queryParameters: {"country_identifier": countryIdenifier});
      final loadedList = response.data as List;
      for (var cities in loadedList) {
        tempList.add(CityAreaModel.fromJson(cities, context));
      }

      return tempList;
    } on DioError catch (e) {
      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      return tempList;
    }
  }
}

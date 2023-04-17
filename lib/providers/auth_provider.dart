import 'package:dio/dio.dart';
import 'package:elite/core/constants.dart';
import 'package:elite/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/helper_methods.dart';
import '../models/city_area_model.dart';
import '../models/city_model.dart';

class AuthProvider with ChangeNotifier {
  final Dio _dio = Dio();
  final HelperMethods _helperMethods = HelperMethods();



 Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('access_token') && !prefs.containsKey('is_guest')) {
      print("There is no Data");
      return false;
    }
    print("tryAutoLoginMethod");
    return true;
  }

  
  Future<List<CityModel>> getCities({
    required BuildContext context,
  }) async {
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
    } on DioError {
      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      return tempList;
    }
  }

  Future<List<CityRegionModel>> getCityAreas(
      {required BuildContext context, required String cityIdenifier}) async {
    List<CityRegionModel> tempList = [];

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
        tempList.add(CityRegionModel.fromJson(cities, context));
      }

      return tempList;
    } on DioError {
      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      return tempList;
    }
  }

  Future<bool> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      Response loginResponse = await _dio.post("${API_URL}Users/Login",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
            },
          ),
          data: {
            'username': email,
            'password': password,
          });
      print(loginResponse.toString());
      saveAccessTokenlocaly(loginResponse.data["token"]);
      return true;
    } on DioError catch (e) {
      // print(e.toString());
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      // if (e.response != null) {
      //   // print(e.response?.data);
      //   print(e.response?.data["error_messages"]);
      //   print(e.response?.statusCode);
      String errorMessages = "";
      for (var element in e.response?.data["error_messages"]) {
        errorMessages += element + "\n";
      }
      _helperMethods.showErrorDilog(errorText: errorMessages, context: context);

      //   BotToast.showText(text: _errorMessages); //popup a text toast;
      //   // cancel();
      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      return false;
    }
  }

  Future<bool> signUp(
      {required UserModel user,
      required CityModel selectedCity,
      required CityRegionModel selectedRegionCity,
      required BuildContext context}) async {
    try {
      Response loginResponse = await _dio.post("${API_URL}Users/Login",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
            },
          ),
          data: {
            'RoleID': "1",
            'UserName': user.userName,
            'Email': user.email,
            'Password': user.password,
            'Age': "18",
            'Image': user.userImage,
            "SexID": user.userGender,
            "CityID": selectedCity.id,
            "AreaID": selectedRegionCity.id,
          });
      print(loginResponse.toString());
      saveAccessTokenlocaly(loginResponse.data["token"]);
      return true;
    } on DioError catch (e) {
      print(e.toString());
      // The request was made and the server responded with a status code
      // that falls out of the range of 2xx and is also not 304.
      // if (e.response != null) {
      //   // print(e.response?.data);
      //   print(e.response?.data["error_messages"]);
      //   print(e.response?.statusCode);
      // String errorMessages = "";
      // for (var element in e.response?.data["error_messages"]) {
      //   errorMessages += element + "\n";
      // }
      // _helperMethods.showErrorDilog(errorText: errorMessages, context: context);

      //   BotToast.showText(text: _errorMessages); //popup a text toast;
      //   // cancel();
      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      return false;
    }
  }

  Future saveAccessTokenlocaly(
    String accessToken,
  ) async {
    final pref = await SharedPreferences.getInstance();
    pref.setString("access_token", accessToken);
    pref.setBool("is_guest", false);
  }
}

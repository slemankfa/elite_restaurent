import 'package:dio/dio.dart';
import 'package:elite/models/meal_size_model.dart';
import 'package:elite/models/resturant_menu_item.dart';
import 'package:elite/models/resturant_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/helper_methods.dart';
import '../models/menu_item_meals_list_model.dart';

class ResturantProvider with ChangeNotifier {
  Dio _dio = Dio();
  HelperMethods _helperMethods = HelperMethods();

  Future<ResturantModel?> getResturantDetails({
    required BuildContext context,
    required String ResturantId,
  }) async {
    try {
      // final token = await _helperMethods.getToken();
      Response response = await _dio.get(
        "${API_URL}Restaurants/$ResturantId",
        options: Options(
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          },
        ),
      );
      final resturantModel = ResturantModel.fromJson(response.data[0], context);
      final loadedResturantWorkingDays =
          await getResturantWorkingDays(ResturantId: ResturantId);
      resturantModel.resurantWorkingDaysModel = loadedResturantWorkingDays;
      return resturantModel;
    } on DioError catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<ResurantWorkingDaysModel?> getResturantWorkingDays({
    required String ResturantId,
  }) async {
    try {
      // final token = await _helperMethods.getToken();
      Response response = await _dio.get(
        "${API_URL}ResturantWorkingDays/$ResturantId",
        options: Options(
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
          },
        ),
      );
      final loadedResturantWorkingDays =
          ResurantWorkingDaysModel.fromJson(response.data);
      return loadedResturantWorkingDays;
    } on DioError catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<Map<String, dynamic>> getResturantMenu(
      {required BuildContext context,
      required int pageNumber,
      required String restId}) async {
    List<ResturantMenuItemModel> _tempList = [];
    try {
      Response response =
          await _dio.get("${API_URL}ItemCats/GetItemCat?ResturantID=$restId",
              options: Options(
                headers: {
                  "Accept": "application/json",
                  "content-type": "application/json",
                  // "Authorization": token
                },
              ));
      // print("response" + response.data.toString());

      var loadedList = response.data as List;

      var loadedNextPage = false;
      //     response.data['data']["notifications"]["next_page_url"] != null
      //         ? true
      //         : false;
      for (var item in loadedList) {
        _tempList.add(ResturantMenuItemModel.fromJson(item, context));
      }
      return {"list": _tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.toString());
      return {"list": _tempList, "isThereNextPage": false};
    }
  }

  Future<Map<String, dynamic>> getResturantMenuItemMeals(
      {required BuildContext context,
      required int pageNumber,
      required String restId,
      required String menuItemId}) async {
    List<MenuItemMealsListModel> _tempList = [];
    try {
      Response response = await _dio.get(
          "${API_URL}Items/GetItems?ResturantID=$restId&CatID=$menuItemId",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              // "Authorization": token
            },
          ));
      // print("response" + response.data.toString());

      var loadedList = response.data as List;

      var loadedNextPage = false;
      //     response.data['data']["notifications"]["next_page_url"] != null
      //         ? true
      //         : false;
      for (var item in loadedList) {
        _tempList.add(MenuItemMealsListModel.fromJson(item, context));
      }
      return {"list": _tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.toString());
      return {"list": _tempList, "isThereNextPage": false};
    }
  }

  Future<List<MealSizeModel>> getMealSize(
      {required BuildContext context,
      required int pageNumber,
      required String restId,
      required String menuItemId}) async {
    List<MealSizeModel> _tempList = [];
    try {
      Response response = await _dio.get(
          "${API_URL}ItemsSizes/GetItemsSize?ItemID=$menuItemId&ResturantID=$restId",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              // "Authorization": token
            },
          ));
      // print("response" + response.data.toString());

      var loadedList = response.data as List;

      var loadedNextPage = false;
      //     response.data['data']["notifications"]["next_page_url"] != null
      //         ? true
      //         : false;
      for (var item in loadedList) {
        _tempList.add(MealSizeModel.fromJson(item, context));
      }
      return _tempList;
    } on DioError catch (e) {
      print(e.toString());
      return[];
    }
  }
}

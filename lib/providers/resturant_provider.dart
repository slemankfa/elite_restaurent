import 'package:dio/dio.dart';
import 'package:elite/models/meal_size_model.dart';
import 'package:elite/models/resturant_menu_item.dart';
import 'package:elite/models/resturant_model.dart';
import 'package:elite/models/user_model.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/helper_methods.dart';
import '../models/meal_review_model.dart';
import '../models/menu_item_meals_list_model.dart';
import '../models/nutrations_model.dart';
import '../models/order_model.dart';
import '../models/resturant_review_model.dart';

class ResturantProvider with ChangeNotifier {
  final Dio _dio = Dio();
  final HelperMethods _helperMethods = HelperMethods();

  Future<ResturantModel?> getResturantDetails({
    required BuildContext context,
    required String ResturantId,
  }) async {
    try {
      // final token = await _helperMethods.getToken()
      Response response = await _dio.get(
        "${API_URL}Restaurant/$ResturantId",
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
    List<ResturantMenuItemModel> tempList = [];
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
        tempList.add(ResturantMenuItemModel.fromJson(item, context));
      }
      return {"list": tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.toString());
      return {"list": tempList, "isThereNextPage": false};
    }
  }

  Future<Map<String, dynamic>> getResturantMenuItemMeals(
      {required BuildContext context,
      required int pageNumber,
      required String restId,
      required String menuItemId}) async {
    List<MenuItemMealsListModel> tempList = [];
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
        tempList.add(MenuItemMealsListModel.fromJson(item, context));
      }
      return {"list": tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.toString());
      return {"list": tempList, "isThereNextPage": false};
    }
  }

  Future<List<MealSizeModel>> getMealSize(
      {required BuildContext context,
      required int pageNumber,
      required String restId,
      required String menuItemId}) async {
    List<MealSizeModel> tempList = [];
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
        tempList.add(MealSizeModel.fromJson(item, context));
      }
      return tempList;
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<bool> addMealReview(
      {required int rating,
      required String review,
      required String restId,
      required String mealId}) async {
    try {
      UserModel? userModel = await _helperMethods.getUser();
      print(userModel!.userId.toString());
      Response response = await _dio.post("${API_URL}ItemReviews",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              // "Authorization": token
            },
          ),
          data: {
            "resturantID": restId,
            "itemID": mealId,
            "userID": userModel.userId,
            "review": review,
            "yourRate": rating,
            "date": "2023-03-27T17:30:11.693Z"
          });

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>> getMealReviews(
      {required BuildContext context,
      required int pageNumber,
      required String restId,
      required String menuItemId}) async {
    List<MealReviewModel> tempList = [];
    try {
      Response response = await _dio.get(
          "${API_URL}ItemReviews/GetItemReview?ItemID=$menuItemId&ResturantID=$restId",
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
        tempList.add(MealReviewModel.fromJson(item));
      }
      return {"list": tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.toString());
      return {"list": tempList, "isThereNextPage": false};
    }
  }

  Future<String?> getMealDescrption(
      {required BuildContext context, required String menuItemId}) async {
    try {
      Response response =
          await _dio.get("${API_URL}Items/Description?ItemID=$menuItemId",
              options: Options(
                headers: {
                  "Accept": "application/json",
                  "content-type": "application/json",
                  // "Authorization": token
                },
              ));
      // print("response" + response.data.toString());

      return response.data.toString();
    } on DioError catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<List<NutirationModel>> getMealNutration(
      {required BuildContext context, required String menuItemId}) async {
    List<NutirationModel> tempList = [];
    try {
      Response response = await _dio.get(
          "${API_URL}CaloriesItems/GetCaloriesItem?ItemID=$menuItemId",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              // "Authorization": token
            },
          ));

      var loadedList = response.data as List;
      // print(response.data);
      for (var item in loadedList) {
        tempList.add(NutirationModel.fromJson(item));
      }
      return tempList;
    } on DioError catch (e) {
      print(e.toString());
      return [];
    }
  }

  Future<Map<String, dynamic>> getResturantsList({
    required BuildContext context,
    required int pageNumber,
    required Map<String, dynamic> map,
  }) async {
    List<ResturantModel> tempList = [];
    try {
      Response response = await _dio.get(
        "${API_URL}Restaurant",
        options: Options(
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            // "Authorization": token
          },
        ),
      );
      // print("response${response.data}");

      var loadedList = response.data as List;

      var loadedNextPage = false;
      //     response.data['data']["notifications"]["next_page_url"] != null
      //         ? true
      //         : false;
      for (var item in loadedList) {
        tempList.add(ResturantModel.fromJson(item, context));
      }
      return {"list": tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.toString());
      return {"list": tempList, "isThereNextPage": false};
    }
  }

  Future<Map<String, dynamic>> getResturantReviews({
    required BuildContext context,
    required int pageNumber,
    required String restId,
  }) async {
    List<ResturantReviewModel> tempList = [];
    try {
      Response response = await _dio.get("${API_URL}RestaurantReviews/$restId",
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
        tempList.add(ResturantReviewModel.fromJson(item));
      }
      return {"list": tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.toString());
      return {"list": tempList, "isThereNextPage": false};
    }
  }

  Future<bool> addResturantReview({
    required int goodTreatment,
    required int requsetSpeed,
    required int sanilation,
    required String review,
    required String restId,
  }) async {
    try {
      UserModel? userModel = await _helperMethods.getUser();
      print(userModel!.userId.toString());
      Response response = await _dio.post("${API_URL}RestaurantReviews/create",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              // "Authorization": token
            },
          ),
          data: {
            "resturantID": restId,
            "userID": userModel.userId,
            "review": review,
            "goodTreatment": goodTreatment,
            "requsetSpeed": requsetSpeed,
            "sanilation": sanilation,
            "date": "2023-03-26T12:21:16.541Z"
          });

      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Future<Map<String, dynamic>> getMyOrders({
    required BuildContext context,
    required int pageNumber,
    required int orderType,
  }) async {
    List<OrderModel> tempList = [];
    try {
      final token = await _helperMethods.getToken();

      Response response =
          await _dio.get("${API_URL}Order/MyOrders?UserID=3&IsIndoor=$orderType",
              options: Options(
                headers: {
                  "Accept": "application/json",
                  "content-type": "application/json",
                  "Authorization": token
                },
              ));
      // print("response" + response.data.toString());

      var loadedList = response.data as List;

      var loadedNextPage = false;
      //     response.data['data']["notifications"]["next_page_url"] != null
      //         ? true
      //         : false;
      for (var item in loadedList) {
        tempList.add(OrderModel.fromJson(item));
      }
      return {"list": tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.toString());
      return {"list": tempList, "isThereNextPage": false};
    }
  }
}

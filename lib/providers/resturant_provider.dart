import 'package:dio/dio.dart';
import 'package:elite/models/resturant_menu_item.dart';
import 'package:elite/models/resturant_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/helper_methods.dart';

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
      {required BuildContext context, required int pageNumber, required String restId}) async {
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
      // _tempList.add(NotifiactionModel(id: "13", title:  "مرحبا بكم في شحنه ", body: "تم إنشاء حسابك بنجاح الآن أصبح بإمكانك التمتع بالخدمات المقدمة من شحنة"));
      // print(addressesList.length.toString());
      return {"list": _tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.toString());
      return {"list": _tempList, "isThereNextPage": false};
    }
  }
}

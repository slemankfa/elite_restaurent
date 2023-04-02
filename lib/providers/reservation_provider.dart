import 'package:dio/dio.dart';
import 'package:elite/models/table_model.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/helper_methods.dart';

class ReservationProvider with ChangeNotifier {
  Dio _dio = Dio();
  HelperMethods _helperMethods = HelperMethods();

  Future<Map<String, dynamic>> getResturantMenuItemMeals(
      {required BuildContext context,
      required int pageNumber,
      required String restId,
      required String date,
      required String Seats}) async {
    List<TableModel> _tempList = [];
    try {
      Response response = await _dio.get(
          "${API_URL}Tables/FindTable?ResturentID=$restId&NoOfSeat=$Seats&dateTime=$date",
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
        _tempList.add(TableModel.fromJson(
          item,
        ));
      }
      return {"list": _tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.toString());
      return {"list": _tempList, "isThereNextPage": false};
    }
  }
}

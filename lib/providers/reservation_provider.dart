import 'package:dio/dio.dart';
import 'package:elite/models/table_model.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/helper_methods.dart';

class ReservationProvider with ChangeNotifier {
  final Dio _dio = Dio();
  final HelperMethods _helperMethods = HelperMethods();

  Future<Map<String, dynamic>> getResturantAvalibleTabels(
      {required BuildContext context,
      required int pageNumber,
      required String restId,
      required String date,
      required String Seats}) async {
    List<TableModel> tempList = [];
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

      var loadedList = response.data[0]["tables"] as List;

      var loadedNextPage = false;
      //     response.data['data']["notifications"]["next_page_url"] != null
      //         ? true
      //         : false;
      for (var item in loadedList) {
        tempList.add(TableModel.fromJson(
          item,
        ));
      }
      return {"list": tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.toString());
      return {"list": tempList, "isThereNextPage": false};
    }
  }
}

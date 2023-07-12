
import 'package:dio/dio.dart';
import 'package:elite/models/table_model.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../core/helper_methods.dart';
import '../models/reservation_model.dart';
import '../models/user_model.dart';

class ReservationProvider with ChangeNotifier {
  final Dio _dio = Dio();
  final HelperMethods _helperMethods = HelperMethods();

  Future<Map<String, dynamic>> getResturantAvalibleTabels(
      {required BuildContext context,
      required int pageNumber,
      required String restId,
      required String date,
      required String time,
      required bool isIndoor,
      required String seats}) async {
    List<TableModel> tempList = [];
    try {
      String structerdDate = "$date $time";
      // print(isIndoor.toString());
      Response response = await _dio.get(
          "${API_URL}Tables/FindTable?ResturentID=$restId&NoOfSeat=$seats&dateTime=$structerdDate&IsIndoor=$isIndoor",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              // "Authorization": token
            },
          ));
      // print("response" + response.data.toString());

      var loadedList = response.data["message"].isEmpty
          ? response.data["table"] as List
          : response.data["allTables"] as List;

      var loadedNextPage = false;
      //     response.data['data']["notifications"]["next_page_url"] != null
      //         ? true
      //         : false;
      for (var item in loadedList) {
        tempList.add(TableModel.fromJson(
          item,
        ));
      }
      return {
        "list": tempList,
        "isThereNextPage": loadedNextPage,
        "message": response.data["message"] ?? ""
      };
    } catch (e) {
      // print(e.toString());
      return {"list": tempList, "isThereNextPage": false, "message": ""};
    }
  }

  Future<Map<String, dynamic>> fetchMyReservation({
    required BuildContext context,
    required int pageNumber,
    required int status,
  }) async {
    List<ReservationModel> tempList = [];
    try {
      final token = await _helperMethods.getToken();
      final UserModel? tempUser = await _helperMethods.getUser();
      if (tempUser == null) {
        return {"list": tempList, "isThereNextPage": false};
      }
      Response response = await _dio.get(
          "${API_URL}Reservations/MyReservations?UserID=${tempUser.userId}&Stauts=$status",
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
        tempList.add(ReservationModel.fromJson(item));
      }
      return {"list": tempList, "isThereNextPage": loadedNextPage};
    } on DioError catch (e) {
      print(e.toString());
      return {"list": tempList, "isThereNextPage": false};
    }
  }

  Future<bool> cancelResrvation(
      {required BuildContext context, required String resvId}) async {
    try {
      final token = await _helperMethods.getToken();

      Response resendResponse = await _dio.post(
          "${API_URL}Reservations/ReservationCancel?ReservationID=$resvId",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              "Authorization": token
            },
          ),
          data: {});
      print(resvId);
      print(resendResponse.data);
      return true;
    } on DioError {
      // _helperMethods.handleError(e.response?.statusCode, context, e.response!);
      // return false;

      return false;
    }
  }

  Future<bool> createNewReservation({
    required String restId,
    required String time,
    required String toTime,
    required String date,
    required String note,
    required String noOfSeats,
    required bool remindSms,
    required TableModel table,
  }) async {
    try {
      // print(mealsDetails.toString());
      final token = await _helperMethods.getToken();
      final UserModel? tempUser = await _helperMethods.getUser();
      if (tempUser == null) {
        return false;
      }
      // log(restId);
      // log(tempUser.userId);
      // log("${date}T$time");
      // log(table.id);
      // log(time);
      // log(toTime);
      // log(remindSms.toString());
      // log(note);
      // log(noOfSeats);
      Response response = await _dio.post("${API_URL}Reservations",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              "Authorization": token
            },
          ),
          data: {
            "resturantID": restId,
            "userID": tempUser.userId,
            "reservationDate": "${date}T$time",
            "tableID": table.id,
            "reservationTime": time,
            "toTime": toTime,
            "isRemindSMS": remindSms,
            "anySpecialNote": note,
            "NoOfSeat": noOfSeats,
            "isConfirm": true,
            "isCancel": true,
            "isClose": true,
          });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  // Future<bool> cancelReservation({required String reservationID}) async {
  //   try {
  //     // print(mealsDetails.toString());
  //     final token = await _helperMethods.getToken();
  //     final UserModel? tempUser = await _helperMethods.getUser();
  //     if (tempUser == null) {
  //       return false;
  //     }
  //     Response response = await _dio.post(
  //       "${API_URL}Reservations/ReservationCancel?ReservationID=$reservationID",
  //       options: Options(
  //         headers: {
  //           "Accept": "application/json",
  //           "content-type": "application/json",
  //           "Authorization": token
  //         },
  //       ),
  //     );
  //     return true;
  //   } catch (e) {
  //     print(e.toString());
  //     return false;
  //   }
  // }
}

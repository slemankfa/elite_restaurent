import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:elite/core/styles.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperMethods {
  static final HelperMethods _helperMethods = HelperMethods._internal();
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  factory HelperMethods() {
    return _helperMethods;
  }

  HelperMethods._internal();

  Widget progressIndcator() {
    return const Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.white,
        valueColor: AlwaysStoppedAnimation<Color>(Styles.mainColor),
      ),
    );
  }

  Function showPopUpProgressIndcator() {
    return BotToast.showCustomLoading(toastBuilder: (_) {
      return progressIndcator();
    });
  }

  Future<String> getToken() async {
    var token = "";
    final prefs = await SharedPreferences.getInstance();
    token = "Bearer ${prefs.getString('access_token')}";
    return token;
  }

  clearAramexShipmentData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("aramex_shipment_details");
    prefs.remove("aramex_sender");
    prefs.remove("aramex_reciver");
    print("clearAramexShipmentDataMethod");
  }

  clearSmbShipmentData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("smb_shipment_details");
    prefs.remove("smb_sender");
    prefs.remove("smb_reciver");
    print("clearSmbShipmentDataMethod");
  }

  Future<bool?> checkIsGuest() async {
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getBool("is_guest");
    return status;
  }

  Future<void> acceptReservationPolicy() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_reservation_policy_accepted", true);
    print("introScreenIsSeen");
  }

  Future<bool> checkIsAcceptReservationPolicy() async {
    final prefs = await SharedPreferences.getInstance();
    final status = prefs.getBool("is_reservation_policy_accepted");
    return status ?? false;
  }

  showErrorDilog({required String errorText, required BuildContext context}) {
    showDialog(
        context: context,
        builder: (ctx) => Container(
              width: MediaQuery.of(context).size.width,
              child: AlertDialog(
                scrollable: true,
                contentPadding: EdgeInsets.all(8),
                insetPadding: EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Center(
                  child: Text(
                    "تنبيه!",
                    style: Styles.mainTextStyle
                        .copyWith(color: Colors.black, fontSize: 16),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        child: Text(
                          errorText,
                          style: Styles.mainTextStyle
                              .copyWith(color: Colors.black, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    // Container(
                    //   width: double.infinity,
                    //   margin: EdgeInsets.only(left: 20, right: 20),
                    //   child: EvaultedCustomButton(
                    //     function: () {
                    //       Navigator.of(context).pop();
                    //     },
                    //     text: "موافق",
                    //     textStyle:
                    //         Styles.mainTextStyle.copyWith(color: Colors.white),
                    //     backGroundColor: Styles.mainColor,
                    //   ),
                    // ),
                  ],
                ),
              ),
            ));
  }
}

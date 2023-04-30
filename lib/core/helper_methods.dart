import 'dart:convert';

import 'package:bot_toast/bot_toast.dart';
import 'package:elite/core/styles.dart';
import 'package:elite/core/widgets/custom_outline_button.dart';
import 'package:elite/models/user_model.dart';
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

  Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      Map<String, dynamic>? extractedUserData =
          json.decode(prefs.getString('userData')!);
      if (extractedUserData == null) {
        return null;
      }
      UserModel user = UserModel.fromSavedJson(extractedUserData);
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
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

  showAlertDilog(
      {required String message,
      required BuildContext context,
      required Function function}) {
    showDialog(
        context: context,
        builder: (ctx) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AlertDialog(
                scrollable: true,
                contentPadding: const EdgeInsets.all(12),
                insetPadding: const EdgeInsets.all(12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                title: Center(
                  child: Text(
                    "Alert!",
                    style: Styles.mainTextStyle.copyWith(
                        color: Styles.mainColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        child: Text(
                          message,
                          style: Styles.mainTextStyle.copyWith(
                              color: Styles.mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    //  CustomOutlinedButton(
                    //         label: "Delete",
                    //         icon: Container(),
                    //         isIconVisible: false,
                    //         onPressedButton: () {
                    //           function();
                    //           Navigator.of(context).pop();
                    //         },
                    //         borderSide: BorderSide(
                    //           color: Colors.black.withOpacity(0.16),
                    //         ),
                    //         // backGroundColor: Styles.mainColor,
                    //         textStyle: Styles.mainTextStyle.copyWith(
                    //             color: Colors.black.withOpacity(0.7),
                    //             fontSize: 16,
                    //             fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        Expanded(
                          child: CustomOutlinedButton(
                              label: "Remove",
                              backGroundColor: Styles.deleteBackGroundColor,
                              icon: const Icon(
                                Icons.delete,
                                color: Styles.cancelREdColor,
                              ),
                              isIconVisible: true,
                              onPressedButton: () {
                                function();
                                Navigator.of(context).pop();
                              },
                              borderSide: BorderSide(
                                color: Colors.black.withOpacity(0.16),
                              ),
                              // backGroundColor: Styles.mainColor,
                              textStyle: Styles.mainTextStyle.copyWith(
                                  color: Styles.cancelREdColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomOutlinedButton(
                              label: "Cancel",
                              icon: Container(),
                              isIconVisible: false,
                              onPressedButton: () {
                                Navigator.of(context).pop();
                              },
                              // borderSide: BorderSide(
                              //   color: Colors.black.withOpacity(0.16),
                              // ),
                              // backGroundColor: Styles.mainColor,
                              textStyle: Styles.mainTextStyle.copyWith(
                                  color: Colors.black.withOpacity(0.7),
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ));
  }

  showErrorDilog({required String errorText, required BuildContext context}) {
    showDialog(
        context: context,
        builder: (ctx) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AlertDialog(
                scrollable: true,
                contentPadding: const EdgeInsets.all(8),
                insetPadding: const EdgeInsets.all(10),
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
                    const SizedBox(
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
                    const SizedBox(
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

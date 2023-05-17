import 'package:easy_localization/easy_localization.dart';
import 'package:elite/core/helper_methods.dart';
import 'package:elite/models/table_model.dart';
import 'package:elite/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';
import '../../models/resturant_model.dart';
import '../../models/user_model.dart';
import '../../providers/reservation_provider.dart';
import '../main_tabs_page.dart';

class ReservationDetailsPage extends StatefulWidget {
  const ReservationDetailsPage(
      {super.key,
      required this.tableModel,
      required this.time,
      required this.date,
      required this.resturantDetails});

  @override
  State<ReservationDetailsPage> createState() => _ReservationDetailsPageState();
  final TableModel tableModel;
  final String time;
  final String date;
  final ResturantModel resturantDetails;
}

//  required String restId,
//     required String time,
//     required String date,
//     required String note,
//     required bool remindSms,
//     required TableModel table,
class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  bool _reminedMeSms = false;
  final TextEditingController _noteController = TextEditingController();
  final HelperMethods _helperMethods = HelperMethods();
  late Function showPopUpLoading;

  showConfirmDilog({required BuildContext context}) {
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
                    "Confirmed",
                    style: Styles.mainTextStyle.copyWith(
                        color: Styles.grayColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(
                    //   height: 15,
                    // ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        child: Text(
                          "The reservation was completed successfully, to view the details of the reservation, go to the reservations in the profile.",
                          style: Styles.mainTextStyle
                              .copyWith(color: Styles.grayColor, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      // margin: EdgeInsets.symmetric(horizontal: 50),
                      width: 150,
                      child: CustomOutlinedButton(
                          label: "OK",
                          isIconVisible: false,
                          onPressedButton: () {
                            Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    const MainTabsPage(),
                              ),
                              (route) =>
                                  false, //if you want to disable back feature set to false
                            );
                            // Navigator.of(context).pop();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => ResturanMenuPage()),
                            // );
                          },
                          rectangleBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          icon: Container(),
                          borderSide: const BorderSide(color: Styles.mainColor),
                          textStyle: Styles.mainTextStyle.copyWith(
                              color: Styles.mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _noteController.dispose();
    super.dispose();
  }

  convertFromDate(String? date) {
    if (date == null) return "";
    // "2023-03-18T07:19:23.64"
    DateTime tempDate = DateFormat("hh:mm", 'en_US').parse(date);
    return DateFormat("HH:mm:ss a").format(tempDate);
  }

  convertToDate(String? date) {
    if (date == null) return "";
    // "2023-03-18T07:19:23.64"
    DateTime tempDate = DateFormat("hh:mm", 'en_US').parse(date);
    DateTime toTime =
        DateTime(DateTime.now().year, 1, 1, tempDate.hour + 1, tempDate.minute);
    // tempDate.add(const Duration(hours: 1));
    return DateFormat("HH:mm:ss a").format(toTime);
  }

  convertFromDateWithOutStand(String? date) {
    if (date == null) return "";
    // "2023-03-18T07:19:23.64"
    DateTime tempDate = DateFormat("hh:mm", 'en_US').parse(date);
    return DateFormat("HH:mm:ss").format(tempDate);
  }

  convertToDateWithOutStand(String? date) {
    if (date == null) return "";
    // "2023-03-18T07:19:23.64"
    DateTime tempDate = DateFormat("HH:mm", 'en_US').parse(date);
    DateTime toTime =
        DateTime(DateTime.now().year, 1, 1, tempDate.hour + 1, tempDate.minute);
    // tempDate.add(const Duration(hours: 1));
    return DateFormat("HH:mm:ss").format(toTime);
  }

  Future addNewReservation() async {
    try {
      // showPopUpLoading
      showPopUpLoading = _helperMethods.showPopUpProgressIndcator();
      Provider.of<ReservationProvider>(context, listen: false)
          .createNewReservation(
        restId: widget.resturantDetails.id,
        time: convertFromDateWithOutStand(widget.time),
        date: widget.date,
        toTime: convertToDateWithOutStand(widget.time),
        note: _noteController.text,
        remindSms: _reminedMeSms,
        table: widget.tableModel,
      )
          .then((status) {
        showPopUpLoading.call();
        if (status) {
          showConfirmDilog(context: context);
        } else {}
      });
    } catch (e) {
      showPopUpLoading.call();
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // showPopUpLoading.call();
    UserModel? userInformation =
        Provider.of<AuthProvider>(context).userInformation;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Styles.grayColor),
          title: Text(
            "Reservation Details",
            style: Styles.appBarTextStyle,
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // margin: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.tableModel.name,
                          style: Styles.mainTextStyle.copyWith(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Styles.resturentNameColor),
                        ),
                      ),
                      Chip(
                          backgroundColor: Styles.listTileBorderColr,
                          label: Text(
                            widget.tableModel.descreption,
                            style: Styles.mainTextStyle.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Styles.mainColor),
                          ))
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                userInformation == null
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Personal details",
                            style: Styles.mainTextStyle.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Styles.grayColor),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            "${userInformation.firstName} ${userInformation.lastName}"
                                .toString(),
                            style: Styles.mainTextStyle.copyWith(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                                color: Styles.resturentNameColor),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              SvgPicture.asset("assets/icons/mail.svg"),
                              const SizedBox(
                                width: 6,
                              ),
                              Expanded(
                                  child: Text(
                                userInformation.email.toString(),
                                style: Styles.mainTextStyle.copyWith(
                                  color: Styles.midGrayColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Text(
                            userInformation.userPhone.toString(),
                            style: Styles.mainTextStyle.copyWith(
                              color: Styles.midGrayColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                const SizedBox(
                  height: 12,
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Duration",
                  style: Styles.mainTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Styles.grayColor),
                ),
                const SizedBox(
                  height: 12,
                ),
                Row(
                  children: [
                    SvgPicture.asset("assets/icons/clock.svg"),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                        child: Text(
                      "1 hour . ${convertFromDate(widget.time)} TO ${convertToDate(widget.time)}",
                      style: Styles.mainTextStyle.copyWith(
                        color: Styles.midGrayColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ))
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      // flex: 10,
                      child: Text(
                        "Remind me through SMS",
                        style: Styles.mainTextStyle
                            .copyWith(fontSize: 16, color: Styles.grayColor),
                      ),
                    ),
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Styles.mainColor, width: 1),
                      ),
                      child: Theme(
                        // color: Colors.white,
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: Checkbox(
                          // shape:  CircleBorder(),
                          value: _reminedMeSms,

                          checkColor: Styles.mainColor,
                          // side: BorderSide(
                          //   color: Styles.mainColor,
                          // ),
                          overlayColor: MaterialStateProperty.all(Colors.white),
                          focusColor: Colors.white,
                          tristate: false,
                          // activeColor:Colors.white ,
                          fillColor: MaterialStateProperty.all(Colors.white),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          onChanged: (value) {
                            setState(() {
                              _reminedMeSms = value ?? false;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 12,
                ),
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  "Any Special requests?",
                  style: Styles.mainTextStyle
                      .copyWith(fontSize: 16, color: Styles.userNameColor),
                ),
                const SizedBox(
                  height: 12,
                ),
                TextFormField(
                  controller: _noteController,
                  // validator: ((value) => _validationHelper.validateField(value!)),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  style: Styles.mainTextStyle,
                  maxLines: 5,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Styles.mainColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Styles.mainColor,
                        width: 1.0,
                      ),
                    ),
                    focusColor: Colors.black,
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomOutlinedButton(
                    label: "Confirm",
                    isIconVisible: false,
                    icon: Container(),
                    onPressedButton: () => addNewReservation(),
                    borderSide: const BorderSide(
                      color: Styles.mainColor,
                    ),
                    backGroundColor: Styles.mainColor,
                    textStyle: Styles.mainTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

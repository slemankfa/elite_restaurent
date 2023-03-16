import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';

class ReservationDetailsPage extends StatefulWidget {
  const ReservationDetailsPage({super.key});

  @override
  State<ReservationDetailsPage> createState() => _ReservationDetailsPageState();
}

class _ReservationDetailsPageState extends State<ReservationDetailsPage> {
  bool _reminedMeSms = false;

  showConfirmDilog({required BuildContext context}) {
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
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      // margin: EdgeInsets.symmetric(horizontal: 50),
                      width: 150,
                      child: CustomOutlinedButton(
                          label: "OK",
                          onPressedButton: () {
                            Navigator.of(context).pop();
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => ResturanMenuPage()),
                            // );
                          },
                          rectangleBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          icon: Container(),
                          borderSide: BorderSide(color: Styles.mainColor),
                          textStyle: Styles.mainTextStyle.copyWith(
                              color: Styles.mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Styles.grayColor),
          title: Text(
            "Reservation Details",
            style: Styles.appBarTextStyle,
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(16),
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
                          "Table 2",
                          style: Styles.mainTextStyle.copyWith(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Styles.resturentNameColor),
                        ),
                      ),
                      Chip(
                          backgroundColor: Styles.listTileBorderColr,
                          label: Text(
                            "Corner Table",
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
                  "Miss Sarah Koss",
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
                      "Blaze_Windler11@gmail.com",
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
                  "415-599-9453",
                  style: Styles.mainTextStyle.copyWith(
                    color: Styles.midGrayColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
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
                      "1 hour . 3:00 PM TO 4:00PM",
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
                  // controller: _shipmentDescrpationController,
                  // validator: ((value) => _validationHelper.validateField(value!)),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  style: Styles.mainTextStyle,
                  maxLines: 5,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Styles.mainColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Styles.mainColor,
                        width: 1.0,
                      ),
                    ),
                    focusColor: Colors.black,
                    focusedErrorBorder: OutlineInputBorder(
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
                    icon: Container(),
                    onPressedButton: () => showConfirmDilog(context: context),
                    borderSide: BorderSide(
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

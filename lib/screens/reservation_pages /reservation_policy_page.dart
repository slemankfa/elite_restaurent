import 'package:bot_toast/bot_toast.dart';
import 'package:elite/core/helper_methods.dart';
import 'package:flutter/material.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';

class ReservationPolicyPage extends StatefulWidget {
  const ReservationPolicyPage({super.key});

  @override
  State<ReservationPolicyPage> createState() => _ReservationPolicyPageState();
}

class _ReservationPolicyPageState extends State<ReservationPolicyPage> {
  bool _acceptTerms = false;
  HelperMethods _helperMethods = HelperMethods();

  _onSaved() async {
    try {
      if (!_acceptTerms) {
        BotToast.showText(text: "You must accept terms first!");
        return;
      }
      _helperMethods.acceptReservationPolicy().then((_) {
        Navigator.of(context).pop(true);
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Styles.grayColor),
        title: Text(
          "Reservation Policy",
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "We use the restaurant reservation credit feature, which means that when you make a reservation for a table at the restaurant using the application, we will ask you to provide your credit card information to secure the reservation during the booking process. Don't worry, we will never share your card information or use it in an unwanted way without your permission. We will give you a 15-minute grace period to cancel the reservation. If you cancel the reservation within the specified period, we will not deduct any amount from your credit card and we will add 5 dinars to your credit through the application. However, if you cancel the reservation late or do not show up at the designated time, the restaurant will impose a fee of 1.00 dinar, which will be deducted from the credit card you provided, and we will add 4 dinars to your credit through the application. You can use the added credit to cover any future costs, such as using the credit value for a future reservation or meal instead of paying for new reservation fees or new meals.",
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          // flex: 10,
                          child: RichText(
                            text: TextSpan(
                              text:
                                  'I have read all the terms and conditions of the ',
                              style: Styles.mainTextStyle.copyWith(
                                  fontSize: 16, color: Styles.grayColor),
                              children: <TextSpan>[
                                TextSpan(
                                    text:
                                        "restaurant's reservation and cancellation policy,",
                                    style: Styles.mainTextStyle.copyWith(
                                        fontSize: 16,
                                        color: Styles.grayColor,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                  text: 'and I agree to them.',
                                  style: Styles.mainTextStyle.copyWith(
                                      fontSize: 16, color: Styles.grayColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border:
                                Border.all(color: Styles.mainColor, width: 1),
                          ),
                          child: Theme(
                            // color: Colors.white,
                            data:
                                ThemeData(unselectedWidgetColor: Colors.white),
                            child: Checkbox(
                              // shape:  CircleBorder(),
                              value: _acceptTerms,

                              checkColor: Styles.mainColor,
                              // side: BorderSide(
                              //   color: Styles.mainColor,
                              // ),
                              overlayColor:
                                  MaterialStateProperty.all(Colors.white),
                              focusColor: Colors.white,
                              tristate: false,
                              // activeColor:Colors.white ,
                              fillColor:
                                  MaterialStateProperty.all(Colors.white),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _acceptTerms = value ?? false;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            //

            CustomOutlinedButton(
                label: "Next",
                onPressedButton: _acceptTerms ? _onSaved : null,
                icon: Container(),
                rectangleBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                backGroundColor:_acceptTerms? Styles.mainColor : Styles.mainColor.withOpacity(0.4),
                // borderSide: BorderSide(color: Styles.mainColor),
                textStyle: Styles.mainTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

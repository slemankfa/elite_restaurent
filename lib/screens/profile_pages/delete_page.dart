import 'package:elite/core/styles.dart';
import 'package:elite/core/valdtion_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/widgets/custom_form_field.dart';
import '../../core/widgets/custom_outline_button.dart';

class DeletePage extends StatefulWidget {
  const DeletePage({super.key});

  @override
  State<DeletePage> createState() => _DeletePageState();
  static const routeName = "/delete-page";
}

class _DeletePageState extends State<DeletePage> {
  ValidationHelper _validationHelper = ValidationHelper();
  TextEditingController _passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 1,
            // bottom: 1,
            left: 1,
            right: 1,
            child: Image.asset("assets/images/food_background.png"),
          ),
          Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      "Notifications",
                      style: Styles.mainTextStyle
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
          Positioned(
            top: 65,
            left: 1,
            right: 1,
            bottom: 16,
            child: SafeArea(
              child: Container(
                // color: Colors.white,
                margin: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Colors.white,
                              border: Border.all(
                                  color: Styles.RatingRivewBoxBorderColor)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Confirm this is your Account",
                                style: Styles.mainTextStyle.copyWith(
                                    color: Styles.grayColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                "Before your permanently delete your Account, please enter your pasword.",
                                style: Styles.mainTextStyle.copyWith(
                                    color: Styles.grayColor,
                                    // fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              RichText(
                                text: TextSpan(
                                  text:
                                      'Deleting your account is permanent. when you delete your account, you ',
                                  style: Styles.mainTextStyle.copyWith(
                                      color: Styles.grayColor,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          "won't be able to retrieve the content or information you've shared on our app,",
                                      style: Styles.mainTextStyle.copyWith(
                                          color: Styles.grayColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    TextSpan(
                                      text:
                                          ' your messages and all of your orders will also be deleted.',
                                      style: Styles.mainTextStyle.copyWith(
                                          color: Styles.grayColor,
                                          // fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Transform(
                                transform: Matrix4.translationValues(-14, 0, 0),
                                child: ListTile(
                                  leading: Container(
                                    // padding: EdgeInsets.all(5),
                                    width: 44,
                                    height: 44,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Styles.RatingRivewBoxBorderColor,
                                      // shape: CircleBorder(),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: SvgPicture.asset(
                                        "assets/icons/profile.svg",
                                        width: 13,
                                        height: 15,
                                        color: Styles.midGrayColor,
                                      ),
                                    ),
                                  ),
                                  title: Text(
                                    "Clinton Waelchi",
                                    style: Styles.mainTextStyle
                                        .copyWith(color: Styles.userNameColor),
                                  ),
                                ),
                              ),
                              // SizedBox(
                              //   height: 11,
                              // ),
                              CustomFormField(
                                controller: _passwordController,
                                formatter: [],
                                textInputType: TextInputType.visiblePassword,
                                vladationFunction:
                                    _validationHelper.validatePassword,
                                action: TextInputAction.done,
                                hintText: "",
                                isSecureField: true,
                                textStyle: Styles.mainTextStyle,
                                hintStyle: TextStyle(),
                                labelTextStyle: Styles.mainTextStyle.copyWith(
                                    color: Styles.unslectedItemColor,
                                    fontSize: 16),
                                label: "",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    CustomOutlinedButton(
                        label: "Delete Account",
                        isIconVisible: true,
                        onPressedButton: () {},
                        icon: Container(),
                        backGroundColor: Styles.cancelREdColor,
                        rectangleBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        // borderSide: BorderSide(color: Styles.mainColor),
                        textStyle: Styles.mainTextStyle.copyWith(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

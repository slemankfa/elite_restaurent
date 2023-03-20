import 'package:elite/core/valdtion_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_form_field.dart';
import '../../core/widgets/custom_outline_button.dart';
import '../main_tabs_page.dart';
import '../profile_pages/widgtes/profile_custom_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
  static const routeName = "/login-page";
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _userEmailTextController = TextEditingController();
  TextEditingController _userPasswordTextController = TextEditingController();
  ValidationHelper _validationHelper = ValidationHelper();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _userEmailTextController.dispose();
    _userPasswordTextController.dispose();
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
            "Login",
            style: Styles.appBarTextStyle,
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(16),
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileCustomFormField(
                    controller: _userEmailTextController,
                    formatter: [],
                    isPrefixeIconAvalibel: false,
                    action: TextInputAction.done,
                    hintText: "",
                    textStyle: Styles.mainTextStyle
                        .copyWith(fontSize: 16, color: Styles.mainColor),
                    hintStyle: TextStyle(),
                    vladationFunction: _validationHelper.validateEmail,
                    textInputType: TextInputType.emailAddress,
                    isSuffixIconAvalibel: false,
                    readOnly: false,
                    onTapFuncation: () {},
                    textAlign: TextAlign.start,
                    label: "Email",
                    labelTextStyle: Styles.mainTextStyle.copyWith(
                        color: Styles.unslectedItemColor, fontSize: 16),
                    formFillColor: Colors.white),
                const SizedBox(
                  height: 19,
                ),
                CustomFormField(
                  controller: _userPasswordTextController,
                  formatter: [],
                  textInputType: TextInputType.visiblePassword,
                  vladationFunction: _validationHelper.validatePassword,
                  action: TextInputAction.done,
                  hintText: "",
                  isSecureField: true,
                  textStyle: Styles.mainTextStyle,
                  hintStyle: TextStyle(),
                  labelTextStyle: Styles.mainTextStyle
                      .copyWith(color: Styles.unslectedItemColor, fontSize: 16),
                  label: "Password",
                ),
                const SizedBox(
                  height: 19,
                ),
                CustomOutlinedButton(
                    label: "LOGIN",
                    icon: Container(),
                    isIconVisible: false,
                    onPressedButton: () =>
                        Navigator.of(context).pushNamed(MainTabsPage.routeName),
                    // borderSide: BorderSide(
                    //   color: Styles.mainColor,
                    // ),
                    backGroundColor: Styles.mainColor,
                    textStyle: Styles.mainTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                const SizedBox(
                  height: 19,
                ),
                Text(
                  "Reset Password?",
                  style: Styles.mainTextStyle.copyWith(color: Styles.grayColor),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

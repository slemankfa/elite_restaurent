import 'package:elite/core/valdtion_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helper_methods.dart';
import '../../core/styles.dart';
import '../../core/widgets/custom_form_field.dart';
import '../../core/widgets/custom_outline_button.dart';
import '../../providers/auth_provider.dart';
import '../main_tabs_page.dart';
import '../profile_pages/widgtes/profile_custom_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
  static const routeName = "/login-page";
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userEmailTextController =
      TextEditingController();
  final TextEditingController _userPasswordTextController =
      TextEditingController();
  final ValidationHelper _validationHelper = ValidationHelper();
  final _formKey = GlobalKey<FormState>();
  final HelperMethods _helperMethods = HelperMethods();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _userEmailTextController.dispose();
    _userPasswordTextController.dispose();
  }

  login() async {
    Function showPopUpLoading;
    if (!_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      return;
    }

    showPopUpLoading = _helperMethods.showPopUpProgressIndcator();
    try {
      // final String fcmToken = await _notificationHelper.getDeviceToken();
      // if (fcmToken.trim().isEmpty) {
      //   BotToast.showText(
      //       text: "يجب تفعيل الاشعارات للحصول على افضل تجربة مستخدم ");
      //   return;
      // }
      await Provider.of<AuthProvider>(context, listen: false)
          .login(
              context: context,
              email: _userEmailTextController.text.trim(),
              password: _userPasswordTextController.text.trim())
          .then((value) async {
        showPopUpLoading();
        if (value) {
          // return ;
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const MainTabsPage(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        }
      });
    } catch (e) {
      print(e.toString());
      showPopUpLoading();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Styles.grayColor),
          title: Text(
            "Login",
            style: Styles.appBarTextStyle,
          ),
        ),
        body: Form(
          key: _formKey,
          child: Container(
            margin: const EdgeInsets.all(16),
            // alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  Center(
                    child: Image.asset(
                      "assets/images/elite_logo.png",
                      width: 120,
                      height: 120,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ProfileCustomFormField(
                      controller: _userEmailTextController,
                      formatter: const [],
                      isPrefixeIconAvalibel: false,
                      action: TextInputAction.done,
                      hintText: "",
                      textStyle: Styles.mainTextStyle
                          .copyWith(fontSize: 16, color: Styles.mainColor),
                      hintStyle: const TextStyle(),
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
                    formatter: const [],
                    textInputType: TextInputType.visiblePassword,
                    vladationFunction: _validationHelper.validatePassword,
                    action: TextInputAction.done,
                    hintText: "",
                    isSecureField: true,
                    textStyle: Styles.mainTextStyle,
                    hintStyle: const TextStyle(),
                    labelTextStyle: Styles.mainTextStyle.copyWith(
                        color: Styles.unslectedItemColor, fontSize: 16),
                    label: "Password",
                  ),
                  const SizedBox(
                    height: 19,
                  ),
                  CustomOutlinedButton(
                      label: "LOGIN",
                      icon: Container(),
                      isIconVisible: false,
                      onPressedButton: () => login(),
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
                    style:
                        Styles.mainTextStyle.copyWith(color: Styles.grayColor),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

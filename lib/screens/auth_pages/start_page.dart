import 'dart:developer';

import 'package:bot_toast/bot_toast.dart';
import 'package:elite/core/styles.dart';
import 'package:elite/providers/auth_provider.dart';
import 'package:elite/screens/auth_pages/create_account_page.dart';
import 'package:elite/screens/auth_pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/custom_outline_button.dart';
import '../main_tabs_page.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
  static const routeName = "/start-page";
}

class _StartPageState extends State<StartPage> {
  signInWithGoogle() async {
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .signInWithGoogle(context: context)
          .then((value) {
        print("valeu $value");
        if (value) {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const MainTabsPage(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        } else {
          BotToast.showText(text: "something went wrong!");
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  signInAsGuest() async {
    try {
      Provider.of<AuthProvider>(context, listen: false)
          .signInAsGuest()
          .then((value) {
        if (value) {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const MainTabsPage(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        } else {
          BotToast.showText(text: "something went wrong!");
        }
      });
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
              Color(0xff4A117E),
              Color(0xff833FC1),
            ], // Gradient from https://learnui.design/tools/gradient-generator.html
            tileMode: TileMode.mirror,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 1,
              // bottom: 1,
              left: 1,
              right: 1,
              child: Image.asset(
                "assets/images/start_bac.png",
                fit: BoxFit.fill,
              ),
            ),
            Positioned(
              top: 56,
              left: 1,
              right: 1,
              bottom: 16,
              child: SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Image.asset(
                          "assets/images/elite_logo.png",
                          width: 120,
                          height: 120,
                        ),
                        const SizedBox(
                          height: 60,
                        ),
                        Container(
                          width: double.infinity,
                          height: 56,
                          padding: const EdgeInsets.all(0),
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: signInWithGoogle,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset("assets/icons/google.svg"),
                                const SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    "Continue with Google",
                                    style: Styles.mainTextStyle.copyWith(
                                        color: Colors.black.withOpacity(0.54),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            const Expanded(
                                child: Divider(
                              color: Colors.white,
                            )),
                            Text(
                              "Or",
                              style: Styles.mainTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                            const Expanded(
                                child: Divider(
                              color: Colors.white,
                            )),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomOutlinedButton(
                            label: "LOGIN",
                            icon: Container(),
                            isIconVisible: false,
                            onPressedButton: () => Navigator.of(context)
                                .pushNamed(LoginPage.routeName),
                            // borderSide: BorderSide(
                            //   color: Styles.mainColor,
                            // ),
                            backGroundColor: Colors.white,
                            textStyle: Styles.mainTextStyle.copyWith(
                                color: Styles.mainColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomOutlinedButton(
                            label: "Create new account",
                            icon: const Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            isIconVisible: true,
                            onPressedButton: () {
                              Navigator.of(context)
                                  .pushNamed(CreateAccountPage.routeName);
                            },
                            // borderSide: BorderSide(
                            //   color: Styles.mainColor,
                            // ),
                            backGroundColor: Styles.timeTextColor,
                            textStyle: Styles.mainTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(
                          height: 15,
                        ),
                        CustomOutlinedButton(
                            label: "Login as Guest",
                            icon: Container(),
                            isIconVisible: false,
                            onPressedButton: signInAsGuest,
                            borderSide: const BorderSide(
                              color: Colors.white,
                            ),
                            // backGroundColor: Styles.mainColor,
                            textStyle: Styles.mainTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

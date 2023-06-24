import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite/core/lunchers_helper.dart';
import 'package:elite/screens/auth_pages.dart/start_page.dart';
import 'package:elite/screens/profile_pages/delete_page.dart';
import 'package:elite/screens/profile_pages/edit_profile_page.dart';
import 'package:elite/screens/profile_pages/my_orders_page.dart';
import 'package:elite/screens/profile_pages/points_page.dart';
import 'package:elite/screens/profile_pages/support_chat_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../core/styles.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import 'my_resvation_list_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  static const routeName = "/profile-page";
}

class _ProfilePageState extends State<ProfilePage> {
  final LuncherHelper _luncherHelper = LuncherHelper();

  Future logout(BuildContext context) async {
    try {
      Provider.of<AuthProvider>(context, listen: false)
          .logout(context: context)
          .then((value) {
        if (value) {
          Navigator.pushAndRemoveUntil<dynamic>(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => const StartPage(),
            ),
            (route) => false, //if you want to disable back feature set to false
          );
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = Provider.of<AuthProvider>(
      context,
    ).userInformation;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 56,
            left: 1,
            right: 1,
            bottom: 1,
            child: SafeArea(
                child: Container(
                    margin: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 17,
                          ),
                          Container(
                            // padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Styles.mainColor,
                                // shape: CircleBorder(),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.4),
                                    blurRadius: 1,
                                    spreadRadius: 12,
                                  ),
                                  BoxShadow(
                                      color: Styles.mainColor.withOpacity(0.2),
                                      blurRadius: 1,
                                      spreadRadius: 5),
                                ]),
                            child: userModel == null
                                ? Container()
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: CachedNetworkImage(
                                      imageUrl: userModel.userImage.toString(),
                                      height: 64,
                                      width: 64,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const FlutterLogo(
                                        size: 64,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                        size: 64,
                                      ),
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            userModel == null ? "" : "${userModel.firstName.toString()} ${userModel.lastName.toString()}",
                            style: Styles.mainTextStyle.copyWith(
                                color: Styles.grayColor,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          // orders
                          ListTile(
                            onTap: () => Navigator.of(context)
                                .pushNamed(MyOrdersPage.routeName),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Styles.midGrayColor,
                            ),
                            leading:
                                SvgPicture.asset("assets/icons/orders.svg"),
                            title: Row(
                              children: [
                                Expanded(
                                  // flex: 6,
                                  child: Text("My orders",
                                      style: Styles.mainTextStyle.copyWith(
                                        fontSize: 18,
                                        color: Styles.grayColor,
                                      )),
                                ),
                                Expanded(
                                  // flex: 1,
                                  child: Text(
                                    userModel == null
                                        ? ""
                                        : userModel.myOrdersCount.toString(),
                                    textAlign: TextAlign.end,
                                    style: Styles.mainTextStyle.copyWith(
                                        fontSize: 16,
                                        color: Styles.mainColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          const Divider(),
                          // points
                          ListTile(
                            onTap: () => Navigator.of(context)
                                .pushNamed(PointsPage.routeName),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Styles.midGrayColor,
                            ),
                            leading:
                                SvgPicture.asset("assets/icons/points.svg"),
                            title: Row(
                              children: [
                                Expanded(
                                  // flex: 6,
                                  child: Text("My points",
                                      style: Styles.mainTextStyle.copyWith(
                                        fontSize: 18,
                                        color: Styles.grayColor,
                                      )),
                                ),
                                Expanded(
                                  // flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerRight,
                                    child: Chip(
                                      backgroundColor:
                                          Styles.chipBackGroundColor,
                                      label: Text(
                                        "956",
                                        textAlign: TextAlign.end,
                                        style: Styles.mainTextStyle.copyWith(
                                            fontSize: 16,
                                            color: Styles.mainColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          const Divider(),
                          // resvations
                          ListTile(
                            onTap: () => Navigator.of(context)
                                .pushNamed(MyReservationListPage.routeName),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Styles.midGrayColor,
                            ),
                            leading: SvgPicture.asset("assets/icons/resv.svg"),
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Text("Reservations",
                                      style: Styles.mainTextStyle.copyWith(
                                        fontSize: 18,
                                        color: Styles.grayColor,
                                      )),
                                ),
                                Expanded(
                                  // flex: 1,
                                  child: Text(
                                    userModel == null
                                        ? ""
                                        : userModel.myReservationCount
                                            .toString(),
                                    textAlign: TextAlign.end,
                                    style: Styles.mainTextStyle.copyWith(
                                        fontSize: 16,
                                        color: Styles.mainColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          const Divider(),
                          // credit
                          ListTile(
                            leading: SvgPicture.asset("assets/icons/money.svg"),
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Text("Credit",
                                      style: Styles.mainTextStyle.copyWith(
                                        fontSize: 18,
                                        color: Styles.grayColor,
                                      )),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "0.00 JD",
                                    textAlign: TextAlign.end,
                                    style: Styles.mainTextStyle.copyWith(
                                        fontSize: 16,
                                        color: Styles.mainColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          const Divider(),
                          // chat
                          ListTile(
                            onTap: () => Navigator.of(context)
                                .pushNamed(SupportChatPage.RouteName),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Styles.midGrayColor,
                            ),
                            leading: SvgPicture.asset("assets/icons/chat.svg"),
                            title: Text("Live Support",
                                style: Styles.mainTextStyle.copyWith(
                                  fontSize: 18,
                                  color: Styles.grayColor,
                                )),
                            subtitle: Text("Chat with one member of our team",
                                style: Styles.mainTextStyle.copyWith(
                                  fontSize: 14,
                                  color: Styles.midGrayColor,
                                )),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          const Divider(),
                          // call us
                          ListTile(
                            onTap: () {
                              _luncherHelper.launchPhoneCall("00966");
                            },
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Styles.midGrayColor,
                            ),
                            leading: SvgPicture.asset("assets/icons/call.svg"),
                            title: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text("Call Us",
                                      style: Styles.mainTextStyle.copyWith(
                                        fontSize: 18,
                                        color: Styles.grayColor,
                                      )),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    "+479-907-5122",
                                    textAlign: TextAlign.end,
                                    style: Styles.mainTextStyle.copyWith(
                                        fontSize: 16,
                                        color: Styles.midGrayColor,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          const Divider(),
                          // delete account
                          // chat
                          ListTile(
                            onTap: () => Navigator.of(context)
                                .pushNamed(DeletePage.routeName),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Styles.midGrayColor,
                            ),
                            leading:
                                SvgPicture.asset("assets/icons/delete.svg"),
                            title: Text("Delete Account",
                                style: Styles.mainTextStyle.copyWith(
                                  fontSize: 18,
                                  color: Colors.red,
                                )),
                          ),
                          const SizedBox(
                            height: 17,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 17,
                          ),
                          InkWell(
                            onTap: () => logout(context),
                            child: Center(
                              child: Text("Logout",
                                  style: Styles.mainTextStyle.copyWith(
                                    fontSize: 18,
                                    color: Colors.red,
                                  )),
                            ),
                          )
                        ],
                      ),
                    ))),
          ),
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
                    Text(
                      "Profile",
                      style: Styles.mainTextStyle
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
          Positioned(
              top: 16,
              right: 16,
              child: SafeArea(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(EditProfilePage.routeName);
                      },
                      child: const Icon(
                        Icons.edit,
                        color: Styles.midGrayColor,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

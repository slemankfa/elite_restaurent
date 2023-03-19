import 'package:bot_toast/bot_toast.dart';
import 'package:elite/screens/dish_pages.dart/main_meal_details.dart';
import 'package:elite/screens/main_tabs_page.dart';
import 'package:elite/screens/map_pages/notifcation_page.dart';
import 'package:elite/screens/profile_pages/edit_profile_page.dart';
import 'package:elite/screens/profile_pages/my_orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'screens/profile_pages/my_resvation_list_page.dart';
import 'screens/profile_pages/points_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/profile_pages/support_chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MainTabsPage(),
      builder: BotToastInit(), //1. call BotToastInit
      navigatorObservers: [BotToastNavigatorObserver()],
      // const MainTabsPage(),
      routes: {
        NotificationPage.routeName: (ctx) => NotificationPage(),
        EditProfilePage.routeName: (context) => EditProfilePage(),
        MyOrdersPage.routeName: (ctx) => MyOrdersPage(),
        PointsPage.routeName: (ctx) => PointsPage(),
        MyReservationListPage.routeName: (context) => MyReservationListPage(),
        SupportChatPage.RouteName: (context) => SupportChatPage()
      },
    );
  }
}

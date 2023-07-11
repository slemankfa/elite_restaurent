import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elite/providers/cart_provider.dart';
import 'package:elite/providers/reservation_provider.dart';
import 'package:elite/providers/resturant_provider.dart';
import 'package:elite/screens/auth_pages/splash_screen.dart';
import 'package:elite/screens/auth_pages/start_page.dart';
import 'package:elite/screens/main_tabs_page.dart';
import 'package:elite/screens/map_pages/notifcation_page.dart';
import 'package:elite/screens/profile_pages/delete_page.dart';
import 'package:elite/screens/profile_pages/edit_profile_page.dart';
import 'package:elite/screens/profile_pages/my_orders_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'core/widgets/dismiss_keyboard.dart';
import 'providers/auth_provider.dart';
import 'screens/auth_pages/create_account_page.dart';
import 'screens/auth_pages/login_page.dart';
import 'screens/orders_pages/add_order_page.dart';
import 'screens/profile_pages/my_resvation_list_page.dart';
import 'screens/profile_pages/points_page.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/profile_pages/profile_page.dart';
import 'screens/profile_pages/support_chat_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await ScreenUtil.ensureScreenSize();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(EasyLocalization(
        supportedLocales: const [Locale('en')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en'),
        child: ChangeNotifierProvider<AuthProvider>(
          child: const MyApp(),
          create: (BuildContext context) {
            return AuthProvider();
          },
        )));
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: ResturantProvider(),
          ),
          ChangeNotifierProvider.value(
            value: ReservationProvider(),
          ),
          ChangeNotifierProvider.value(
            value: AuthProvider(),
          ),
          ChangeNotifierProvider.value(
            value: CartProvider(),
          ),
        ],
        child: RestartWidget(
          child: MaterialApp(
            title: 'Flutter Demo',
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
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
            home: FutureBuilder<bool>(
              future: Provider.of<AuthProvider>(context).tryAutoLogin(),
              builder: (context, userInformation) {
                if (userInformation.connectionState == ConnectionState.done) {
                  if (userInformation.error != null ||
                      userInformation.data == false) {
                    print('error');
                    // return const MainTabsPage();
                    return const StartPage();
                  }

                  // return const FilterPge();
                  // return ComparingPricesVendorsListPage();
                  // return ShipmentPriceCompresionPage();
                  return const MainTabsPage();
                  //  return ShipmentShowPaymentStatus(isAaramex: true,isDone: true,);
                  // return StepperTest(
                  //   activeIndex: 3,
                  // );
                }
                return SplashScreen();
              },
              // ActivitonCodePage(
              //   userMobileNumber: "0111111",
              // )
              // const LoginPage(),
            ),

            // const StartPage(),
            // const MainTabsPage(),
            builder: BotToastInit(), //1. call BotToastInit
            navigatorObservers: [BotToastNavigatorObserver()],
            routes: {
              NotificationPage.routeName: (ctx) => const NotificationPage(),
              EditProfilePage.routeName: (context) => const EditProfilePage(),
              MyOrdersPage.routeName: (ctx) => const MyOrdersPage(),
              PointsPage.routeName: (ctx) => const PointsPage(),
              MyReservationListPage.routeName: (context) =>
                  const MyReservationListPage(),
              SupportChatPage.RouteName: (context) => const SupportChatPage(),
              DeletePage.routeName: (ctx) => const DeletePage(),
              LoginPage.routeName: (ctx) => const LoginPage(),
              StartPage.routeName: (ctx) => const StartPage(),
              CreateAccountPage.routeName: (ctx) => const CreateAccountPage(
                    fromGoogle: false,
                  ),
              MainTabsPage.routeName: (ctx) => const MainTabsPage(),
              ProfilePage.routeName: (ctx) => const ProfilePage(),
              AddOrderPage.routeName: (ctx) => const AddOrderPage(
                    resturantDetails: null,
                  ),
              // ResturanMenuPage.routeName: (context) => const ResturanMenuPage(
              //     resturantDetails: null, isFormAddOrderPage: null)
            },
          ),
        ),
      ),
    );
  }
}

class RestartWidget extends StatefulWidget {
  const RestartWidget({super.key, required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()!.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}

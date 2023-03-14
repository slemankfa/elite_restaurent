import 'package:elite/core/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
  static const routeName = "/notification - page";
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 56,
            left: 1,
            right: 1,
            bottom: 16,
            child: SafeArea(
                child: Container(
                    margin: EdgeInsets.all(16), child: Placeholder())),
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
        ],
      ),
    );
  }
}

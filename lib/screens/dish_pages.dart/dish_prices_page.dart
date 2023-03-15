import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';

class DishPricesPage extends StatefulWidget {
  const DishPricesPage({super.key});

  @override
  State<DishPricesPage> createState() => _DishPricesPageState();
}

class _DishPricesPageState extends State<DishPricesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              child: SingleChildScrollView(
                // controller: ,
                child: Column(
                  children: [
                    ListTile(
                      // contentPadding: EdgeInsets.all(16),
                      trailing: Chip(
                        backgroundColor: Styles.chipBackGroundColor,
                        label: Text(
                          "20 JOD",
                          style: Styles.mainTextStyle.copyWith(
                              color: Styles.timeTextColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      ),
                      title: Text(
                        "MEAL SIZE",
                        style: Styles.mainTextStyle.copyWith(
                            color: Styles.midGrayColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Transform(
                        transform: Matrix4.translationValues(0, 6, 0),
                        child: Text(
                          "Medium Size",
                          style: Styles.mainTextStyle.copyWith(
                              color: Styles.grayColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            color: Colors.white,
            margin: EdgeInsets.all(8),
            child: CustomOutlinedButton(
                label: "Order Meal",
                // borderSide: BorderSide(),
                rectangleBorder: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                icon: Container(),
                onPressedButton: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => ResturantReviewsPage()),
                  // );
                },
                backGroundColor: Styles.mainColor,
                // backGroundColor: Styles.mainColor,
                textStyle: Styles.mainTextStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

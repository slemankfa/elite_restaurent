import 'package:elite/screens/dish_pages.dart/add_meal_review_page.dart';
import 'package:elite/screens/dish_pages.dart/meal_reviews_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';

class MealRatingsPage extends StatefulWidget {
  const MealRatingsPage({super.key});

  @override
  State<MealRatingsPage> createState() => _MealRatingsPageState();
}

class _MealRatingsPageState extends State<MealRatingsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "55 ratings",
                  style: Styles.mainTextStyle
                      .copyWith(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: LinearPercentIndicator(
                  // width: double.infinity,
                  lineHeight: 10.0,
                  percent: 0.8,
                  leading: Text("5 star"),
                  trailing: Text("80%"),
                  // barRadius: Radius.circular(radius),
                  backgroundColor: Colors.grey.shade100,
                  progressColor: Styles.progressColor,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: LinearPercentIndicator(
                  // width: double.infinity,
                  lineHeight: 10.0,
                  percent: 0.9,
                  leading: Text("4 star"),
                  trailing: Text("90%"),
                  // barRadius: Radius.circular(radius),
                  backgroundColor: Colors.grey.shade100,
                  progressColor: Styles.progressColor,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: LinearPercentIndicator(
                  // width: double.infinity,
                  lineHeight: 10.0,
                  percent: 0.2,
                  leading: Text("3 star"),
                  trailing: Text("20%"),
                  // barRadius: Radius.circular(radius),
                  backgroundColor: Colors.grey.shade100,
                  progressColor: Styles.progressColor,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: LinearPercentIndicator(
                  // width: double.infinity,
                  lineHeight: 10.0,
                  percent: 0.05,
                  leading: Text("2 star"),
                  trailing: Text("5%"),
                  // barRadius: Radius.circular(radius),
                  backgroundColor: Colors.grey.shade100,
                  progressColor: Styles.progressColor,
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              Padding(
                padding: EdgeInsets.all(0),
                child: LinearPercentIndicator(
                  // width: double.infinity,
                  lineHeight: 10.0,
                  percent: 0.0,
                  leading: Text("1 star"),
                  trailing: Text("0%"),
                  // barRadius: Radius.circular(radius),
                  backgroundColor: Colors.grey.shade100,
                  progressColor: Styles.progressColor,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomOutlinedButton(
                  label: "View reviews",
                  icon: Container(),
                  isIconVisible: false,
                  onPressedButton: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MealReviewsPage()),
                    );
                  },
                  borderSide: BorderSide(
                    color: Colors.black.withOpacity(0.16),
                  ),
                  // backGroundColor: Styles.mainColor,
                  textStyle: Styles.mainTextStyle.copyWith(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              CustomOutlinedButton(
                  label: "Write a review",
                  isIconVisible: false,
                  icon: Container(),
                  onPressedButton: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMealReviewPage()),
                    );
                  },
                  borderSide: BorderSide(
                    color: Colors.black.withOpacity(0.16),
                  ),
                  // backGroundColor: Styles.mainColor,
                  textStyle: Styles.mainTextStyle.copyWith(
                      color: Colors.black.withOpacity(0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

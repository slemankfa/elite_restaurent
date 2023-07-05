import 'package:elite/core/helper_methods.dart';
import 'package:flutter/material.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';
import '../../core/widgets/star_rating_parecntage_item.dart';
import '../../models/menu_item_meals_list_model.dart';
import '../../models/resturant_model.dart';
import '../auth_pages/start_page.dart';
import 'add_meal_review_page.dart';
import 'meal_reviews_page.dart';

class MealRatingsPage extends StatefulWidget {
  const MealRatingsPage(
      {super.key, required this.meal, required this.resturantDetails});

  @override
  State<MealRatingsPage> createState() => _MealRatingsPageState();

  final MenuItemMealsListModel meal;
  final ResturantModel resturantDetails;
}

class _MealRatingsPageState extends State<MealRatingsPage>
    with AutomaticKeepAliveClientMixin {
  HelperMethods _helperMethods = HelperMethods();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "${widget.meal.totalRating} ratings",
                  style: Styles.mainTextStyle
                      .copyWith(fontSize: 14, color: Colors.grey),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                  children: widget.meal.starRatingParcentageList
                      .map((ratingItem) => StarRatingParecntageItem(
                            ratingItem: ratingItem,
                          ))
                      .toList()),
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
                          builder: (context) => MealReviewsPage(
                                meal: widget.meal,
                                resturantDetails: widget.resturantDetails,
                              )),
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
                  onPressedButton: () async {
                    final _isGuestUser = await _helperMethods.checkIsGuest();
                    if (_isGuestUser) {
                      Navigator.of(context).pushNamed(StartPage.routeName);
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddMealReviewPage(
                                meal: widget.meal,
                                resturantDetails: widget.resturantDetails,
                              )),
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

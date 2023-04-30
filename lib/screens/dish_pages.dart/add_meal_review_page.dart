import 'package:bot_toast/bot_toast.dart';
import 'package:elite/core/helper_methods.dart';
import 'package:elite/core/styles.dart';
import 'package:elite/providers/resturant_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/custom_outline_button.dart';
import '../../models/menu_item_meals_list_model.dart';
import '../../models/resturant_model.dart';

class AddMealReviewPage extends StatefulWidget {
  const AddMealReviewPage(
      {super.key, required this.meal, required this.resturantDetails});

  @override
  State<AddMealReviewPage> createState() => _AddMealReviewPageState();
  // static const routeNam

  final MenuItemMealsListModel meal;
  final ResturantModel resturantDetails;
}

class _AddMealReviewPageState extends State<AddMealReviewPage> {
  final HelperMethods _helperMethods = HelperMethods();
  double ratings = 1;
  final TextEditingController _commentController = TextEditingController();
  late Function popUpProgressIndcator;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _commentController.dispose();
    super.dispose();
  }

  postReview() async {
    // if(_commentController.text.trim().isEmpty){
    //   BotToast.showText(text: "");
    //   return ;
    // }
    try {
      popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();

      Provider.of<ResturantProvider>(context, listen: false)
          .addMealReview(
              rating: ratings.round(),
              review: _commentController.text,
              restId: widget.resturantDetails.id,
              mealId: widget.meal.mealId)
          .then((status) {
        popUpProgressIndcator.call();
        if (status) {
          Navigator.of(context).pop();
        } else {
          BotToast.showText(text: "Something went Wrong!");
        }
      });
    } catch (e) {
      print(e.toString());
      popUpProgressIndcator.call();
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
            "Add Review",
            style: Styles.appBarTextStyle,
          ),
        ),
        body: Container(
          margin: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "How was your experience?",
                  style: Styles.mainTextStyle.copyWith(
                      fontSize: 18,
                      color: Styles.grayColor,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Styles.RatingRivewBoxBorderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your rate",
                        style: Styles.mainTextStyle.copyWith(
                          fontSize: 19,
                          color: Styles.grayColor,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      RatingBar.builder(
                        initialRating: 1,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: false,
                        itemCount: 5,
                        glow: false,
                        unratedColor: Styles.unselectedStarColor,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) =>
                            SvgPicture.asset("assets/icons/star.svg"),
                        onRatingUpdate: (rating) {
                          print(rating);
                          ratings = rating;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 21,
                ),
                Text(
                  "Aditional Notes",
                  style: Styles.mainTextStyle.copyWith(
                    fontSize: 16,
                    color: Styles.userNameColor,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _commentController,
                  // validator: ((value) => _validationHelper.validateField(value!)),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  style: Styles.mainTextStyle,
                  maxLines: 5,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Styles.mainColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: const BorderSide(
                        color: Styles.mainColor,
                        width: 1.0,
                      ),
                    ),
                    focusColor: Colors.black,
                    focusedErrorBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.red,
                      ),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                CustomOutlinedButton(
                    label: "POST",
                    icon: Container(),
                    isIconVisible: false,
                    onPressedButton: postReview,
                    borderSide: const BorderSide(
                      color: Styles.mainColor,
                    ),
                    // backGroundColor: Styles.mainColor,
                    textStyle: Styles.mainTextStyle.copyWith(
                        color: Styles.mainColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

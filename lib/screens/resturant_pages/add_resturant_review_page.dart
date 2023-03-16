import 'package:elite/core/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/widgets/custom_outline_button.dart';

class AddResturantReviewPage extends StatefulWidget {
  const AddResturantReviewPage({super.key});

  @override
  State<AddResturantReviewPage> createState() => _AddResturantReviewPageState();
  // static const routeNam
}

class _AddResturantReviewPageState extends State<AddResturantReviewPage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Styles.grayColor),
          title: Text(
            "Add Review",
            style: Styles.appBarTextStyle,
          ),
        ),
        body: Container(
          margin: EdgeInsets.all(16),
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
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Styles.RatingRivewBoxBorderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good treatment",
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
                        allowHalfRating: true,
                        itemCount: 5,
                        glow: false,
                        unratedColor: Styles.unselectedStarColor,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) =>
                            SvgPicture.asset("assets/icons/star.svg"),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Styles.RatingRivewBoxBorderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Request Speed",
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
                        allowHalfRating: true,
                        itemCount: 5,
                        glow: false,
                        unratedColor: Styles.unselectedStarColor,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) =>
                            SvgPicture.asset("assets/icons/star.svg"),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 11,
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Styles.RatingRivewBoxBorderColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Sanitation",
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
                        allowHalfRating: true,
                        itemCount: 5,
                        glow: false,
                        unratedColor: Styles.unselectedStarColor,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) =>
                            SvgPicture.asset("assets/icons/star.svg"),
                        onRatingUpdate: (rating) {
                          print(rating);
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
                  // controller: _shipmentDescrpationController,
                  // validator: ((value) => _validationHelper.validateField(value!)),
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  style: Styles.mainTextStyle,
                  maxLines: 5,
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Styles.mainColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(
                        color: Styles.mainColor,
                        width: 1.0,
                      ),
                    ),
                    focusColor: Colors.black,
                    focusedErrorBorder: OutlineInputBorder(
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
                    onPressedButton: () {
                    
                    },
                    borderSide: BorderSide(
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

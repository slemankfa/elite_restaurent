import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/styles.dart';
import '../../../models/meal_review_model.dart';

class MealReviewItem extends StatelessWidget {
  const MealReviewItem({
    super.key,
    required this.review,
  });

  final MealReviewModel review;

  convertDate(String? date) {
    if (date == null) return "";
    // "2023-03-18T07:19:23.64"
    DateTime tempDate =
        DateFormat("yyyy-MM-ddThh:mm:ss", 'en_US').parse(date);
    return DateFormat("MMM dd yyyy").format(tempDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: [
          Row(
            children: [
              // user logo
              Flexible(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl:
                    review.image,
                        // "https://png.pngtree.com/png-clipart/20200727/original/pngtree-restaurant-logo-design-vector-template-png-image_5441058.jpg",
                    height: 64,
                    width: 64,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const FlutterLogo(
                      size: 64,
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: Styles.mainTextStyle.copyWith(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              RatingBar.builder(
                                initialRating: review.rate,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                glow: false,
                                itemSize: 15,
                                tapOnlyMode: true,
                                ignoreGestures: true,
                                unratedColor: Styles.unselectedStarColor,
                                // itemPadding:
                                //     EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) =>
                                    SvgPicture.asset("assets/icons/star.svg"),
                                onRatingUpdate: (rating) {
                                  print(rating);
                                },
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Flexible(
                                  child: Text(
                                review.rate.toString(),
                                style: Styles.mainTextStyle.copyWith(
                                  color: Styles.commentDateTextColor,
                                  fontSize: 16,
                                ),
                              )),
                            ],
                          ),
                        ),
                        Flexible(
                          child: Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              convertDate(review.date),
                              style: Styles.mainTextStyle.copyWith(
                                color: Styles.commentDateTextColor,
                                fontSize: 16,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      review.review,
                      style: Styles.mainTextStyle.copyWith(
                        color: Styles.grayColor,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

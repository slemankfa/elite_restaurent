import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/styles.dart';

class DishReviewsPage extends StatefulWidget {
  const DishReviewsPage({super.key});

  @override
  State<DishReviewsPage> createState() => _DishReviewsPageState();
}

class _DishReviewsPageState extends State<DishReviewsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Styles.grayColor),
        title: Text(
          "All reviews",
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
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
                                "https://png.pngtree.com/png-clipart/20200727/original/pngtree-restaurant-logo-design-vector-template-png-image_5441058.jpg",
                            height: 64,
                            width: 64,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const FlutterLogo(
                              size: 64,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
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
                              "Annabell41",
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
                                        initialRating: 1,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        glow: false,
                                        itemSize: 15,
                                        tapOnlyMode: true,
                                        ignoreGestures: true,
                                        unratedColor:
                                            Styles.unselectedStarColor,
                                        // itemPadding:
                                        //     EdgeInsets.symmetric(horizontal: 4.0),
                                        itemBuilder: (context, _) =>
                                            SvgPicture.asset(
                                                "assets/icons/star.svg"),
                                        onRatingUpdate: (rating) {
                                          print(rating);
                                        },
                                      ),
                                      const SizedBox(
                                        width: 12,
                                      ),
                                      Flexible(
                                          child: Text(
                                        "4.0",
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
                                      "Sep 16 2002",
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
                              "Qui doloremque beatae iure consequatur est commodi sed.",
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
            )
          ],
        ),
      ),
    );
  }
}

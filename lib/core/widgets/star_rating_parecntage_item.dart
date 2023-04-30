import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../models/star_rating_parentage.dart';
import '../styles.dart';

class StarRatingParecntageItem extends StatelessWidget {
  const StarRatingParecntageItem({
    super.key,
    required this.ratingItem,
  });
  final StarRatingParcentage ratingItem;
  // percent: ratingItem.starPercentage.round() / 100,
  //           leading: Text("${ratingItem.starRate} star"),
  //           trailing: Text("${(ratingItem.starPercentage * 100).round() / 100.0}%")
  @override
  Widget build(BuildContext context) {
    // print(ratingItem.starPercentage.roundToDouble() / 100);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(0),
          child: LinearPercentIndicator(
            // width: double.infinity,
            lineHeight: 10.0,
            percent: ratingItem.starPercentage.round() / 100,
            leading: Text("${ratingItem.starRate} star"),
            trailing:
                Text("${(ratingItem.starPercentage * 100).round() / 100.0}%"),
            // trailing: Text(
            //     "${(ratingItem.starPercentage.round() / 100) * 100}%"),
            // barRadius: Radius.circular(radius),
            backgroundColor: Colors.grey.shade100,
            progressColor: Styles.progressColor,
          ),
        ),
        const SizedBox(
          height: 14,
        ),
      ],
    );
  }
}

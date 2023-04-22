import 'package:flutter/material.dart';

import '../../../core/styles.dart';
import '../../../models/meal_size_model.dart';

class MealSizeListItem extends StatelessWidget {
  const MealSizeListItem({
    super.key,
    required this.mealSize,
  });

  final MealSizeModel mealSize;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          // contentPadding: EdgeInsets.all(),
          trailing: Chip(
            backgroundColor: Styles.chipBackGroundColor,
            label: Text(
              "${mealSize.price} JOD",
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
              mealSize.name,
              style: Styles.mainTextStyle.copyWith(
                  color: Styles.grayColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

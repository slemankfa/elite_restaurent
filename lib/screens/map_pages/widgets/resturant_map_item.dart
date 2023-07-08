import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/styles.dart';
import '../../../models/resturant_model.dart';

class ResturantMapItem extends StatelessWidget {
  const ResturantMapItem({
    super.key,
    required this.resturantModel,
  });

  final ResturantModel resturantModel;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: CachedNetworkImage(
            imageUrl: resturantModel.logo,
            height: 64,
            width: 64,
            fit: BoxFit.cover,
            placeholder: (context, url) => Image.asset(
              "assets/images/elite_logo.png",
              width: 64,
              height: 64,
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          resturantModel.name,
          style: Styles.mainTextStyle.copyWith(
              color: Styles.resturentNameColor,
              fontSize: 19,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 8,
        ),
        Flexible(
          child: RichText(
            text: TextSpan(
              text: 'Accepting orders and booking until ',
              style: Styles.mainTextStyle
                  .copyWith(fontSize: 16, color: Colors.grey),
              children: <TextSpan>[
                TextSpan(
                  text: '8:30',
                  style: Styles.mainTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Styles.timeTextColor),
                ),
                const TextSpan(text: ' PM'),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Row(
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    resturantModel.averageRating.toString(),
                    style: Styles.mainTextStyle.copyWith(
                        color: Styles.mainColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    width: 6,
                  ),
                  SvgPicture.asset("assets/icons/star.svg"),
                  const SizedBox(
                    width: 6,
                  ),
                  Flexible(
                    child: Text(
                      "(${resturantModel.totalRating})",
                      style: Styles.mainTextStyle.copyWith(
                        color: Styles.midGrayColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset("assets/icons/clock.svg"),
                  const SizedBox(
                    width: 6,
                  ),
                  Flexible(
                    child: Text(
                      "3 min walk",
                      style: Styles.mainTextStyle.copyWith(
                        color: Styles.midGrayColor,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/styles.dart';
import '../dish_pages.dart/main_meal_details.dart';

class ResturantMenuItemListPage extends StatefulWidget {
  const ResturantMenuItemListPage({super.key, required this.itemName});

  @override
  State<ResturantMenuItemListPage> createState() =>
      _ResturantMenuItemListPageState();

  final String itemName;
}

class _ResturantMenuItemListPageState extends State<ResturantMenuItemListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Styles.grayColor),
        title: Text(
          widget.itemName,
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MaiMealDetailsPage()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Styles.listTileBorderColr,
                    )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://png.pngtree.com/png-clipart/20200727/original/pngtree-restaurant-logo-design-vector-template-png-image_5441058.jpg",
                        height: 64,
                        width: 64,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const FlutterLogo(
                          size: 64,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Margherita Pizza",
                      style: Styles.mainTextStyle.copyWith(
                        color: Styles.userNameColor,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Container(
                      height: 20,
                      child: Text(
                        "This margherita pizza recipe tastes like an artisan pie from Italy! It's the perfect meld of zingy tomato sauce, gooey cheese and chewy crust.",
                        style: Styles.mainTextStyle.copyWith(
                          color: Styles.grayColor,
                          fontSize: 16,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "4.9",
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
                            "(55 Reviews)",
                            style: Styles.mainTextStyle.copyWith(
                              color: Styles.midGrayColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

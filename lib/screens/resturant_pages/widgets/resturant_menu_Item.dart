import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/styles.dart';
import '../../../models/resturant_menu_item.dart';
import '../../../models/resturant_model.dart';
import '../resturant_menu_item_meals_list_page.dart';

class ResturantMenuItem extends StatelessWidget {
  const ResturantMenuItem({
    super.key,
    required ResturantMenuItemModel menusItem,
    required this.resturantDetails,
    required this.isFormAddOrderPage,
  }) : _menuItem = menusItem;

  final ResturantMenuItemModel _menuItem;
  final ResturantModel resturantDetails;
  final bool isFormAddOrderPage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ResturantMenuItemMealsListPage(
                        menuItem: _menuItem,
                        resturantDetails: resturantDetails,
                        isFormAddOrderPage: isFormAddOrderPage,
                      )),
            );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: _menuItem.image,
              height: 40,
              width: 40,
              fit: BoxFit.cover,
              placeholder: (context, url) => const FlutterLogo(
                size: 40,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          // Container(
          //   width: 40,
          //   height: 40,
          //   padding: EdgeInsets.all(8),
          //   decoration: BoxDecoration(
          //     // shape: BoxShape.circle,
          //     borderRadius: BorderRadius.circular(8),
          //     color: Styles.listTileBorderColr,
          //   ),
          //   child: SvgPicture.asset(
          //     "assets/icons/pizza.svg",
          //     width: 20,
          //     height: 20,
          //   ),
          // ),
          title: Text(
            _menuItem.name,
            style: Styles.mainTextStyle
                .copyWith(color: Styles.grayColor, fontSize: 18),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios_outlined,
            color: Styles.grayColor,
          ),
        ),
        const Divider(),
      ],
    );
  }
}

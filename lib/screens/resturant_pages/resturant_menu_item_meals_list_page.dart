import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite/core/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../core/styles.dart';
import '../../models/menu_item_meals_list_model.dart';
import '../../models/resturant_menu_item.dart';
import '../../models/resturant_model.dart';
import '../../providers/resturant_provider.dart';
import '../dish_pages.dart/main_meal_details.dart';

class ResturantMenuItemMealsListPage extends StatefulWidget {
  const ResturantMenuItemMealsListPage(
      {super.key, required this.menuItem, required this.resturantDetails});

  @override
  State<ResturantMenuItemMealsListPage> createState() =>
      _ResturantMenuItemMealsListPageState();

  final ResturantMenuItemModel menuItem;
  final ResturantModel resturantDetails;
}

class _ResturantMenuItemMealsListPageState
    extends State<ResturantMenuItemMealsListPage> {
  int _pageNumber = 1;
  ScrollController _mealsListController = ScrollController();
  HelperMethods _helperMethods = HelperMethods();
  late Function popUpProgressIndcator;
  bool _isThereNextPage = false;
  List<MenuItemMealsListModel> _mealsList = [];

  @override
  void initState() {
    _mealsListController.addListener(() {
      if (_mealsListController.position.pixels ==
          _mealsListController.position.maxScrollExtent) {
        print("from inist satate");

        if (!_isThereNextPage) return;
        fetchMeals();
      }
    });

    fetchMeals();

    super.initState();
  }

  Future refreshList() async {
    _pageNumber = 1;
    fetchMeals();
  }

  Future fetchMeals() async {
    popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();
    try {
      await Provider.of<ResturantProvider>(context, listen: false)
          .getResturantMenuItemMeals(
              context: context,
              pageNumber: _pageNumber,
              menuItemId: widget.menuItem.id,
              restId: widget.resturantDetails.id) //3
          .then((informationMap) {
        if (_pageNumber == 1) {
          _mealsList = informationMap["list"];
        } else {
          _mealsList.addAll(informationMap["list"]);
        }
        setState(() {
          _isThereNextPage = informationMap["isThereNextPage"] ?? false;
          _pageNumber++;
          popUpProgressIndcator.call();
        });
      });
    } catch (e) {
      popUpProgressIndcator.call();
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Styles.grayColor),
        title: Text(
          widget.menuItem.name,
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: _mealsList.isEmpty
            ? Center(
                child: Text(
                  "لا يوجد قائمة",
                  style: Styles.mainTextStyle,
                ),
              )
            : RefreshIndicator(
                onRefresh: refreshList,
                child: ListView.separated(
                    separatorBuilder: (context, index) => const SizedBox(
                          height: 12,
                        ),
                    itemCount: _mealsList.length,
                    itemBuilder: (context, index) {
                      return MenuItemMeals(
                        meal: _mealsList[index],
                        resturantDetails: widget.resturantDetails,
                      );
                    }),
              ),
      ),
    );
  }
}

class MenuItemMeals extends StatelessWidget {
  const MenuItemMeals({
    super.key,
    required this.meal,
    required this.resturantDetails,
  });

  final MenuItemMealsListModel meal;
  final ResturantModel resturantDetails;

  @override
  Widget build(BuildContext context) {
    // print( meal.mealImage);
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MaiMealDetailsPage(
                    meal: meal,
                    resturantDetails: resturantDetails,
                  )),
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
                imageUrl:  "https://png.pngtree.com/png-clipart/20200727/original/pngtree-restaurant-logo-design-vector-template-png-image_5441058.jpg",
                //  meal.mealImage,
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
              meal.mealName,
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
    );
  }
}
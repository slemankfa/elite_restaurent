import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../core/helper_methods.dart';
import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';
import '../../models/meal_size_model.dart';
import '../../models/menu_item_meals_list_model.dart';
import '../../models/resturant_model.dart';
import '../../providers/resturant_provider.dart';

class MealPricesPage extends StatefulWidget {
  MealPricesPage(
      {super.key,
      required this.scrollController,
      required this.meal,
      required this.resturantDetails});

  @override
  State<MealPricesPage> createState() => _MealPricesPageState();

  final ScrollController scrollController;
  final MenuItemMealsListModel meal;
  final ResturantModel resturantDetails;
}

class _MealPricesPageState extends State<MealPricesPage>
    with AutomaticKeepAliveClientMixin {
  int _pageNumber = 1;
  ScrollController _mealsListController = ScrollController();
  HelperMethods _helperMethods = HelperMethods();
  late Function popUpProgressIndcator;
  List<MealSizeModel> _mealSizedList = [];
  bool _isLoading = false;

  @override
  void initState() {
    // _mealsListController.addListener(() {
    //   if (_mealsListController.position.pixels ==
    //       _mealsListController.position.maxScrollExtent) {
    //     print("from inist satate");

    //     if (!_isThereNextPage) return;
    //     fetchMeals();
    //   }
    // });

    fetchMealSizes();

    super.initState();
  }

  Future refreshList() async {
    _pageNumber = 1;
    fetchMealSizes();
  }

  Future fetchMealSizes() async {
    // popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ResturantProvider>(context, listen: false)
          .getMealSize(
              context: context,
              pageNumber: _pageNumber,
              menuItemId: widget.meal.mealId,
              restId: widget.resturantDetails.id) //3
          .then((list) {
        // if (_pageNumber == 1) {
        //   _mealsList = informationMap["list"];
        // } else {
        //   _mealsList.addAll(informationMap["list"]);
        // }
        _mealSizedList = list;
        setState(() {
          _isLoading = false;
        });
        // setState(() {
        //   // _isThereNextPage = informationMap["isThereNextPage"] ?? false;
        //   // _pageNumber++;
        //   // popUpProgressIndcator.call();
        // });
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center(
              child: _helperMethods.progressIndcator(),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                      // margin: EdgeInsets.all(16),
                      child: _mealSizedList.isEmpty
                          ? Center(
                              child: Text(
                                "لا يوجد قائمة",
                                style: Styles.mainTextStyle,
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: refreshList,
                              child: ListView.separated(
                                  padding: EdgeInsets.all(0),
                                  separatorBuilder: (context, index) =>
                                      const SizedBox(
                                        height: 0,
                                      ),
                                  itemCount: _mealSizedList.length,
                                  itemBuilder: (context, index) {
                                    return MealSizeListItem(
                                      mealSize: _mealSizedList[index],
                                    );
                                  }),
                            )),
                ),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.all(8),
                  child: CustomOutlinedButton(
                      label: "Order Meal",
                      // borderSide: BorderSide(),
                      rectangleBorder: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      icon: Container(),
                      isIconVisible: false,
                      onPressedButton: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => ResturantReviewsPage()),
                        // );
                      },
                      backGroundColor: Styles.mainColor,
                      // backGroundColor: Styles.mainColor,
                      textStyle: Styles.mainTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

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
        Divider(),
      ],
    );
  }
}

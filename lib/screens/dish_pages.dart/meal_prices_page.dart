import 'package:bot_toast/bot_toast.dart';
import 'package:elite/providers/cart_provider.dart';
import 'package:elite/screens/orders_pages/add_order_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helper_methods.dart';
import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';
import '../../models/meal_size_model.dart';
import '../../models/menu_item_meals_list_model.dart';
import '../../models/resturant_model.dart';
import '../../providers/resturant_provider.dart';
import 'widgets/meal_size_list_item.dart';

class MealPricesPage extends StatefulWidget {
  const MealPricesPage(
      {super.key,
      required this.scrollController,
      required this.meal,
      required this.resturantDetails,
      required this.isFormAddOrderPage});

  @override
  State<MealPricesPage> createState() => _MealPricesPageState();

  final ScrollController scrollController;
  final MenuItemMealsListModel meal;
  final ResturantModel resturantDetails;
  final bool isFormAddOrderPage;
}

class _MealPricesPageState extends State<MealPricesPage>
    with AutomaticKeepAliveClientMixin {
  int _pageNumber = 1;
  final ScrollController _mealsListController = ScrollController();
  final HelperMethods _helperMethods = HelperMethods();
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
    final cart = Provider.of<CartProvider>(context, listen: false);
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
                                  padding: const EdgeInsets.all(0),
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
                SafeArea(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.all(8),
                    child: CustomOutlinedButton(
                        label:
                            widget.isFormAddOrderPage ? "Add This" : "Order Meal",
                        // borderSide: BorderSide(),
                        rectangleBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        icon: Container(),
                        isIconVisible: false,
                        onPressedButton: () {
                          if (_mealSizedList.isEmpty) {
                            BotToast.showText(text: "There are no meal sizes");
                            return;
                          }
                          if (!widget.isFormAddOrderPage) {
                            cart.clear();
                          }
                
                          print(widget.meal.sideDhshes.length);
                          cart.addItem(
                              mealId: widget.meal.mealId,
                              size: _mealSizedList[0],
                              price: _mealSizedList[0].price,
                              mealImage: widget.meal.mealImage,
                              sideDishes: [...widget.meal.sideDhshes],
                              title: widget.meal.mealName,
                              mealSizeList: _mealSizedList);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddOrderPage(
                                      resturantDetails: widget.resturantDetails,
                                    )),
                          );
                        },
                        backGroundColor: Styles.mainColor,
                        // backGroundColor: Styles.mainColor,
                        textStyle: Styles.mainTextStyle.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

import 'package:elite/core/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';

import '../../core/helper_methods.dart';
import '../../models/menu_item_meals_list_model.dart';
import '../../providers/resturant_provider.dart';

class DishDesciptionPage extends StatefulWidget {
  const DishDesciptionPage({super.key, required this.meal});

  @override
  State<DishDesciptionPage> createState() => _DishDesciptionPageState();
  final MenuItemMealsListModel meal;
}

class _DishDesciptionPageState extends State<DishDesciptionPage>
    with AutomaticKeepAliveClientMixin {
  int _pageNumber = 1;
  final ScrollController _mealsReviewsListController = ScrollController();
  final HelperMethods _helperMethods = HelperMethods();
  late Function popUpProgressIndcator;
  final bool _isThereNextPage = false;
  bool _isLoading = false;

  String? mealDescrpation = "";
  @override
  void initState() {
    // _mealsReviewsListController.addListener(() {
    //   if (_mealsReviewsListController.position.pixels ==
    //       _mealsReviewsListController.position.maxScrollExtent) {
    //     print("from inist satate");

    //     if (!_isThereNextPage) return;
    //     fetchMealReview();
    //   }
    // });

    fetchMealDescrption();

    super.initState();
  }

  Future refreshList() async {
    _pageNumber = 1;
    fetchMealDescrption();
  }

  Future fetchMealDescrption() async {
    // popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ResturantProvider>(context, listen: false)
          .getMealDescrption(
              context: context, menuItemId: widget.meal.mealId) //3
          .then((descrptionBody) {
        mealDescrpation = descrptionBody;
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      // popUpProgressIndcator.call();
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? _helperMethods.progressIndcator()
          : mealDescrpation == null
              ? Text(
                  "Something went wrong",
                  style: Styles.mainTextStyle,
                )
              : SingleChildScrollView(
                  child: Container(
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(Styles.GLOABAL_EDGE),
                    //     border: Border.all(color: Styles.aboutUsBackgroundItem),
                    //     color: Styles.aboutUsBackgroundItem),
                    child: HtmlWidget(
                      mealDescrpation.toString(),
                      textStyle: Styles.mainTextStyle,
                      webView: true,
                    ),
                  ),
                ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => false;
}

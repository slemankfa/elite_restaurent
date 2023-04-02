import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elite/screens/dish_pages.dart/widgets/meal_review_item.dart';
import 'package:elite/screens/resturant_pages/widgets/resturant_review_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../core/helper_methods.dart';
import '../../core/styles.dart';
import '../../models/meal_review_model.dart';
import '../../models/menu_item_meals_list_model.dart';
import '../../models/resturant_model.dart';
import '../../models/resturant_review_model.dart';
import '../../providers/resturant_provider.dart';

class ResturantReviewsPage extends StatefulWidget {
  const ResturantReviewsPage({super.key, required this.resturantDetails});

  @override
  State<ResturantReviewsPage> createState() => _ResturantReviewsPageState();
  final ResturantModel resturantDetails;
}

class _ResturantReviewsPageState extends State<ResturantReviewsPage> {
  int _pageNumber = 1;
  ScrollController _mealsReviewsListController = ScrollController();
  HelperMethods _helperMethods = HelperMethods();
  late Function popUpProgressIndcator;
  bool _isThereNextPage = false;
  List<ResturantReviewModel> _reviewsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    _mealsReviewsListController.addListener(() {
      if (_mealsReviewsListController.position.pixels ==
          _mealsReviewsListController.position.maxScrollExtent) {
        print("from inist satate");

        if (!_isThereNextPage) return;
        fetchMealReview();
      }
    });

    fetchMealReview();

    super.initState();
  }

  Future refreshList() async {
    _pageNumber = 1;
    fetchMealReview();
  }

  Future fetchMealReview() async {
    // popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ResturantProvider>(context, listen: false)
          .getResturantReviews(
              context: context,
              pageNumber: _pageNumber,
              restId: widget.resturantDetails.id) //3
          .then((informationMap) {
        if (_pageNumber == 1) {
          _reviewsList = informationMap["list"];
        } else {
          _reviewsList.addAll(informationMap["list"]);
        }
        setState(() {
          _isThereNextPage = informationMap["isThereNextPage"] ?? false;
          _pageNumber++;
          popUpProgressIndcator.call();
        });

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
          child: _isLoading
              ? Center(
                  child: _helperMethods.progressIndcator(),
                )
              : _reviewsList.isEmpty
                  ? const Center(
                      child: Text("Reviews is Empty"),
                    )
                  : RefreshIndicator(
                      onRefresh: refreshList,
                      child: ListView.separated(
                          controller: _mealsReviewsListController,
                          itemBuilder: (context, index) {
                            return ResturantReviewItem(
                              review: _reviewsList[index],
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                                height: 12,
                              ),
                          itemCount: _reviewsList.length),
                    )),
    );
  }
}

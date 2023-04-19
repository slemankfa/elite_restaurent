import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elite/core/styles.dart';
import 'package:elite/screens/dish_pages.dart/meal_description_page.dart';
import 'package:elite/screens/dish_pages.dart/meal_nutrations_page.dart';
import 'package:elite/screens/dish_pages.dart/meal_prices_page.dart';
import 'package:elite/screens/dish_pages.dart/meal_ratings_page.dart';
import 'package:flutter/material.dart';

import '../../core/widgets/custom_outline_button.dart';
import '../../models/menu_item_meals_list_model.dart';
import '../../models/resturant_model.dart';
import 'widgets/dish_image_header.dart';

class MaiMealDetailsPage extends StatefulWidget {
  const MaiMealDetailsPage(
      {super.key, required this.meal, required this.resturantDetails});

  @override
  State<MaiMealDetailsPage> createState() => _MaiMealDetailsPageState();

  final MenuItemMealsListModel meal;
  final ResturantModel resturantDetails;
}

class _MaiMealDetailsPageState extends State<MaiMealDetailsPage>
    with SingleTickerProviderStateMixin {
  final List<String> tabs = <String>[
    'Description',
    'Nutiration',
    "Prices",
    "Ratings"
  ];

  final List<String> resturantImages = [
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
  ];

  var _scrollController, _tabController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _tabController = TabController(vsync: this, length: 4);
    _tabController.addListener(() {
      // print("it changes");
      if (_tabController.index == 2 || _tabController.index == 3) {
        if (_scrollController.positions.isEmpty) return;
        _scrollController.animateTo(
          _scrollController.position.minScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
    super.initState();
  }

  ScrollController mainMealPriceScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            _buildSliverAppBar(innerBoxIsScrolled, tabs, resturantImages)
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: <Widget>[
            const DishDesciptionPage(),
            const MealNatruationsPage(),
            MealPricesPage(
              scrollController: mainMealPriceScrollController,
              meal: widget.meal,
              resturantDetails: widget.resturantDetails,
            ),
            MealRatingsPage(
              meal: widget.meal,
              resturantDetails: widget.resturantDetails,
            )
          ],
        ),
      ),
    );
  }

  // children: [
  // DishDesciptionPage(),
  // DishNatruatonsPage(),
  // DishPricesPage(),
  // DishRatingsPage()
  // ],
  SliverAppBar _buildSliverAppBar(
    bool innerBoxIsScrolled,
    List<String> tabs,
    List<String> images,
  ) {
    return SliverAppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: innerBoxIsScrolled
          ? Text(
              "Creamy Shrimp Pasta",
              style: Styles.appBarTextStyle,
            )
          : null, // This is the title in the app bar.
      pinned: true,
      expandedHeight: 345,
      flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: DishImagesHeader(
            images: images,
            meal: widget.meal,
            resturantDetails: widget.resturantDetails,
          )),
      // The "forceElevated" property causes the SliverAppBar to show
      // a shadow. The "innerBoxIsScrolled" parameter is true when the
      // inner scroll view is scrolled beyond its "zero" point, i.e.
      // when it appears to be scrolled below the SliverAppBar.
      // Without this, there are cases where the shadow would appear
      // or not appear inappropriately, because the SliverAppBar is
      // not actually aware of the precise position of the inner
      // scroll views.
      forceElevated: innerBoxIsScrolled,
      bottom: TabBar(
        controller: _tabController,

        isScrollable: true,
        onTap: (index) {
          if (index == 2 || index == 3) {
            print("login here");
            if (_scrollController.positions.isEmpty) return;
            _scrollController.animateTo(
              _scrollController.position.minScrollExtent,
              curve: Curves.easeOut,
              duration: const Duration(milliseconds: 300),
            );
          }
        },
        indicatorColor: Styles.mainColor,
        labelColor: Styles.mainColor,
        unselectedLabelColor: Styles.grayColor,
        unselectedLabelStyle: Styles.mainTextStyle.copyWith(
          fontSize: 16,
          color: Styles.grayColor,
        ),
        labelStyle: Styles.mainTextStyle.copyWith(
            fontSize: 17, color: Styles.mainColor, fontWeight: FontWeight.w600),
        // These are the widgets to put in each tab in the tab bar.
        tabs: tabs.map((String name) => Tab(text: name)).toList(),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite/screens/resturant_pages/add_resturant_review_page.dart';
import 'package:elite/screens/resturant_pages/resturant_reviews_page.dart';
import 'package:elite/screens/resturant_pages/widgets/resturant_image_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';

class ResturentDetailPage extends StatefulWidget {
  ResturentDetailPage({Key? key}) : super(key: key);

  @override
  _ResturentDetailPageState createState() => _ResturentDetailPageState();
}

class _ResturentDetailPageState extends State<ResturentDetailPage>
    with TickerProviderStateMixin {
  final scrollDirection = Axis.vertical;
  double expandedHeight = 210;

  late ScrollController controller;

  bool isExpaned = true;
  bool get _isAppBarExpanded {
    return controller.hasClients && controller.offset > (160 - kToolbarHeight);
  }

  @override
  void initState() {
    // controller = ScrollController();

    super.initState();

    controller = ScrollController(
        // viewportBoundaryGetter: () =>
        //     Rect.fromLTRB(0, 0, 0, MediaQuery.of(context).padding.bottom),
        // axis: scrollDirection,
        )
      ..addListener(() {
        _isAppBarExpanded
            ? isExpaned != false
                ? setState(
                    () {
                      isExpaned = false;
                      print('setState is called');
                    },
                  )
                : {}
            : isExpaned != true
                ? setState(() {
                    print('setState is called');
                    isExpaned = true;
                  })
                : {};
      });

    // controller.addListener();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: expandedHeight + 32,
                  // color: Colors.amber,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          height: expandedHeight,
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
                            // height: 64,
                            // width: 64,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const FlutterLogo(
                              size: 64,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        child: Align(
                          // bottom: collapsedHeight + 30,
                          // left: MediaQuery.of(context).size.width / 2 ,
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: ShapeDecoration(
                                color: Styles.mainColor,
                                shape: CircleBorder(),
                                shadows: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(0.4),
                                    blurRadius: 1,
                                    spreadRadius: 12,
                                  ),
                                  BoxShadow(
                                      color: Styles.mainColor.withOpacity(0.2),
                                      blurRadius: 1,
                                      spreadRadius: 7),
                                  BoxShadow(
                                      color: Styles.mainColor.withOpacity(0.3),
                                      blurRadius: 1,
                                      spreadRadius: 5),
                                ]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://png.pngtree.com/png-clipart/20200727/original/pngtree-restaurant-logo-design-vector-template-png-image_5441058.jpg",
                                height: 64,
                                width: 64,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    const FlutterLogo(
                                  size: 64,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Positioned(child: child)

                      Positioned(
                        top: 16,
                        right: 16,
                        child: SafeArea(
                          child: InkWell(
                            onTap: _showBottomSheet,
                            child: Container(
                              width: 40,
                              height: 40,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/calendar.svg",
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        left: 16,
                        child: SafeArea(
                          child: Container(
                              // width: 40,
                              // height: 40,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  // shape: BoxShape.circle,
                                  // color: Colors.white,
                                  ),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              )
                              //  SvgPicture.asset(
                              //   "assets/icons/calendar.svg",
                              //   width: 20,
                              //   height: 20,
                              // ),
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(
                //   height: 10,
                // ),
                Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "Coast Pizzeria",
                          style: Styles.mainTextStyle.copyWith(
                            fontSize: 24,
                            color: Styles.grayColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset("assets/icons/profile.svg"),
                                const SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  "Crowded",
                                  style: Styles.mainTextStyle.copyWith(
                                      color: Styles.midGrayColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                )
                              ],
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Flexible(
                              child: Text(
                                "Italian.",
                                style: Styles.mainTextStyle
                                    .copyWith(color: Colors.grey, fontSize: 16),
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Flexible(
                              child: Text(
                                "Open",
                                style: Styles.mainTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Styles.resturantStatusOpenColor,
                                    fontSize: 16),
                              ),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              "(55)",
                              style: Styles.mainTextStyle.copyWith(
                                color: Styles.midGrayColor,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomOutlinedButton(
                          label: "menu",
                          onPressedButton: () {},
                          icon: SvgPicture.asset("assets/icons/menu.svg"),
                          borderSide: BorderSide(color: Styles.mainColor),
                          textStyle: Styles.mainTextStyle.copyWith(
                              color: Styles.mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomOutlinedButton(
                          label: "Reserve Table",
                          onPressedButton: () {},
                          icon: SvgPicture.asset(
                            "assets/icons/profile.svg",
                            color: Colors.white,
                          ),
                          // borderSide: BorderSide(color: Styles.mainColor),
                          backGroundColor: Styles.mainColor,
                          textStyle: Styles.mainTextStyle.copyWith(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                              color: Styles.listTileBorderColr,
                            )),
                        child: ListTile(
                          title: Text(
                            "I'm Outside",
                            style: Styles.mainTextStyle.copyWith(
                                fontSize: 18, color: Styles.grayColor),
                          ),
                          subtitle: Text(
                            "Click here if you outside the resturant and needs to view our menu to order a meal",
                            style: Styles.mainTextStyle.copyWith(
                                fontSize: 14, color: Styles.midGrayColor),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios,
                              color: Styles.midGrayColor),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Photos",
                          style: Styles.mainTextStyle.copyWith(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Styles.grayColor),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                            spacing: 16,
                            crossAxisAlignment: WrapCrossAlignment.start,
                            alignment: WrapAlignment.start,
                            direction: Axis.horizontal,
                            children: [
                              ResturantImageItem(),
                              ResturantImageItem(),
                              ResturantImageItem(),
                              ResturantImageItem(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "55 ratings",
                          style: Styles.mainTextStyle
                              .copyWith(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: LinearPercentIndicator(
                          // width: double.infinity,
                          lineHeight: 10.0,
                          percent: 0.8,
                          leading: Text("5 star"),
                          trailing: Text("80%"),
                          // barRadius: Radius.circular(radius),
                          backgroundColor: Colors.grey.shade100,
                          progressColor: Styles.progressColor,
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: LinearPercentIndicator(
                          // width: double.infinity,
                          lineHeight: 10.0,
                          percent: 0.9,
                          leading: Text("4 star"),
                          trailing: Text("90%"),
                          // barRadius: Radius.circular(radius),
                          backgroundColor: Colors.grey.shade100,
                          progressColor: Styles.progressColor,
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: LinearPercentIndicator(
                          // width: double.infinity,
                          lineHeight: 10.0,
                          percent: 0.2,
                          leading: Text("3 star"),
                          trailing: Text("20%"),
                          // barRadius: Radius.circular(radius),
                          backgroundColor: Colors.grey.shade100,
                          progressColor: Styles.progressColor,
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: LinearPercentIndicator(
                          // width: double.infinity,
                          lineHeight: 10.0,
                          percent: 0.05,
                          leading: Text("2 star"),
                          trailing: Text("5%"),
                          // barRadius: Radius.circular(radius),
                          backgroundColor: Colors.grey.shade100,
                          progressColor: Styles.progressColor,
                        ),
                      ),
                      const SizedBox(
                        height: 14,
                      ),
                      Padding(
                        padding: EdgeInsets.all(0),
                        child: LinearPercentIndicator(
                          // width: double.infinity,
                          lineHeight: 10.0,
                          percent: 0.0,
                          leading: Text("1 star"),
                          trailing: Text("0%"),
                          // barRadius: Radius.circular(radius),
                          backgroundColor: Colors.grey.shade100,
                          progressColor: Styles.progressColor,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomOutlinedButton(
                          label: "View reviews",
                          icon: Container(),
                          onPressedButton: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResturantReviewsPage()),
                            );
                          },
                          borderSide: BorderSide(
                            color: Colors.black.withOpacity(0.16),
                          ),
                          // backGroundColor: Styles.mainColor,
                          textStyle: Styles.mainTextStyle.copyWith(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomOutlinedButton(
                          label: "Write a review",
                          icon: Container(),
                          onPressedButton: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddResturantReviewPage()),
                            );
                          },
                          borderSide: BorderSide(
                            color: Colors.black.withOpacity(0.16),
                          ),
                          // backGroundColor: Styles.mainColor,
                          textStyle: Styles.mainTextStyle.copyWith(
                              color: Colors.black.withOpacity(0.7),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          color: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(13.0),
                    topRight: const Radius.circular(13.0))),
            child: ListView(
              children: <Widget>[
                Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Work Hours",
                        style: Styles.mainTextStyle.copyWith(fontSize: 20),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: 30,
                        height: 30,
                        // padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Styles.closeBottomSheetBackgroundColor),
                        child: Icon(
                          Icons.close,
                          color: Styles.closeBottomIconColor.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Sunday",
                        style: Styles.mainTextStyle.copyWith(
                          fontSize: 18,
                          color: Styles.grayColor,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          "8:00 AM - 10:00 AM",
                          style: Styles.mainTextStyle.copyWith(
                            fontSize: 14,
                            color: Styles.midGrayColor,
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    )
                  ],
                ),
                Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  _buildSliverAppbar() {
    return SliverAppBar(
      backgroundColor: Colors.white,
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      centerTitle: true,
      iconTheme: IconThemeData(color: isExpaned ? Colors.white : Colors.black),
      title: !_isAppBarExpanded
          ? null
          : Text(
              "Coast Pizzeria",
              style: Styles.mainTextStyle
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18),
            ),
      actions: [
        Transform(
          transform: Matrix4.translationValues(-16, 0.0, 0.0),
          child: InkWell(
            onTap: () {
              // Share.share('check out my website https://example.com',
              //     subject: 'Look what I made!');
            },
            child: Container(
              width: 40,
              height: 40,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: SvgPicture.asset(
                "assets/icons/calendar.svg",
                width: 20,
                height: 20,
              ),
            ),
          ),
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
          collapseMode: CollapseMode.parallax,
          background: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  height: expandedHeight - 20,
                  child: CachedNetworkImage(
                    imageUrl:
                        "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cmVzdGF1cmFudHxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=500&q=60",
                    // height: 64,
                    // width: 64,
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const FlutterLogo(
                      size: 64,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              // Positioned(child: child)
              Positioned(
                bottom: 10,
                child: Align(
                  // bottom: collapsedHeight + 30,
                  // left: MediaQuery.of(context).size.width / 2 ,
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: ShapeDecoration(
                        color: Styles.mainColor,
                        shape: CircleBorder(),
                        shadows: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.4),
                            blurRadius: 1,
                            spreadRadius: 12,
                          ),
                          BoxShadow(
                              color: Styles.mainColor.withOpacity(0.2),
                              blurRadius: 1,
                              spreadRadius: 7),
                          BoxShadow(
                              color: Styles.mainColor.withOpacity(0.3),
                              blurRadius: 1,
                              spreadRadius: 5),
                        ]),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
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
                  ),
                ),
              ),
            ],
          )),
    );
  }
}

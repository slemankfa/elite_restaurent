import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/styles.dart';

class ResturentDetailPage extends StatefulWidget {
  ResturentDetailPage({Key? key}) : super(key: key);

  @override
  _ResturentDetailPageState createState() => _ResturentDetailPageState();
}

class _ResturentDetailPageState extends State<ResturentDetailPage>
    with TickerProviderStateMixin {
  final scrollDirection = Axis.vertical;
  double expandedHeight = 250;

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

  /* 
      when can anaimte a tab when it's disblay in a screen more than [_gloalPercantage] 
      to stop Visibility effect during animating tab will add  a bool [_isScrolled]   
      and it will change depends on click and scroll listiner 
   */

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                scrollDirection: Axis.vertical,
                controller: controller,
                slivers: [
                  _buildSliverAppbar(),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        const SizedBox(
                          height: 6,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Coast Pizzeria",
                                style: Styles.mainTextStyle.copyWith(
                                  fontSize: 24,
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
                                      SvgPicture.asset(
                                          "assets/icons/profile.svg"),
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
                                      style: Styles.mainTextStyle.copyWith(
                                          color: Colors.grey, fontSize: 16),
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
                                          color:
                                              Styles.resturantStatusOpenColor,
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
                          ],
                        ), 
                        Placeholder(), 
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

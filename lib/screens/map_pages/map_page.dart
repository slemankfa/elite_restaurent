import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite/core/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Stack(
        children: [
          // headers
          Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: SafeArea(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //name
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Welcome",
                                  style: Styles.mainTextStyle.copyWith(
                                    color: Colors.grey,
                                    fontSize: 18,
                                  ),
                                ),
                                Text(
                                  "Clinton Waelchi!",
                                  style: Styles.mainTextStyle.copyWith(
                                      color: Styles.userNameColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    //icons
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          // margin: ,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SvgPicture.asset(
                            "assets/icons/notifiaction.svg",
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          // margin: ,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Filters",
                                style: Styles.mainTextStyle.copyWith(
                                  color: Styles.mainColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SvgPicture.asset(
                                "assets/icons/filters.svg",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ))

          // resurants list
          ,
          Positioned(
              bottom: 16,
              left: 16,
              right: 16,
              child: Wrap(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          width: 3,
                          color: Styles.mainColor,
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl:
                                "https://png.pngtree.com/png-clipart/20200727/original/pngtree-restaurant-logo-design-vector-template-png-image_5441058.jpg",
                            height: 64,
                            width: 64,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const FlutterLogo(
                              size: 64,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Coast Pizzeria",
                          style: Styles.mainTextStyle.copyWith(
                              color: Styles.resturentNameColor,
                              fontSize: 19,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Accepting orders and booking until ',
                            style: Styles.mainTextStyle
                                .copyWith(fontSize: 16, color: Colors.grey),
                            children: <TextSpan>[
                              TextSpan(
                                text: '8:30',
                                style: Styles.mainTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Styles.timeTextColor),
                              ),
                              TextSpan(text: ' PM'),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Row(
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
                                      "(55)",
                                      style: Styles.mainTextStyle.copyWith(
                                        color: Styles.midGrayColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset("assets/icons/clock.svg"),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Flexible(
                                    child: Text(
                                      "3 min walk",
                                      style: Styles.mainTextStyle.copyWith(
                                        color: Styles.midGrayColor,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

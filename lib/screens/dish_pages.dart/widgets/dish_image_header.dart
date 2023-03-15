import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/styles.dart';

class DishImagesHeader extends StatefulWidget {
  const DishImagesHeader({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<String> images;
  @override
  State<DishImagesHeader> createState() => _DishImagesHeaderState();
}

class _DishImagesHeaderState extends State<DishImagesHeader> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //  MediaQueryData mediaQuery = MediaQueryData.
    final mediaQuery = MediaQuery.of(context);
    return Column(
      children: [
        Container(
          height: 245,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: CarouselSlider(
                  items: widget.images.map((item) {
                    return CachedNetworkImage(
                      imageUrl: item.toString(),
                      fit: BoxFit.fill,
                      width: double.infinity,
                      placeholder: (context, url) => FlutterLogo(
                        size: 40,
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    );
                  }).toList(),
                  carouselController: _controller,
                  options: CarouselOptions(
                      autoPlay: true,
                      // autoPlayAnimationDuration: D,
                      enlargeCenterPage: false,
                      viewportFraction: 1.0,
                      aspectRatio: 1.0,
                      // enlargeCenterPage: true,
                      // aspectRatio: 2.0,
                      // pageSnapping: false,
                      padEnds: true,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                        });
                      }),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: widget.images.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 10.0,
                        height: 10.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(50),
                            color: entry.key == _current ? Colors.white : null),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(
          "Creamy Shrimp Pasta",
          style: Styles.mainTextStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Styles.grayColor),
        ),
        const SizedBox(
          height: 12,
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
    );
  }
}

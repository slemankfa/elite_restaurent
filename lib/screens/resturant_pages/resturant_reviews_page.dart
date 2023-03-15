import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../core/styles.dart';

class ResturantReviewsPage extends StatefulWidget {
  const ResturantReviewsPage({super.key});

  @override
  State<ResturantReviewsPage> createState() => _ResturantReviewsPageState();
}

class _ResturantReviewsPageState extends State<ResturantReviewsPage> {
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
        child: ListView(
          children: [
            Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: ClipRRect(
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
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

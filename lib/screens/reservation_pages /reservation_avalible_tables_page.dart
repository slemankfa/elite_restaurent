import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite/screens/reservation_pages%20/reservation_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../core/styles.dart';

class ReservationAvalibleTabelsPage extends StatefulWidget {
  const ReservationAvalibleTabelsPage({super.key});

  @override
  State<ReservationAvalibleTabelsPage> createState() =>
      _ReservationAvalibleTabelsPageState();
}

class _ReservationAvalibleTabelsPageState
    extends State<ReservationAvalibleTabelsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Styles.grayColor),
        title: Text(
          "Select Table",
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ReservationDetailsPage()),
                );
              },
              child: Container(
                // margin: EdgeInsets.all(3),
                // width: 156,
                // padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      16,
                    ),
                    border:
                        Border.all(color: Styles.RatingRivewBoxBorderColor)),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "https://thumbs.dreamstime.com/b/restaurant-tables-18344514.jpg",
                        height: 235,
                        width: double.infinity,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => const FlutterLogo(
                          size: 40,
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                    ),
                    // const SizedBox(
                    //   height: 16,
                    // ),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Table 2",
                              style: Styles.mainTextStyle.copyWith(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.resturentNameColor),
                            ),
                          ),
                          Chip(
                              backgroundColor: Styles.listTileBorderColr,
                              label: Text(
                                "Corner Table",
                                style: Styles.mainTextStyle.copyWith(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Styles.mainColor),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

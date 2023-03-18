import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';

class MyReservationListPage extends StatefulWidget {
  const MyReservationListPage({super.key});

  @override
  State<MyReservationListPage> createState() => _MyReservationListPageState();
  static const routeName = "/my-reservation-page";
}

class _MyReservationListPageState extends State<MyReservationListPage> {
  int? _selectedOrderType = 0;
  List<String> ordersType = ["All", "Past", "Upcoming", "Canceled"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Styles.grayColor),
        title: Text(
          "My orders",
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 5.0,
              children: List<Widget>.generate(
                4,
                (int index) {
                  return Container(
                    // width: 81,
                    child: ChoiceChip(
                      backgroundColor: Colors.white,
                      selectedColor: Styles.listTileBorderColr,
                      // selectedColor: ,
                      side: _selectedOrderType == index
                          ? null
                          : BorderSide(width: 1, color: Styles.midGrayColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      // padding: EdgeInsets.all(8),
                      label: Container(
                        // width: 50,
                        child: Text(
                          '${ordersType[index]}',
                          style: Styles.mainTextStyle.copyWith(
                              color: _selectedOrderType == index
                                  ? Styles.mainColor
                                  : Styles.grayColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      selected: _selectedOrderType == index,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedOrderType = selected ? index : null;
                        });
                      },
                    ),
                  );
                },
              ).toList(),
            ),
            Divider(),
            const SizedBox(
              height: 15,
            ),
            Expanded(
                child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  // decoration: BoxDecoration(
                  //   borderRadius: BorderRadius.circular(16),
                  //   border: Border.all(
                  //     color: Styles.RatingRivewBoxBorderColor,
                  //   ),
                  // ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // margin: EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Past",
                                style: Styles.mainTextStyle.copyWith(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Styles.resturentNameColor),
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Container(
                                width: 40,
                                height: 40,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Styles.deleteBackGroundColor,
                                ),
                                child: Icon(
                                  Icons.delete,
                                  color: Styles.cancelREdColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Table 4",
                        style: Styles.mainTextStyle.copyWith(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Styles.userNameColor),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          SvgPicture.asset("assets/icons/clock.svg"),
                          const SizedBox(
                            width: 6,
                          ),
                          Expanded(
                              child: Text(
                            "Mon Apr 16 2074 07:06:08",
                            style: Styles.mainTextStyle.copyWith(
                              color: Styles.midGrayColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ))
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Divider(),
                    ],
                  ),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}

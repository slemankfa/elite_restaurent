import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
  static const routeName = "/my-orders-page";
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  int? _selectedOrderType = 0;
  List<String> ordersType = ["All", "Indoor", "Outdoor"];
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
                3,
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
            const SizedBox(
              height: 15,
            ),
            Expanded(
                child: ListView(
              children: [
                Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Styles.RatingRivewBoxBorderColor,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // margin: EdgeInsets.all(16),
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
                            Text(
                              "#41619997",
                              style: Styles.mainTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.resturentNameColor),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
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
                        height: 15,
                      ),
                      Text(
                        "Cancel Order",
                        style: Styles.mainTextStyle.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Styles.grayColor),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                                text: 'You have ',
                                style: Styles.mainTextStyle.copyWith(
                                  fontSize: 16,
                                  color: Styles.userNameColor,
                                )),
                            TextSpan(
                              text: '00:14:59 minutes',
                              style: Styles.mainTextStyle.copyWith(
                                  fontSize: 16,
                                  color: Styles.mainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  ' to cancel your order, otherwise, your order will be confirmed by the restaurant automatically.',
                              style: Styles.mainTextStyle.copyWith(
                                fontSize: 16,
                                color: Styles.userNameColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CustomOutlinedButton(
                          label: "View Details",
                          isIconVisible: true,
                          onPressedButton: () {},
                          icon: Container(),
                          rectangleBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          borderSide: BorderSide(color: Styles.mainColor),
                          textStyle: Styles.mainTextStyle.copyWith(
                              color: Styles.mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 24,
                      ),
                      CustomOutlinedButton(
                          label: "Cancel Order",
                          isIconVisible: true,
                          onPressedButton: () {},
                          icon: Container(),
                          backGroundColor: Styles.listTileBorderColr,
                          rectangleBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          borderSide:
                              BorderSide(color: Styles.listTileBorderColr),
                          textStyle: Styles.mainTextStyle.copyWith(
                              color: Styles.cancelREdColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(
                        height: 16,
                      ),
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

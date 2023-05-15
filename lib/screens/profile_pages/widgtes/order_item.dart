import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/styles.dart';
import '../../../core/widgets/custom_outline_button.dart';
import '../../../models/order_model.dart';

class OrderItem extends StatelessWidget {
  const OrderItem({
    super.key,
    required this.orderModel,
  });

  final OrderModel orderModel;

  convertDate(String? date) {
    if (date == null) return "";
    // "2023-03-18T07:19:23.64"
    DateTime tempDate = DateFormat("yyyy-MM-ddThh:mm:ss", 'en_US').parse(date);
    return DateFormat("dd MMM yyyy hh:mm:ss").format(tempDate);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
                  "#${orderModel.orderId}",
                  style: Styles.mainTextStyle.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Styles.resturentNameColor),
                )
              ],
            ),
          ),
          const SizedBox(
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
                convertDate(orderModel.requestDare),
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
              borderSide: const BorderSide(color: Styles.mainColor),
              textStyle: Styles.mainTextStyle.copyWith(
                  color: Styles.mainColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 24,
          ),
          orderModel.isCnacel!
              ? Container()
              : CustomOutlinedButton(
                  label: "Cancel Order",
                  isIconVisible: true,
                  onPressedButton: () {},
                  icon: Container(),
                  backGroundColor: Styles.listTileBorderColr,
                  rectangleBorder: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  borderSide:
                      const BorderSide(color: Styles.listTileBorderColr),
                  textStyle: Styles.mainTextStyle.copyWith(
                      color: Styles.cancelREdColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 16,
          ),
        ],
      ),
    );
  }
}

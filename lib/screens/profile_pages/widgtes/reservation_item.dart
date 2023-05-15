import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elite/core/helper_methods.dart';
import 'package:elite/core/styles.dart';
import 'package:elite/models/reservation_model.dart';
import 'package:elite/providers/reservation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class ReservationItem extends StatelessWidget {
  ReservationItem({
    super.key,
    required this.reservationModel,
    required this.updateUI,
  });

  final ReservationModel reservationModel;
  final Function updateUI;

  final HelperMethods _helperMethods = HelperMethods();
  convertDate(String? date) {
    if (date == null) return "";
    // "2023-03-18T07:19:23.64"
    DateTime tempDate = DateFormat("yyyy-MM-ddThh:mm:ss", 'en_US').parse(date);
    return DateFormat("dd MMM yyyy hh:mm:ss").format(tempDate);
  }

  //  All = 0 ,Cancel = 1, Past = 2, Upcoming = 3

  String getResevationType() {
    switch (reservationModel.status) {
      case 0:
        return "All";
      case 1:
        return "Canceled";
      case 2:
        return "Past";
      case 3:
        return "Upcoming";
      default:
        return "";
    }
  }

  cancelReservation(BuildContext context) async {
    try {
      Provider.of<ReservationProvider>(context, listen: false)
          .cancelResrvation(
              context: context, resvId: reservationModel.reservationId)
          .then((status) {
        // Navigator.of(context).pop();
        updateUI();
        if (status) {
        } else {
          BotToast.showText(text: "Something went wrong!");
        }
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
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
                    getResevationType(),
                    style: Styles.mainTextStyle.copyWith(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                        color: Styles.resturentNameColor),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _helperMethods.showAlertDilog(
                        message:
                            "Are you sure to cancel the reservation table ${reservationModel.status}?",
                        context: context,
                        function: () {
                          cancelReservation(context);
                        });
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Styles.deleteBackGroundColor,
                    ),
                    child: const Icon(
                      Icons.delete,
                      color: Styles.cancelREdColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
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
                convertDate(reservationModel.reservationDate),
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
          const Divider(),
        ],
      ),
    );
  }
}

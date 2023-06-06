import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:elite/core/helper_methods.dart';
import 'package:elite/models/resturant_model.dart';
import 'package:elite/providers/cart_provider.dart';
import 'package:elite/providers/resturant_provider.dart';
import 'package:elite/screens/reservation_pages%20/reservation_avalible_tables_page.dart';
import 'package:elite/screens/reservation_pages%20/reservation_policy_page.dart';
import 'package:elite/screens/resturant_pages/add_resturant_review_page.dart';
import 'package:elite/screens/resturant_pages/resturant_menu_page.dart';
import 'package:elite/screens/resturant_pages/resturant_reviews_page.dart';
import 'package:elite/screens/resturant_pages/widgets/resturant_image_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:time_picker_spinner_pop_up/time_picker_spinner_pop_up.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';
import '../../core/widgets/star_rating_parecntage_item.dart';

class ResturentDetailPage extends StatefulWidget {
  const ResturentDetailPage({Key? key, required this.resturantId})
      : super(key: key);

  @override
  _ResturentDetailPageState createState() => _ResturentDetailPageState();
  final String resturantId;
}

class _ResturentDetailPageState extends State<ResturentDetailPage>
    with TickerProviderStateMixin {
  final scrollDirection = Axis.vertical;
  double expandedHeight = 210;
  bool isIndoor = false;

  final HelperMethods _helperMethods = HelperMethods();

  ResturantModel? _resturantDetails;
  bool _isLoading = false;
  final TextEditingController _peopleCountController = TextEditingController();

  @override
  void initState() {
    // controller = ScrollController();
    getResturantDetails();
    super.initState();

    // controller.addListener();
  }

  _reserveTable() async {
    final bool status = await _helperMethods.checkIsAcceptReservationPolicy();
    if (!status) {
      final selectedCity = await Navigator.of(context).push<bool>(
        MaterialPageRoute(
          // fullscreenDialog: true,
          builder: (BuildContext context) => const ReservationPolicyPage(),
        ),
      );
      if (selectedCity == null) {
        return;
      }
      // BotToast.showText(text: "accepted");
      _showResvationOptionBottomSheet();
      return;
    }
    // BotToast.showText(text: "accepted");
    _showResvationOptionBottomSheet();
  }

  findTabels() async {
    try {
      if (pickedDate.isEmpty) {
        BotToast.showText(text: "You must select a date");
        return;
      }
      //  Navigator.of(context).pop();
      await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReservationAvalibleTabelsPage(
                  date: pickedDate,
                  resturantDetails: _resturantDetails!,
                  isIndoor: isIndoor,
                  time: pickedTime,
                  numberOfSeats: _peopleCountController.text.trim().isNotEmpty
                      ? _peopleCountController.text
                      : resevedPeopleCountList[_selectedPeopleCountIndex!]
                          .toString(),
                )),
      ).then((value) {
        Navigator.of(context).pop();
        print("removedate");
        pickedDate = "";
        _peopleCountController.clear();
        isIndoor = false;
        // pickedTime = "";
        _selectedPeopleCountIndex = 0;
      });
    } catch (e) {
      // print(e.toString());
    }
  }

  int? _selectedPeopleCountIndex = 0;
  List<int> resevedPeopleCountList = [2, 4, 6, 8];
  String pickedDate = "";
  String pickedTime = "";
  int _sliding = 0;
  final TimePickerSpinnerController _timePickerSpinnerController =
      TimePickerSpinnerController();

  getResturantDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<ResturantProvider>(context, listen: false)
          .getResturantDetails(
              context: context, ResturantId: widget.resturantId)
          .then((loadedResturant) {
        if (loadedResturant == null) {
          return;
        } else {
          _resturantDetails = loadedResturant;
        }
        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print(_resturantDetails!.logo);
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          backgroundColor: Colors.white,
          body: _isLoading
              ? _helperMethods.progressIndcator()
              : _resturantDetails == null
                  ? Center(
                      child: Text(
                        "something_went_wrong".tr(),
                        style: Styles.mainTextStyle,
                      ),
                    )
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: expandedHeight + 32,
                            // color: Colors.amber,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: SizedBox(
                                    height: expandedHeight,
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          _resturantDetails!.backGroundImage,
                                      // height: 64,
                                      // width: 64,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          const FlutterLogo(
                                        size: 64,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      decoration: ShapeDecoration(
                                          color: Styles.mainColor,
                                          shape: const CircleBorder(),
                                          shadows: [
                                            BoxShadow(
                                              color:
                                                  Colors.white.withOpacity(0.4),
                                              blurRadius: 1,
                                              spreadRadius: 12,
                                            ),
                                            BoxShadow(
                                                color: Styles.mainColor
                                                    .withOpacity(0.2),
                                                blurRadius: 1,
                                                spreadRadius: 7),
                                            BoxShadow(
                                                color: Styles.mainColor
                                                    .withOpacity(0.3),
                                                blurRadius: 1,
                                                spreadRadius: 5),
                                          ]),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50),
                                        child: CachedNetworkImage(
                                          imageUrl: _resturantDetails!.logo,
                                          height: 64,
                                          width: 64,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const FlutterLogo(
                                            size: 64,
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
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
                                      onTap: _showWorksHourBottomSheet,
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        padding: const EdgeInsets.all(8),
                                        decoration: const BoxDecoration(
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
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                          // width: 40,
                                          // height: 40,
                                          padding: const EdgeInsets.all(8),
                                          decoration: const BoxDecoration(
                                              // shape: BoxShape.circle,
                                              // color: Colors.white,
                                              ),
                                          child: const Icon(
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
                                ),
                              ],
                            ),
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          Container(
                            margin: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    _resturantDetails!.name,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            _resturantDetails!.traficStatus,
                                            style: Styles.mainTextStyle
                                                .copyWith(
                                                    color: Styles.midGrayColor,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.bold),
                                            overflow: TextOverflow.ellipsis,
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Flexible(
                                        child: Text(
                                          _resturantDetails!.cousineType,
                                          style: Styles.mainTextStyle.copyWith(
                                              color: Colors.grey, fontSize: 16),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Flexible(
                                        child: Text(
                                          _resturantDetails!.openStatus,
                                          style: Styles.mainTextStyle.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Styles
                                                  .resturantStatusOpenColor,
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
                                      "${(double.parse(_resturantDetails!.averageRating.toString()) * 100).round() / 100.0}",
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
                                        "(${_resturantDetails!.totalRating.toString()})",
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
                                //////////////////

                                //////////////////
                                CustomOutlinedButton(
                                    label: "menu",
                                    isIconVisible: true,
                                    onPressedButton: () {
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .updateIsIndoorStatus("1");
                                      Provider.of<CartProvider>(context,
                                              listen: false)
                                          .isInsideResturant = true;
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResturanMenuPage(
                                                  resturantDetails:
                                                      _resturantDetails!,
                                                  isFormAddOrderPage: false,
                                                )),
                                      );
                                    },
                                    icon: SvgPicture.asset(
                                        "assets/icons/menu.svg"),
                                    borderSide: const BorderSide(
                                        color: Styles.mainColor),
                                    textStyle: Styles.mainTextStyle.copyWith(
                                        color: Styles.mainColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  height: 20,
                                ),
                                CustomOutlinedButton(
                                    label: "Reserve Table",
                                    onPressedButton: _reserveTable,
                                    isIconVisible: true,
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
                                InkWell(
                                  onTap: () {
                                    // Provider.of<CartProvider>(context,
                                    //         listen: false)
                                    //     .updateIsIndoorStatus("2");
                                    //  Provider.of<CartProvider>(context,
                                    //           listen: false)
                                    //       .isInsideResturant = false;
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(13),
                                        border: Border.all(
                                          color: Styles.listTileBorderColr,
                                        )),
                                    child: ListTile(
                                      title: Text(
                                        "I'm Outside",
                                        style: Styles.mainTextStyle.copyWith(
                                            fontSize: 18,
                                            color: Styles.grayColor),
                                      ),
                                      subtitle: Text(
                                        "Click here if you outside the resturant and needs to view our menu to order a meal",
                                        style: Styles.mainTextStyle.copyWith(
                                            fontSize: 14,
                                            color: Styles.midGrayColor),
                                      ),
                                      trailing: const Icon(
                                          Icons.arrow_forward_ios,
                                          color: Styles.midGrayColor),
                                    ),
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
                                      crossAxisAlignment:
                                          WrapCrossAlignment.start,
                                      alignment: WrapAlignment.start,
                                      direction: Axis.horizontal,
                                      children: _resturantDetails!
                                          .resturantsImages
                                          .map((image) => ResturantImageItem(
                                                imageUrl: image,
                                              ))
                                          .toList(),
                                      // children: const [
                                      //   ResturantImageItem(),
                                      //   ResturantImageItem(),
                                      //   ResturantImageItem(),
                                      //   ResturantImageItem(),
                                      // ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "${_resturantDetails!.totalRating} ratings",
                                    style: Styles.mainTextStyle.copyWith(
                                        fontSize: 14, color: Colors.grey),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),

                                Column(
                                    children: _resturantDetails!
                                        .starRatingParcentageList
                                        .map((ratingItem) =>
                                            StarRatingParecntageItem(
                                              ratingItem: ratingItem,
                                            ))
                                        .toList()),

                                // Padding(
                                //   padding: const EdgeInsets.all(0),
                                //   child: LinearPercentIndicator(
                                //     // width: double.infinity,
                                //     lineHeight: 10.0,
                                //     percent: 0.8,
                                //     leading: const Text("5 star"),
                                //     trailing: const Text("80%"),
                                //     // barRadius: Radius.circular(radius),
                                //     backgroundColor: Colors.grey.shade100,
                                //     progressColor: Styles.progressColor,
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 14,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(0),
                                //   child: LinearPercentIndicator(
                                //     // width: double.infinity,
                                //     lineHeight: 10.0,
                                //     percent: 0.9,
                                //     leading: const Text("4 star"),
                                //     trailing: const Text("90%"),
                                //     // barRadius: Radius.circular(radius),
                                //     backgroundColor: Colors.grey.shade100,
                                //     progressColor: Styles.progressColor,
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 14,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(0),
                                //   child: LinearPercentIndicator(
                                //     // width: double.infinity,
                                //     lineHeight: 10.0,
                                //     percent: 0.2,
                                //     leading: const Text("3 star"),
                                //     trailing: const Text("20%"),
                                //     // barRadius: Radius.circular(radius),
                                //     backgroundColor: Colors.grey.shade100,
                                //     progressColor: Styles.progressColor,
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 14,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(0),
                                //   child: LinearPercentIndicator(
                                //     // width: double.infinity,
                                //     lineHeight: 10.0,
                                //     percent: 0.05,
                                //     leading: const Text("2 star"),
                                //     trailing: const Text("5%"),
                                //     // barRadius: Radius.circular(radius),
                                //     backgroundColor: Colors.grey.shade100,
                                //     progressColor: Styles.progressColor,
                                //   ),
                                // ),
                                // const SizedBox(
                                //   height: 14,
                                // ),
                                // Padding(
                                //   padding: const EdgeInsets.all(0),
                                //   child: LinearPercentIndicator(
                                //     // width: double.infinity,
                                //     lineHeight: 10.0,
                                //     percent: 0.0,
                                //     leading: const Text("1 star"),
                                //     trailing: const Text("0%"),
                                //     // barRadius: Radius.circular(radius),
                                //     backgroundColor: Colors.grey.shade100,
                                //     progressColor: Styles.progressColor,
                                //   ),
                                // ),
                                const SizedBox(
                                  height: 20,
                                ),

                                CustomOutlinedButton(
                                    label: "View reviews",
                                    icon: Container(),
                                    isIconVisible: false,
                                    onPressedButton: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ResturantReviewsPage(
                                                  resturantDetails:
                                                      _resturantDetails!,
                                                )),
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
                                    isIconVisible: false,
                                    icon: Container(),
                                    onPressedButton: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AddResturantReviewPage(
                                                  resturantDetails:
                                                      _resturantDetails!,
                                                )),
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

  void _showResvationOptionBottomSheet() {
    // int resevedPeopleCount = 2;

    if (DateTime.now().hour >= 12) {
      _sliding = 1;
    } else {
      _sliding = 0;
    }
    pickedTime = "${DateTime.now().hour}:${DateTime.now().minute}";
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.8,
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(13.0),
                      topRight: Radius.circular(13.0))),
              child: ListView(
                children: <Widget>[
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Find Table",
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
                          decoration: const BoxDecoration(
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
                  const Divider(),
                  const SizedBox(
                    height: 17,
                  ),
                  Text(
                    "Party Size",
                    style: Styles.mainTextStyle.copyWith(
                        color: Styles.grayColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Wrap(
                    spacing: 5.0,
                    children: List<Widget>.generate(
                      4,
                      (int index) {
                        return Container(
                          // width: 81,
                          child: ChoiceChip(
                            backgroundColor: Colors.white,
                            selectedColor: Colors.white,
                            // selectedColor: ,
                            side: BorderSide(
                                width:
                                    _selectedPeopleCountIndex == index ? 2 : 1,
                                color: _selectedPeopleCountIndex == index
                                    ? Styles.mainColor
                                    : Styles.midGrayColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            // padding: EdgeInsets.all(8),
                            label: SizedBox(
                              width: 50,
                              child: Text(
                                '${resevedPeopleCountList[index]}',
                                style: Styles.mainTextStyle.copyWith(
                                    color: Styles.grayColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            selected: _selectedPeopleCountIndex == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedPeopleCountIndex =
                                    selected ? index : null;
                              });
                            },
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  Row(
                    children: [
                      const Expanded(
                          child: Divider(
                        color: Colors.black,
                      )),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Or",
                        style: Styles.mainTextStyle.copyWith(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Expanded(
                          child: Divider(
                        color: Colors.black,
                      )),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _peopleCountController,
                    // validator:(value)=> _validationHelper.validatePhone(value!) ,
                    keyboardType: TextInputType.phone,
                    style: Styles.mainTextStyle
                        .copyWith(fontSize: 16, color: Styles.mainColor),
                    onChanged: (text) {},
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp("(\\d+[]?[\\d]*)")),
                    ],
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Styles.formFieldBorderColor,
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(
                          color: Styles.formFieldBorderColor,
                          width: 1.0,
                        ),
                      ),
                      focusColor: Colors.black,
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                        ),
                      ),
                      border: const OutlineInputBorder(),
                      isDense: true,
                      hintText: "Enter people number 10",
                      hintStyle: Styles.mainTextStyle
                          .copyWith(fontSize: 16, color: Styles.midGrayColor),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        // flex: 10,
                        child: Text(
                          "Indoor Table",
                          style: Styles.mainTextStyle
                              .copyWith(fontSize: 16, color: Styles.grayColor),
                        ),
                      ),
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Styles.mainColor, width: 1),
                        ),
                        child: Theme(
                          // color: Colors.white,
                          data: ThemeData(unselectedWidgetColor: Colors.white),
                          child: Checkbox(
                            // shape:  CircleBorder(),
                            value: isIndoor,

                            checkColor: Styles.mainColor,
                            // side: BorderSide(
                            //   color: Styles.mainColor,
                            // ),
                            overlayColor:
                                MaterialStateProperty.all(Colors.white),
                            focusColor: Colors.white,
                            tristate: false,
                            // activeColor:Colors.white ,
                            fillColor: MaterialStateProperty.all(Colors.white),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            onChanged: (value) {
                              setState(() {
                                isIndoor = value ?? false;
                              });

                              // searchingResturants(provider);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 17,
                  ),
                  Container(
                    // height: 200,
                    child: SfDateRangePicker(
                      showNavigationArrow: true,
                      // backgroundColor: Styles.mainColor,
                      selectionColor: Styles.mainColor,
                      view: DateRangePickerView.month,
                      headerStyle: DateRangePickerHeaderStyle(
                        textStyle: Styles.mainTextStyle.copyWith(
                            color: Styles.mainColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      monthViewSettings: const DateRangePickerMonthViewSettings(
                          dayFormat: "E", showTrailingAndLeadingDates: false),
                      monthCellStyle: DateRangePickerMonthCellStyle(
                          textStyle: Styles.mainTextStyle
                              .copyWith(color: Styles.mainColor),
                          todayCellDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Styles.mainColor)),
                          todayTextStyle: Styles.mainTextStyle
                              .copyWith(color: Styles.mainColor)),
                      onSelectionChanged: (selectedDate) {
                        // DateTime tempDate =
                        //     new DateFormat("yyyy-MM-dd hh:mm:ss", 'en_US')
                        //         .parse(selectedDate.value.toString());
                        pickedDate =
                            DateFormat("yyyy-MM-d").format(selectedDate.value);
                        print(pickedDate.toString());
                      },
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 17,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Time",
                          style: Styles.mainTextStyle.copyWith(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      TimePickerSpinnerPopUp(
                        mode: CupertinoDatePickerMode.time,
                        controller: _timePickerSpinnerController,
                        initTime: DateTime.now(),
                        minTime:
                            DateTime.now().subtract(const Duration(days: 10)),
                        maxTime: DateTime.now().add(const Duration(days: 10)),
                        barrierColor:
                            Colors.black12, //Barrier Color when pop up show
                        onChange: (dateTime) {
                          // print(dateTime.hour);
                          // print(dateTime.minute);

                          if (dateTime.hour >= 12) {
                            _sliding = 1;
                          } else {
                            _sliding = 0;
                          }
                          setState(() {
                            pickedTime = "${dateTime.hour}:${dateTime.minute}";
                          });
                          print(pickedTime);
                          // Implement your logic with select dateTime
                        },
                        // Customize your time widget
                        timeWidgetBuilder: (dateTime) {
                          return InkWell(
                            onTap: () {
                              _timePickerSpinnerController.showMenu();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  color: Styles.timeBackGroundColor
                                      .withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(6)),
                              child: Text(
                                "${dateTime.hour} : ${dateTime.minute} ",
                                style:
                                    Styles.mainTextStyle.copyWith(fontSize: 20),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            color: Styles.timeBackGroundColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(9)),
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    color: _sliding == 0 ? Colors.white : null),
                                child: Text('AM',
                                    style: Styles.mainTextStyle
                                        .copyWith(fontSize: 13))),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    color: _sliding == 1 ? Colors.white : null),
                                child: Text('PM',
                                    style: Styles.mainTextStyle
                                        .copyWith(fontSize: 13)))
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 17,
                  ),
                  Container(
                    color: Colors.white,
                    margin: const EdgeInsets.all(8),
                    child: CustomOutlinedButton(
                        label: "Find Table",
                        // borderSide: BorderSide(),
                        rectangleBorder: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        icon: Container(),
                        isIconVisible: false,
                        onPressedButton: findTabels,
                        backGroundColor: Styles.mainColor,
                        // backGroundColor: Styles.mainColor,
                        textStyle: Styles.mainTextStyle.copyWith(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  convertWorkingDayDateDate(String? date) {
    if (date == null) return "";
    // "2023-03-18T07:19:23.64"
    // DateTime tempDate =
    //     DateFormat("yyyy-MM-ddThh:mm:ss", 'en_US').parse(date);
    DateTime tempDate = DateFormat("hh:mm:ss", 'en_US').parse(date);
    return DateFormat("hh:mm a").format(tempDate);
  }

  void _showWorksHourBottomSheet() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0),
      ),
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0))),
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
                        decoration: const BoxDecoration(
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
                const Divider(),
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
                        child: _resturantDetails!
                                    .resurantWorkingDaysModel!.sundayFrom ==
                                null
                            ? Text(
                                "Closed".tr(),
                                style: Styles.mainTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.cancelREdColor,
                                ),
                                textAlign: TextAlign.end,
                              )
                            : Text(
                                "${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.sundayFrom)} - ${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.sundayTo)}",
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
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Monday",
                        style: Styles.mainTextStyle.copyWith(
                          fontSize: 18,
                          color: Styles.grayColor,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: _resturantDetails!
                                    .resurantWorkingDaysModel!.monFrmTime ==
                                null
                            ? Text(
                                "Closed".tr(),
                                style: Styles.mainTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.cancelREdColor,
                                ),
                                textAlign: TextAlign.end,
                              )
                            : Text(
                                "${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.monFrmTime)} - ${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.monToTime)}",
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
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Tuesday",
                        style: Styles.mainTextStyle.copyWith(
                          fontSize: 18,
                          color: Styles.grayColor,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: _resturantDetails!
                                    .resurantWorkingDaysModel!.tuesdayFrmTime ==
                                null
                            ? Text(
                                "Closed".tr(),
                                style: Styles.mainTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.cancelREdColor,
                                ),
                                textAlign: TextAlign.end,
                              )
                            : Text(
                                "${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.tuesdayFrmTime)} - ${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.tuesdayToTime)}",
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
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Wednesday",
                        style: Styles.mainTextStyle.copyWith(
                          fontSize: 18,
                          color: Styles.grayColor,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: _resturantDetails!.resurantWorkingDaysModel!
                                    .wednesdayFrmTime ==
                                null
                            ? Text(
                                "Closed".tr(),
                                style: Styles.mainTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.cancelREdColor,
                                ),
                                textAlign: TextAlign.end,
                              )
                            : Text(
                                "${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.wednesdayFrmTime)} - ${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.wednesdayToTime)}",
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
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Thursday",
                        style: Styles.mainTextStyle.copyWith(
                          fontSize: 18,
                          color: Styles.grayColor,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: _resturantDetails!.resurantWorkingDaysModel!
                                    .thursdayFrmTime ==
                                null
                            ? Text(
                                "Closed".tr(),
                                style: Styles.mainTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.cancelREdColor,
                                ),
                                textAlign: TextAlign.end,
                              )
                            : Text(
                                "${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.thursdayFrmTime)} - ${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.thursdayToTime)}",
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
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Friday",
                        style: Styles.mainTextStyle.copyWith(
                          fontSize: 18,
                          color: Styles.grayColor,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: _resturantDetails!
                                    .resurantWorkingDaysModel!.fridayFrmTime ==
                                null
                            ? Text(
                                "Closed".tr(),
                                style: Styles.mainTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.cancelREdColor,
                                ),
                                textAlign: TextAlign.end,
                              )
                            : Text(
                                "${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.fridayFrmTime)} - ${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.fridayToTime)}",
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
                const Divider(),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Saturday",
                        style: Styles.mainTextStyle.copyWith(
                          fontSize: 18,
                          color: Styles.grayColor,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: _resturantDetails!.resurantWorkingDaysModel!
                                    .saturdayFrmTime ==
                                null
                            ? Text(
                                "Closed".tr(),
                                style: Styles.mainTextStyle.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Styles.cancelREdColor,
                                ),
                                textAlign: TextAlign.end,
                              )
                            : Text(
                                "${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.saturdayFrmTime)} - ${convertWorkingDayDateDate(_resturantDetails!.resurantWorkingDaysModel!.saturdayToTime)}",
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
                const Divider(),
              ],
            ),
          ),
        );
      },
    );
  }
}

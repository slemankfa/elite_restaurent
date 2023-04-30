import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite/core/helper_methods.dart';
import 'package:elite/core/styles.dart';
import 'package:elite/models/resturant_model.dart';
import 'package:elite/screens/map_pages/filter_page.dart';
import 'package:elite/screens/map_pages/notifcation_page.dart';
import 'package:elite/screens/map_pages/widgets/multi_select_chip.dart';
import 'package:elite/screens/resturant_pages/resturant_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../core/widgets/custom_outline_button.dart';
import '../../models/filter_item_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resturant_provider.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final HelperMethods _helperMethods = HelperMethods();

  int _pageNumber = 1;
  final ScrollController _resturantsListController = ScrollController();
  late Function popUpProgressIndcator;
  bool _isThereNextPage = false;
  List<ResturantModel> _resturantsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    _resturantsListController.addListener(() {
      if (_resturantsListController.position.pixels ==
          _resturantsListController.position.maxScrollExtent) {
        print("from inist satate");

        if (!_isThereNextPage) return;
        fetchRestursantsList();
      }
    });

    fetchRestursantsList();

    super.initState();
  }

  Future refreshList() async {
    _pageNumber = 1;
    fetchRestursantsList();
  }

  Future fetchRestursantsList() async {
    // popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ResturantProvider>(context, listen: false)
          .getResturantsList(
              context: context, pageNumber: _pageNumber, map: {}) //3
          .then((informationMap) {
        if (_pageNumber == 1) {
          _resturantsList = informationMap["list"];
        } else {
          _resturantsList.addAll(informationMap["list"]);
        }
        setState(() {
          _isThereNextPage = informationMap["isThereNextPage"] ?? false;
          _pageNumber++;
          popUpProgressIndcator.call();
        });

        setState(() {
          _isLoading = false;
        });
      });
    } catch (e) {
      // popUpProgressIndcator.call();
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = Provider.of<AuthProvider>(
      context,
    ).userInformation;
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
                                  userModel == null
                                      ? ""
                                      : "${userModel.userName.toString()}!",
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
                        InkWell(
                          onTap: () => Navigator.of(context)
                              .pushNamed(NotificationPage.routeName),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            // margin: ,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: SvgPicture.asset(
                              "assets/icons/notifiaction.svg",
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        InkWell(
                          onTap: _showFilterBottomSheet,
                          //  () {
                          //   Navigator.push(
                          //       context,
                          //       MaterialPageRoute(
                          //         builder: (context) => const FilterPge(),
                          //       ));
                          //   // _helperMethods.showAlertDilog(message: "asdsd", context: context, function: (){});
                          // },
                          child: Container(
                            padding: const EdgeInsets.all(8),
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
            height: MediaQuery.of(context).size.height * 0.25,
            child: ListView.separated(
              separatorBuilder: (context,index)=>const SizedBox(width: 12,),
                scrollDirection: Axis.horizontal,
                itemCount: _resturantsList.length,
                // physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ResturentDetailPage(
                                  resturantId: _resturantsList[index].id,
                                )),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      // height: 200,
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
                              imageUrl: _resturantsList[index].logo,
                              // "https://png.pngtree.com/png-clipart/20200727/original/pngtree-restaurant-logo-design-vector-template-png-image_5441058.jpg",
                              height: 64,
                              width: 64,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const FlutterLogo(
                                size: 64,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            _resturantsList[index].name,
                            style: Styles.mainTextStyle.copyWith(
                                color: Styles.resturentNameColor,
                                fontSize: 19,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Flexible(
                            child: RichText(
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
                                  const TextSpan(text: ' PM'),
                                ],
                              ),
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
                                      _resturantsList[index]
                                          .averageRating
                                          .toString(),
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
                                        "(${_resturantsList[index].totalRating})",
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
                  );
                }),
          ),
          // Wrap(
          //   direction: Axis.horizontal,
          //   children: _resturantsList
          //       .map((restruant) => InkWell(
          //             onTap: () {
          //               Navigator.push(
          //                 context,
          //                 MaterialPageRoute(
          //                     builder: (context) => ResturentDetailPage(
          //                           resturantId: restruant.id,
          //                         )),
          //               );
          //             },
          //             child: Container(
          //               padding: const EdgeInsets.all(10),
          //               width: MediaQuery.of(context).size.width * 0.8,
          //               decoration: BoxDecoration(
          //                   color: Colors.white,
          //                   borderRadius: BorderRadius.circular(16),
          //                   border: Border.all(
          //                     width: 3,
          //                     color: Styles.mainColor,
          //                   )),
          //               child: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   ClipRRect(
          //                     borderRadius: BorderRadius.circular(8),
          //                     child: CachedNetworkImage(
          //                       imageUrl: restruant.logo,
          //                       // "https://png.pngtree.com/png-clipart/20200727/original/pngtree-restaurant-logo-design-vector-template-png-image_5441058.jpg",
          //                       height: 64,
          //                       width: 64,
          //                       fit: BoxFit.cover,
          //                       placeholder: (context, url) =>
          //                           const FlutterLogo(
          //                         size: 64,
          //                       ),
          //                       errorWidget: (context, url, error) =>
          //                           const Icon(Icons.error),
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     height: 20,
          //                   ),
          //                   Text(
          //                     restruant.name,
          //                     style: Styles.mainTextStyle.copyWith(
          //                         color: Styles.resturentNameColor,
          //                         fontSize: 19,
          //                         fontWeight: FontWeight.bold),
          //                   ),
          //                   const SizedBox(
          //                     height: 8,
          //                   ),
          //                   RichText(
          //                     text: TextSpan(
          //                       text: 'Accepting orders and booking until ',
          //                       style: Styles.mainTextStyle.copyWith(
          //                           fontSize: 16, color: Colors.grey),
          //                       children: <TextSpan>[
          //                         TextSpan(
          //                           text: '8:30',
          //                           style: Styles.mainTextStyle.copyWith(
          //                               fontWeight: FontWeight.bold,
          //                               fontSize: 16,
          //                               color: Styles.timeTextColor),
          //                         ),
          //                         const TextSpan(text: ' PM'),
          //                       ],
          //                     ),
          //                   ),
          //                   const SizedBox(
          //                     height: 8,
          //                   ),
          //                   Row(
          //                     children: [
          //                       Expanded(
          //                         child: Row(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.center,
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.start,
          //                           children: [
          //                             Text(
          //                               restruant.averageRating.toString(),
          //                               style: Styles.mainTextStyle
          //                                   .copyWith(
          //                                       color: Styles.mainColor,
          //                                       fontSize: 16,
          //                                       fontWeight:
          //                                           FontWeight.bold),
          //                             ),
          //                             const SizedBox(
          //                               width: 6,
          //                             ),
          //                             SvgPicture.asset(
          //                                 "assets/icons/star.svg"),
          //                             const SizedBox(
          //                               width: 6,
          //                             ),
          //                             Flexible(
          //                               child: Text(
          //                                 "(${restruant.totalRating})",
          //                                 style:
          //                                     Styles.mainTextStyle.copyWith(
          //                                   color: Styles.midGrayColor,
          //                                   fontSize: 16,
          //                                 ),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                       Flexible(
          //                         child: Row(
          //                           crossAxisAlignment:
          //                               CrossAxisAlignment.center,
          //                           mainAxisAlignment:
          //                               MainAxisAlignment.center,
          //                           children: [
          //                             SvgPicture.asset(
          //                                 "assets/icons/clock.svg"),
          //                             const SizedBox(
          //                               width: 6,
          //                             ),
          //                             Flexible(
          //                               child: Text(
          //                                 "3 min walk",
          //                                 style:
          //                                     Styles.mainTextStyle.copyWith(
          //                                   color: Styles.midGrayColor,
          //                                   fontSize: 16,
          //                                 ),
          //                               ),
          //                             ),
          //                           ],
          //                         ),
          //                       ),
          //                     ],
          //                   )
          //                 ],
          //               ),
          //             ),
          //           ))
          //       .toList(),
          // ))
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    // int resevedPeopleCount = 2;

    const double min = 2.0;
    const double max = 10.0;
    const SfRangeValues values = SfRangeValues(4.0, 8.0);

    final List<Data> chartData = <Data>[
      Data(x: 2.0, y: 2.5),
      Data(x: 3.0, y: 3.4),
      Data(x: 4.0, y: 2.8),
      Data(x: 5.0, y: 1.6),
      Data(x: 6.0, y: 2.3),
      Data(x: 7.0, y: 2.5),
      Data(x: 8.0, y: 2.9),
      Data(x: 9.0, y: 3.8),
      Data(x: 10.0, y: 3.7),
    ];

    int distance = 10;
    bool showBars = true;

    int? selectedRatingIndex = 0;

    final List<String> ratingsList = [
      "All",
      "5 Stars",
      "4 Stars",
      "3 Stars",
      "2 Stars",
      "1 Stars",
    ];

    List<int> selectCusineList = [];

    List<int> getRatingByIndex(int index) {
      switch (index) {
        case 0:
          return [];
        case 1:
          return [5];
        case 2:
          return [4];
        case 3:
          return [3];
        case 4:
          return [2];
        case 5:
          return [6];

        default:
          return [];
      }
    }

    final List<FilterItemModel> cusineItems = [
      FilterItemModel(id: 1, name: 'Mexican'),
      FilterItemModel(id: 2, name: 'Italian')
    ];

    List<int> selectedCusineTypes = [];

    clearAllFilters() {
      selectedCusineTypes.clear();
      selectedRatingIndex = 0;
      setState(() {});
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, setState) {
          final items = ratingsList
              .map((animal) => MultiSelectItem<String>(animal, animal))
              .toList();
          return Container(
            height: MediaQuery.of(context).size.height * 0.9,
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(13.0),
                      topRight: Radius.circular(13.0))),
              child: ListView(
                children: [
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "Filters",
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
                  const SizedBox(
                    height: 12,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Maximum Distance",
                          style: Styles.mainTextStyle.copyWith(
                            color: Styles.grayColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "$distance KM",
                          textAlign: TextAlign.end,
                          style: Styles.mainTextStyle.copyWith(
                            color: Styles.grayColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      thumbColor: Colors.white,
                      activeTrackColor: Styles.mainColor,
                      inactiveTrackColor: Colors.grey.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: distance.toDouble(),
                      max: 100.0,
                      min: 5.0,
                      onChanged: (double newValue) {
                        setState(() {
                          distance = newValue.round();
                        });
                      },
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Pricing",
                    style: Styles.mainTextStyle.copyWith(
                      color: Styles.grayColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  RichText(
                    text: TextSpan(
                      text: '10 ',
                      style: Styles.mainTextStyle.copyWith(
                          color: Styles.mainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'JOD',
                            style: Styles.mainTextStyle.copyWith(
                                color: Styles.midGrayColor,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                                textBaseline: TextBaseline.alphabetic)),
                        TextSpan(
                            text: ' - ',
                            style: Styles.mainTextStyle.copyWith(
                                color: Styles.midGrayColor,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                                textBaseline: TextBaseline.alphabetic)),
                        TextSpan(
                          text: '1000 ',
                          style: Styles.mainTextStyle.copyWith(
                              color: Styles.mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        TextSpan(
                            text: 'JOD',
                            style: Styles.mainTextStyle.copyWith(
                                color: Styles.midGrayColor,
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                decoration: TextDecoration.none,
                                textBaseline: TextBaseline.alphabetic)),
                      ],
                    ),
                  ),
                  Center(
                    child: SfRangeSelector(
                      min: min,
                      max: max,
                      interval: 2,
                      showLabels: false,
                      showTicks: true,
                      enableTooltip: false,
                      initialValues: values,
                      child: SizedBox(
                        height: 130,
                        child: SfCartesianChart(
                          margin: const EdgeInsets.all(0),
                          primaryXAxis: NumericAxis(
                            minimum: min,
                            maximum: max,
                            isVisible: false,
                          ),
                          primaryYAxis: NumericAxis(isVisible: false),
                          plotAreaBorderWidth: 0,
                          series: <ColumnSeries<Data, double>>[
                            ColumnSeries<Data, double>(
                                color: const Color.fromARGB(255, 126, 184, 253),
                                dataSource: chartData,
                                xValueMapper: (Data sales, int index) =>
                                    sales.x,
                                yValueMapper: (Data sales, int index) =>
                                    sales.y)
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 9,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        // flex: 10,
                        child: Text(
                          "Show Bars and Pubs",
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
                            value: showBars,

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
                                showBars = value ?? false;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Rating",
                    style: Styles.mainTextStyle.copyWith(
                      color: Styles.grayColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Wrap(
                    spacing: 5.0,
                    children: List<Widget>.generate(
                      ratingsList.length,
                      (int index) {
                        return Container(
                          // width: 81,
                          child: ChoiceChip(
                            backgroundColor: Colors.white,
                            selectedColor: selectedRatingIndex == index
                                ? Styles.listTileBorderColr
                                : Colors.white,
                            // selectedColor: ,
                            side: BorderSide(
                              width: selectedRatingIndex == index ? 2 : 1,
                              color: selectedRatingIndex == index
                                  ? Styles.listTileBorderColr
                                  : Styles.midGrayColor,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            // padding: EdgeInsets.all(8),
                            label: SizedBox(
                              // width: 50,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Visibility(
                                    visible: index != 0,
                                    child: const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  Text(
                                    ratingsList[index],
                                    style: Styles.mainTextStyle.copyWith(
                                        color: selectedRatingIndex == index
                                            ? Styles.resturentNameColor
                                            : Styles.grayColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            selected: selectedRatingIndex == index,
                            onSelected: (bool selected) {
                              setState(() {
                                selectedRatingIndex = selected ? index : null;
                              });
                            },
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Cuisine",
                    style: Styles.mainTextStyle.copyWith(
                      color: Styles.grayColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MultiSelectChip(
                    cusineItems,
                    onSelectionChanged: (selectedList) {
                      setState(() {
                        selectedCusineTypes = selectedList;
                      });
                      // print(selectedCusineTypes.toString());
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Divider(
                    height: 5,
                    thickness: 1,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomOutlinedButton(
                      label: "Show 14 Results",
                      isIconVisible: false,
                      backGroundColor: Styles.mainColor,
                      onPressedButton: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //       builder: (context) => ResturanMenuPage(
                        //             resturantDetails: _resturantDetails!,
                        //             isFormAddOrderPage: false,
                        //           )),
                        // );
                      },
                      icon: Container(),
                      borderSide: const BorderSide(color: Styles.mainColor),
                      textStyle: Styles.mainTextStyle.copyWith(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomOutlinedButton(
                      label: "Clear all",
                      isIconVisible: false,
                      backGroundColor: Styles.listTileBorderColr,
                      onPressedButton: () {
                        clearAllFilters();
                      },
                      icon: Container(),
                      borderSide:
                          const BorderSide(color: Styles.listTileBorderColr),
                      textStyle: Styles.mainTextStyle.copyWith(
                          color: Styles.mainColor,
                          fontSize: 17,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        });
      },
    );
  }
}

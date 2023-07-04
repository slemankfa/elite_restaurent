import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:elite/core/helper_methods.dart';
import 'package:elite/core/location_helper.dart';
import 'package:elite/core/styles.dart';
import 'package:elite/models/cusine_model.dart';
import 'package:elite/models/resturant_model.dart';
import 'package:elite/screens/resturant_pages/resturant_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';

import '../../core/widgets/custom_outline_button.dart';
import '../../models/filter_item_model.dart';
import '../../models/user_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/resturant_provider.dart';
import '../auth_pages/start_page.dart';
import 'notifcation_page.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final HelperMethods _helperMethods = HelperMethods();
  final LocationHelper _locationHelper = LocationHelper();
  int resturantsCount = 0;
  int _pageNumber = 1;
  final ScrollController _resturantsListController = ScrollController();
  late Function popUpProgressIndcator;
  bool _isThereNextPage = false;
  List<ResturantModel> _resturantsList = [];
  final Set<Marker> _loadedMarkers = {};
  bool _isLoading = false;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor selectedMarkerIcon = BitmapDescriptor.defaultMarker;
  int _selctedMarkerIndex = 0;
  final CarouselController _cursoerController = CarouselController();
  bool locationDenied = true;

  ///
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
// _resturantsListController.
    // _cursoerController.dispose()
  }

  @override
  void initState() {
    addCustomIcon();
    _resturantsListController.addListener(() {
      if (_resturantsListController.position.pixels ==
          _resturantsListController.position.maxScrollExtent) {
        print("from inist satate");

        if (!_isThereNextPage) return;
        fetchRestursantsList();
      }
    });
    fetchRestursantsCusineList();
    fetchRestursantsList();

    super.initState();
  }

  Future refreshList() async {
    _loadedMarkers.clear();
    _pageNumber = 1;
    _selctedMarkerIndex = 0;
    setState(() {});
    await fetchRestursantsList();
    await handlMapMarkersList();

    // selectedCusineTypes.clear();
    // selectedRatingIndex = 0;
    // distance = 10;
    // showBars = false;
  }

  showAllowLocationDilog({required BuildContext context}) {
    showDialog(
        context: context,
        builder: (ctx) => SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AlertDialog(
                scrollable: true,
                contentPadding: const EdgeInsets.all(8),
                insetPadding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                // title: Center(
                //   child: Text(
                //     "Confirmed",
                //     style: Styles.mainTextStyle.copyWith(
                //         color: Styles.grayColor,
                //         fontSize: 20,
                //         fontWeight: FontWeight.bold),
                //   ),
                // ),
                content: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    // SizedBox(
                    //   height: 15,
                    // ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        child: Text(
                          "Allow App to your location while you’re using the app",
                          style: Styles.mainTextStyle.copyWith(
                              color: Styles.grayColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        child: Text(
                          "App uses your location to help and find the great restaurants near you",
                          style: Styles.mainTextStyle.copyWith(
                              color: Styles.grayColor,
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomOutlinedButton(
                              label: "Don't Allow",
                              isIconVisible: false,
                              backGroundColor: Colors.white,
                              onPressedButton: () {
                                Navigator.of(context).pop();
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => ResturanMenuPage()),
                                // );
                              },
                              rectangleBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              icon: Container(),
                              borderSide:
                                  const BorderSide(color: Styles.mainColor),
                              textStyle: Styles.mainTextStyle.copyWith(
                                  color: Styles.mainColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: CustomOutlinedButton(
                              label: "Allow",
                              isIconVisible: false,
                              onPressedButton: () async {
                                await enableLocationFromSetting();
                                // locationDenied = false;
                                // Phoenix.rebirth(context);

                                // RestartWidget.restartApp(context);
                                // (context as Element).reassemble();
                                Navigator.of(context).pop();
                                Future.delayed(const Duration(seconds: 2))
                                    .then((value) {
                                  print("sdasdasd");
                                  fetchRestursantsList();
                                });

                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //       builder: (context) => ResturanMenuPage()),
                                // );
                              },
                              rectangleBorder: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              icon: Container(),
                              backGroundColor: Styles.mainColor,
                              borderSide:
                                  const BorderSide(color: Styles.mainColor),
                              textStyle: Styles.mainTextStyle.copyWith(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ));
  }

  /* 
  Map section
   */

  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/cust_marker.png")
        .then(
      (icon) {
        markerIcon = icon;
      },
    );

    BitmapDescriptor.fromAssetImage(
            const ImageConfiguration(), "assets/images/selected_cust_map.png")
        .then(
      (icon) {
        selectedMarkerIcon = icon;
      },
    );
    setState(() {});
  }

  Future enableLocationFromSetting() async {
    await _locationHelper.openAppSettingToEnable();

    // await _locationHelper.getDeviceLocation();
  }

  Future fetchRestursantsList() async {
    // popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();
    try {
      setState(() {
        _isLoading = true;
      });
      LocationData? locationData = await _locationHelper.getDeviceLocation();
      // print(locationData.toString());
      if (locationData == null) {
        // showAllowLocationDilog(context: context);
        setState(() {
          _isLoading = false;
        });
        return;
      }

      setState(() {
        locationDenied = false;
      });
      // ignore: use_build_context_synchronously
      await Provider.of<ResturantProvider>(context, listen: false)
          .getResturantsList(
        context: context,
        pageNumber: _pageNumber,
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        maximumDistance: distance,
        cousine: filterSelectedCusineTypes,
        ratings: getRatingByIndex(selectedRatingIndex!),
        isBars: showBars,
        pricing: filterSelectedResturantsPricings,
        periods: filterSelectedResturantsPeriod,
        resturantTypes: filterSelectedResturantsType,
        dietary: filterSelectedDiertyType,
      ) //3
          .then((informationMap) async {
        if (_pageNumber == 1) {
          _resturantsList = informationMap["list"];
          resturantsCount = _resturantsList.length;
        } else {
          _resturantsList.addAll(informationMap["list"]);
        }

        _isThereNextPage = informationMap["isThereNextPage"] ?? false;
        _pageNumber++;
        popUpProgressIndcator.call();
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

    Future.delayed(const Duration(seconds: 1)).then((value) {
      handlMapMarkersList();
    });
  }

  handlMapMarkersList() {
    for (var i = 0; i < _resturantsList.length; i++) {
      if (_resturantsList[i].latitude != null) {
        Marker tempMarker = Marker(
          markerId: MarkerId(_resturantsList[i].id),
          position: LatLng(
              _resturantsList[i].latitude!, _resturantsList[i].longitude!),
          draggable: false,
          icon: _selctedMarkerIndex == i ? selectedMarkerIcon : markerIcon,
          onTap: () {
            // print(i);

            getResturantMarkerIndex(i);
          },
          onDragEnd: (value) {
            // print(value.toString());
            // value is the new position
          },
          // To do: custom marker icon
        );
        _loadedMarkers.add(tempMarker);
      }
    }

    setState(() {});
    print("handlMapMarkersList");
  }

  getResturantMarkerIndex(int index) {
    setState(() {
      _selctedMarkerIndex = index;
    });
    _loadedMarkers.clear();

    handlMapMarkersList();
    _cursoerController.animateToPage(index,
        duration: const Duration(milliseconds: 200));
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

// Amman location
  static const CameraPosition _ammanInitalLocation = CameraPosition(
    target: LatLng(31.8356836, 36.087714),
    zoom: 15,
  );

  Future<void> moveToMyLocation() async {
    LocationData? locationData = await _locationHelper.getDeviceLocation();

    if (locationData == null) {
      return;
    }
    CameraPosition myCurrentPostion = CameraPosition(
      target: LatLng(locationData.latitude!, locationData.longitude!),
      // target: LatLng(31.9297911, 35.962773),
      zoom: 15,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(myCurrentPostion));
  }

  Future<void> moveToResturantLocation(ResturantModel resturantModel) async {
    if (resturantModel.latitude == null) return;
    CameraPosition resturanPostion = CameraPosition(
      // target: LatLng(locationData.latitude!, locationData.longitude!),
      target: LatLng(resturantModel.latitude!, resturantModel.longitude!),
      zoom: 15,
    );

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(resturanPostion));
  }

// end map section

//-----------------Filter sections--------------

  /// filters
  int distance = 10;
  bool showBars = false;
  int? selectedRatingIndex = 0;

  List<int> filterSelectedCusineTypes = [];
  List<int> filterSelectedResturantsPricings = [];
  List<int> filterSelectedResturantsPeriod = [];
  List<int> filterSelectedResturantsType = [];
  List<int> filterSelectedDiertyType = [];
  double globalFilterSpacedHeight = 10;

  List<CusineModel> _cusinesList = [];
  List<FilterItemModel> resturantsCusineItemsFilters = [];
  List<FilterItemModel> resturantPricingItemsFilters = [
    FilterItemModel(id: 1, name: "\$\$\$"),
    FilterItemModel(id: 2, name: "\$\$"),
    FilterItemModel(id: 3, name: "\$")
  ];

  List<FilterItemModel> resturantPeriodsFilter = [
    FilterItemModel(id: 0, name: "Breakfast"),
    FilterItemModel(id: 1, name: "Lunch"),
    FilterItemModel(id: 2, name: "Dinner")
  ];

  List<FilterItemModel> resturantTypeFilter = [
    FilterItemModel(id: 0, name: "Drinks"),
    FilterItemModel(id: 1, name: "Desserts"),
  ];

  List<FilterItemModel> resturantDiertyFilter = [
    FilterItemModel(id: 0, name: "Gluten Free"),
    FilterItemModel(id: 1, name: "Dairy Free"),
    FilterItemModel(id: 2, name: "Vegeterian"),
  ];

  Future fetchRestursantsCusineList() async {
    try {
      await Provider.of<ResturantProvider>(context, listen: false)
          .getResturantsCusinesList() //3
          .then((informationMap) async {
        if (_pageNumber == 1) {
          _cusinesList = informationMap["list"];
        } else {
          _cusinesList.addAll(informationMap["list"]);
        }

        resturantsCusineItemsFilters = _cusinesList
            .map(
              (e) => FilterItemModel(id: e.id, name: e.name),
            )
            .toList();
      });
    } catch (e) {
      print(e.toString());
    }
  }

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
        return [1];

      default:
        return [];
    }
  }

  // handleAddedPricingToFiliters() {
  //   pricingItems.add(FilterItemModel(id: 1, name: "\$\$\$"));
  //   pricingItems.add(FilterItemModel(id: 2, name: "\$\$"));
  //   pricingItems.add(FilterItemModel(id: 3, name: "\$"));
  // }

  //-----------------Filter sections--------------

  convertToNotifcationPage() async {
    final _isGuestUser = await _helperMethods.checkIsGuest();
    if (_isGuestUser) {
      Navigator.of(context).pushNamed(StartPage.routeName);
      return;
    }
    Navigator.of(context).pushNamed(NotificationPage.routeName);
  }

  @override
  Widget build(BuildContext context) {
    UserModel? userModel = Provider.of<AuthProvider>(
      context,
    ).userInformation;
    return Scaffold(
      // backgroundColor: Colors.amber,
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _ammanInitalLocation,
            myLocationButtonEnabled: false,
            markers: _isLoading ? {} : _loadedMarkers,
            myLocationEnabled: true,
            // onTap: (latlang) {
            //   print(latlang.latitude);
            //   print(latlang.longitude);
            // },
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              // if(_resturantsList.isNotEmpty){
              //   handlMapMarkersList();
              // }
              // moveToMyLocation();
            },
          ),
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
                                      : "${userModel.firstName.toString()} ${userModel.lastName.toString()}!",
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
                          onTap: convertToNotifcationPage,
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
            child: _isLoading
                ? Center(
                    child: _helperMethods.progressIndcator(),
                  )
                : locationDenied
                    ? Center(
                        child: CustomOutlinedButton(
                            label: "Enable Location From Settings",
                            isIconVisible: false,
                            onPressedButton: () async {
                              await showAllowLocationDilog(context: context);

                              // Navigator.of(context).pop();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => ResturanMenuPage()),
                              // );
                            },
                            rectangleBorder: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            icon: Container(),
                            backGroundColor: Styles.mainColor,
                            borderSide:
                                const BorderSide(color: Styles.mainColor),
                            textStyle: Styles.mainTextStyle.copyWith(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      )
                    : _resturantsList.isEmpty
                        ? Center(
                            child: Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                  color: Styles.mainColor,
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                "No Restaurants!",
                                style: Styles.mainTextStyle.copyWith(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          )
                        : CarouselSlider(
                            items: List<Widget>.generate(_resturantsList.length,
                                (index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ResturentDetailPage(
                                              resturantId:
                                                  _resturantsList[index].id,
                                            )),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  // height: 200,
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        width: 3,
                                        color: _selctedMarkerIndex == index
                                            ? Styles.mainColor
                                            : Colors.white,
                                      )),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: CachedNetworkImage(
                                          imageUrl: _resturantsList[index].logo,
                                          // "https://png.pngtree.com/png-clipart/20200727/original/pngtree-restaurant-logo-design-vector-template-png-image_5441058.jpg",
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
                                            text:
                                                'Accepting orders and booking until ',
                                            style: Styles.mainTextStyle
                                                .copyWith(
                                                    fontSize: 16,
                                                    color: Colors.grey),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '8:30',
                                                style: Styles.mainTextStyle
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        color: Styles
                                                            .timeTextColor),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  _resturantsList[index]
                                                      .averageRating
                                                      .toString(),
                                                  style: Styles.mainTextStyle
                                                      .copyWith(
                                                          color:
                                                              Styles.mainColor,
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                SvgPicture.asset(
                                                    "assets/icons/star.svg"),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "(${_resturantsList[index].totalRating})",
                                                    style: Styles.mainTextStyle
                                                        .copyWith(
                                                      color:
                                                          Styles.midGrayColor,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Flexible(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SvgPicture.asset(
                                                    "assets/icons/clock.svg"),
                                                const SizedBox(
                                                  width: 6,
                                                ),
                                                Flexible(
                                                  child: Text(
                                                    "3 min walk",
                                                    style: Styles.mainTextStyle
                                                        .copyWith(
                                                      color:
                                                          Styles.midGrayColor,
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
                            carouselController: _cursoerController,
                            options: CarouselOptions(
                                autoPlay: false,
                                enlargeCenterPage: true,
                                viewportFraction: 0.8,
                                aspectRatio: 1,
                                disableCenter: true,
                                reverse: false,
                                enableInfiniteScroll: false,
                                // enlargeCenterPage: true,
                                // aspectRatio: 2.0,
                                // pageSnapping: false,
                                padEnds: true,
                                onPageChanged: (index, reason) {
                                  getResturantMarkerIndex(index);
                                  moveToResturantLocation(
                                      _resturantsList[index]);
                                }),
                          ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    // int resevedPeopleCount = 2;

    final List<String> ratingsList = [
      "All",
      "5 Stars",
      "4 Stars",
      "3 Stars",
      "2 Stars",
      "1 Stars",
    ];

    clearAllFilters() {
      print("clear");
      filterSelectedCusineTypes.clear();
      filterSelectedResturantsPricings.clear();
      filterSelectedResturantsPeriod.clear();
      filterSelectedResturantsType.clear();
      filterSelectedDiertyType.clear();
      selectedRatingIndex = 0;
      distance = 10;
      showBars = false;

      resturantPricingItemsFilters.map((e) => e.isselectd = false).toList();
      resturantPeriodsFilter.map((e) => e.isselectd = false).toList();
      resturantTypeFilter.map((e) => e.isselectd = false).toList();
      resturantsCusineItemsFilters.map((e) => e.isselectd = false).toList();
      resturantDiertyFilter.map((e) => e.isselectd = false).toList();
      setState(() {});

      Navigator.of(context).pop();
      refreshList();
    }

    // bool isSearching = false;

    searchingResturants(ResturantProvider provider) async {
      try {
        LocationData? locationData = await _locationHelper.getDeviceLocation();
        if (locationData == null) {
          return;
        }
        provider.filterSearching(
          latitude: locationData.latitude!,
          longitude: locationData.longitude!,
          maximumDistance: distance,
          cousine: filterSelectedCusineTypes,
          ratings: getRatingByIndex(selectedRatingIndex!),
          pricing: filterSelectedResturantsPricings,
          periods: filterSelectedResturantsPeriod,
          resturantTypes: filterSelectedResturantsType,
          dietary: filterSelectedDiertyType,
          isBars: showBars,
        );
      } catch (e) {
        print(e.toString());
      }
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13.0),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (BuildContext context, filterSetState) {
          final items = ratingsList
              .map((animal) => MultiSelectItem<String>(animal, animal))
              .toList();
          return Consumer<ResturantProvider>(
            builder: (context, provider, child) {
              // searchingResturants(provider);
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
                              style:
                                  Styles.mainTextStyle.copyWith(fontSize: 20),
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
                                  color:
                                      Styles.closeBottomSheetBackgroundColor),
                              child: Icon(
                                Icons.close,
                                color: Styles.closeBottomIconColor
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      const Divider(),
                      SizedBox(
                        height: globalFilterSpacedHeight,
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
                            filterSetState(() {
                              distance = newValue.round();
                            });
                          },
                        ),
                      ),
                      const Divider(),
                      // const SizedBox(
                      //   height: 20,
                      // ),

                      // const SizedBox(
                      //   height: 9,
                      // ),
                      // const Divider(),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      Row(
                        children: [
                          Expanded(
                            // flex: 10,
                            child: Text(
                              "Show Bars and Pubs",
                              style: Styles.mainTextStyle.copyWith(
                                  fontSize: 16, color: Styles.grayColor),
                            ),
                          ),
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(color: Styles.mainColor, width: 1),
                            ),
                            child: Theme(
                              // color: Colors.white,
                              data: ThemeData(
                                  unselectedWidgetColor: Colors.white),
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
                                fillColor:
                                    MaterialStateProperty.all(Colors.white),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                onChanged: (value) {
                                  filterSetState(() {
                                    showBars = value ?? false;
                                  });

                                  searchingResturants(provider);
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      const Divider(),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      Text(
                        "Rating",
                        style: Styles.mainTextStyle.copyWith(
                          color: Styles.grayColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
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
                                  filterSetState(() {
                                    selectedRatingIndex =
                                        selected ? index : null;
                                  });

                                  searchingResturants(provider);
                                  // searchingResturants();
                                },
                              ),
                            );
                          },
                        ).toList(),
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      const Divider(),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      Text(
                        "Pricings",
                        style: Styles.mainTextStyle.copyWith(
                          color: Styles.grayColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      Wrap(
                        spacing: 5,
                        direction: Axis.horizontal,
                        children: List.generate(
                            resturantPricingItemsFilters.length, (index) {
                          return InkWell(
                            onTap: () {
                              print("clicked");
                              if (resturantPricingItemsFilters[index]
                                  .isselectd) {
                                filterSelectedResturantsPricings.remove(
                                    resturantPricingItemsFilters[index].id);
                              } else {
                                filterSelectedResturantsPricings.add(
                                    resturantPricingItemsFilters[index].id);
                              }

                              filterSetState(() {
                                resturantPricingItemsFilters[index].isselectd =
                                    !resturantPricingItemsFilters[index]
                                        .isselectd;
                              });
                              // print(filterSelectedResturantsPricings.length
                              //     .toString());
                              searchingResturants(provider);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              decoration: BoxDecoration(
                                color: resturantPricingItemsFilters[index]
                                        .isselectd
                                    ? Styles.mainColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: resturantPricingItemsFilters[index]
                                        .isselectd
                                    ? null
                                    : Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (resturantPricingItemsFilters[index]
                                      .isselectd)
                                    const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  Text(
                                    resturantPricingItemsFilters[index].name,
                                    style: Styles.mainTextStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            !resturantPricingItemsFilters[index]
                                                    .isselectd
                                                ? Styles.grayColor
                                                : Colors.white),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      const Divider(),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      Text(
                        "Periods",
                        style: Styles.mainTextStyle.copyWith(
                          color: Styles.grayColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      Wrap(
                        spacing: 5,
                        direction: Axis.horizontal,
                        children: List.generate(resturantPeriodsFilter.length,
                            (index) {
                          return InkWell(
                            onTap: () {
                              print("clicked");
                              if (resturantPeriodsFilter[index].isselectd) {
                                filterSelectedResturantsPeriod
                                    .remove(resturantPeriodsFilter[index].id);
                              } else {
                                filterSelectedResturantsPeriod
                                    .add(resturantPeriodsFilter[index].id);
                              }

                              filterSetState(() {
                                resturantPeriodsFilter[index].isselectd =
                                    !resturantPeriodsFilter[index].isselectd;
                              });
                              // print(filterSelectedResturantsPeriod.length
                              //     .toString());
                              searchingResturants(provider);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              decoration: BoxDecoration(
                                color: resturantPeriodsFilter[index].isselectd
                                    ? Styles.mainColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: resturantPeriodsFilter[index].isselectd
                                    ? null
                                    : Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (resturantPeriodsFilter[index].isselectd)
                                    const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  Text(
                                    resturantPeriodsFilter[index].name,
                                    style: Styles.mainTextStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: !resturantPeriodsFilter[index]
                                                .isselectd
                                            ? Styles.grayColor
                                            : Colors.white),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      const Divider(),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      Text(
                        "Resturant type",
                        style: Styles.mainTextStyle.copyWith(
                          color: Styles.grayColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      Wrap(
                        spacing: 5,
                        direction: Axis.horizontal,
                        children:
                            List.generate(resturantTypeFilter.length, (index) {
                          return InkWell(
                            onTap: () {
                              if (resturantTypeFilter[index].isselectd) {
                                filterSelectedResturantsType
                                    .remove(resturantTypeFilter[index].id);
                              } else {
                                filterSelectedResturantsType
                                    .add(resturantTypeFilter[index].id);
                              }

                              filterSetState(() {
                                resturantTypeFilter[index].isselectd =
                                    !resturantTypeFilter[index].isselectd;
                              });
                              // print(filterSelectedResturantsType.length
                              //     .toString());
                              searchingResturants(provider);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              decoration: BoxDecoration(
                                color: resturantTypeFilter[index].isselectd
                                    ? Styles.mainColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: resturantTypeFilter[index].isselectd
                                    ? null
                                    : Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (resturantTypeFilter[index].isselectd)
                                    const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  Text(
                                    resturantTypeFilter[index].name,
                                    style: Styles.mainTextStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: !resturantTypeFilter[index]
                                                .isselectd
                                            ? Styles.grayColor
                                            : Colors.white),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      const Divider(),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      Text(
                        "Cuisine",
                        style: Styles.mainTextStyle.copyWith(
                          color: Styles.grayColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      Wrap(
                        spacing: 5,
                        direction: Axis.horizontal,
                        children: List.generate(
                            resturantsCusineItemsFilters.length, (index) {
                          return InkWell(
                            onTap: () {
                              print("clicked");
                              if (resturantsCusineItemsFilters[index]
                                  .isselectd) {
                                filterSelectedCusineTypes.remove(
                                    resturantsCusineItemsFilters[index].id);
                              } else {
                                filterSelectedCusineTypes.add(
                                    resturantsCusineItemsFilters[index].id);
                              }
                              filterSetState(() {
                                resturantsCusineItemsFilters[index].isselectd =
                                    !resturantsCusineItemsFilters[index]
                                        .isselectd;
                              });
                              searchingResturants(provider);
                            },
                            child: Container(
                              // padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              decoration: BoxDecoration(
                                color: resturantsCusineItemsFilters[index]
                                        .isselectd
                                    ? Styles.mainColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: resturantsCusineItemsFilters[index]
                                        .isselectd
                                    ? null
                                    : Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (resturantsCusineItemsFilters[index]
                                      .isselectd)
                                    const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  Text(
                                    resturantsCusineItemsFilters[index].name,
                                    style: Styles.mainTextStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            !resturantsCusineItemsFilters[index]
                                                    .isselectd
                                                ? Styles.grayColor
                                                : Colors.white),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      // MultiSelectChip(
                      //   cusineItems,
                      //   onSelectionChanged: (selectedList) {
                      //     filterSetState(() {
                      //       selectedCusineTypes = selectedList;
                      //     });
                      //     // print(selectedCusineTypes.toString());
                      //     searchingResturants(provider);
                      //   },
                      // ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      const Divider(),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      Text(
                        "Dietry",
                        style: Styles.mainTextStyle.copyWith(
                          color: Styles.grayColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      Wrap(
                        spacing: 5,
                        direction: Axis.horizontal,
                        children: List.generate(resturantDiertyFilter.length,
                            (index) {
                          return InkWell(
                            onTap: () {
                              if (resturantDiertyFilter[index].isselectd) {
                                filterSelectedDiertyType
                                    .remove(resturantDiertyFilter[index].id);
                              } else {
                                filterSelectedDiertyType
                                    .add(resturantDiertyFilter[index].id);
                              }

                              filterSetState(() {
                                resturantDiertyFilter[index].isselectd =
                                    !resturantDiertyFilter[index].isselectd;
                              });
                              // print(filterSelectedDiertyType.length.toString());
                              searchingResturants(provider);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              decoration: BoxDecoration(
                                color: resturantDiertyFilter[index].isselectd
                                    ? Styles.mainColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(50),
                                border: resturantDiertyFilter[index].isselectd
                                    ? null
                                    : Border.all(color: Colors.grey),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (resturantDiertyFilter[index].isselectd)
                                    const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                    ),
                                  Text(
                                    resturantDiertyFilter[index].name,
                                    style: Styles.mainTextStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: !resturantDiertyFilter[index]
                                                .isselectd
                                            ? Styles.grayColor
                                            : Colors.white),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      const Divider(
                        height: 5,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: globalFilterSpacedHeight,
                      ),
                      provider.isSearching
                          ? _helperMethods.progressIndcator()
                          : CustomOutlinedButton(
                              label: "Show ${provider.resturantCount} Results",
                              isIconVisible: false,
                              backGroundColor: Styles.mainColor,
                              onPressedButton: () async {
                                Navigator.of(context).pop();
                                await refreshList();
                              },
                              icon: Container(),
                              borderSide:
                                  const BorderSide(color: Styles.mainColor),
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
                            provider.resturantCount = 0;
                            // setState(() {});
                          },
                          icon: Container(),
                          borderSide: const BorderSide(
                              color: Styles.listTileBorderColr),
                          textStyle: Styles.mainTextStyle.copyWith(
                              color: Styles.mainColor,
                              fontSize: 17,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            },
          );
        });
      },
    );
  }
}

import 'package:elite/models/reservation_model.dart';
import 'package:elite/providers/reservation_provider.dart';
import 'package:elite/screens/profile_pages/widgtes/reservation_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helper_methods.dart';
import '../../core/styles.dart';

class MyReservationListPage extends StatefulWidget {
  const MyReservationListPage({super.key});

  @override
  State<MyReservationListPage> createState() => _MyReservationListPageState();
  static const routeName = "/my-reservation-page";
}

class _MyReservationListPageState extends State<MyReservationListPage> {
  //  All = 0 ,Cancel = 1, Past = 2, Upcoming = 3
  int? _selectedReservationType = 0;
  List<String> reservationType = ["All", "Canceled", "Past", "Upcoming"];

  int _pageNumber = 1;
  final ScrollController _reservationListController = ScrollController();
  final HelperMethods _helperMethods = HelperMethods();
  late Function popUpProgressIndcator;
  List<ReservationModel> _reservationList = [];
  bool _isLoading = false;

  @override
  void initState() {
    // _mealsListController.addListener(() {
    //   if (_mealsListController.position.pixels ==
    //       _mealsListController.position.maxScrollExtent) {
    //     print("from inist satate");

    //     if (!_isThereNextPage) return;
    //     fetchMeals();
    //   }
    // });

    fetchReservations();

    super.initState();
  }

  Future refreshList() async {
    _pageNumber = 1;
    _selectedReservationType = 0;
    fetchReservations();
  }

  Future fetchReservations() async {
    // popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ReservationProvider>(context, listen: false)
          .fetchMyReservation(
              context: context,
              pageNumber: _pageNumber,
              status: _selectedReservationType!)
          .then((map) {
        // if (_pageNumber == 1) {
        //   _mealsList = informationMap["list"];
        // } else {
        //   _mealsList.addAll(informationMap["list"]);
        // }
        _reservationList = map["list"];
        setState(() {
          _isLoading = false;
        });
        // setState(() {
        //   // _isThereNextPage = informationMap["isThereNextPage"] ?? false;
        //   // _pageNumber++;
        //   // popUpProgressIndcator.call();
        // });
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Styles.grayColor),
        title: Text(
          "My reservations",
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: _isLoading
            ? _helperMethods.progressIndcator()
            : Column(
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
                            side: _selectedReservationType == index
                                ? null
                                : const BorderSide(
                                    width: 1, color: Styles.midGrayColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            // padding: EdgeInsets.all(8),
                            label: Container(
                              // width: 50,
                              child: Text(
                                reservationType[index],
                                style: Styles.mainTextStyle.copyWith(
                                    color: _selectedReservationType == index
                                        ? Styles.mainColor
                                        : Styles.grayColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            selected: _selectedReservationType == index,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedReservationType =
                                    selected ? index : null;
                              });
                              fetchReservations();
                            },
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _reservationList.isEmpty
                      ? Center(
                          child: Text(
                            "No reservations.",
                            style: Styles.mainTextStyle,
                          ),
                        )
                      : Expanded(
                          child: ListView.separated( 
                            itemBuilder: (context, index) => ReservationItem(
                              reservationModel: _reservationList[index],
                              updateUI: fetchReservations,
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 8,
                            ),
                            itemCount: _reservationList.length,
                          ),
                        )
                ],
              ),
      ),
    );
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite/providers/reservation_provider.dart';
import 'package:elite/screens/reservation_pages%20/reservation_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../core/helper_methods.dart';
import '../../core/styles.dart';
import '../../models/resturant_model.dart';
import '../../models/table_model.dart';
import '../../providers/resturant_provider.dart';

class ReservationAvalibleTabelsPage extends StatefulWidget {
  const ReservationAvalibleTabelsPage(
      {super.key,
      required this.resturantDetails,
      required this.date,
      required this.time,
      required this.numberOfSeats});

  @override
  State<ReservationAvalibleTabelsPage> createState() =>
      _ReservationAvalibleTabelsPageState();
  final ResturantModel resturantDetails;
  final String date;
  final String time;
  final String numberOfSeats;
}

class _ReservationAvalibleTabelsPageState
    extends State<ReservationAvalibleTabelsPage> {
  int _pageNumber = 1;
  ScrollController _menuListController = ScrollController();
  HelperMethods _helperMethods = HelperMethods();
  late Function popUpProgressIndcator;
  bool _isThereNextPage = false;
  bool _isLoading = false;
  List<TableModel> _tablesList = [];

  @override
  void initState() {
    _menuListController.addListener(() {
      if (_menuListController.position.pixels ==
          _menuListController.position.maxScrollExtent) {
        print("from inist satate");

        if (!_isThereNextPage) return;
        fetchTabels();
      }
    });

    fetchTabels();

    super.initState();
  }

  Future refreshList() async {
    _pageNumber = 1;
    fetchTabels();
  }

  Future fetchTabels() async {
    // popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<ReservationProvider>(context, listen: false)
          .getResturantMenuItemMeals(
              context: context,
              pageNumber: _pageNumber,
              restId: widget.resturantDetails.id,
              date: widget.date,
              Seats: widget.numberOfSeats) //3
          .then((informationMap) {
        if (_pageNumber == 1) {
          _tablesList = informationMap["list"];
        } else {
          _tablesList.addAll(informationMap["list"]);
        }
        setState(() {
          _isThereNextPage = informationMap["isThereNextPage"] ?? false;
          _pageNumber++;
          _isLoading = false;
          // popUpProgressIndcator.call();
        });
      });
    } catch (e) {
      // popUpProgressIndcator.call();
      setState(() {
        _isLoading = true;
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
        iconTheme: IconThemeData(color: Styles.grayColor),
        title: Text(
          "Select Table",
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: _isLoading
            ? Center(
                child: _helperMethods.progressIndcator(),
              )
            : _tablesList.isEmpty
                ? Center(
                    child: Text(
                      "لا يوجد قائمة",
                      style: Styles.mainTextStyle,
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: refreshList,
                    child: ListView.builder(
                        itemCount: _tablesList.length,
                        itemBuilder: (context, index) {
                          return TableItem(
                            table: _tablesList[index],
                            resturantDetails: widget.resturantDetails,
                          );
                        }),
                  ),
      ),
    );
  }
}

class TableItem extends StatelessWidget {
  const TableItem({
    super.key,
    required this.resturantDetails,
    required this.table,
  });
  final ResturantModel resturantDetails;
  final TableModel table;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ReservationDetailsPage()),
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
            border: Border.all(color: Styles.RatingRivewBoxBorderColor)),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
              child: CachedNetworkImage(
                imageUrl: table.tableImage,
                // "https://thumbs.dreamstime.com/b/restaurant-tables-18344514.jpg",
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
                      table.name,
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
    );
  }
}

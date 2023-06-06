import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite/providers/reservation_provider.dart';
import 'package:elite/screens/reservation_pages%20/reservation_details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helper_methods.dart';
import '../../core/styles.dart';
import '../../models/resturant_model.dart';
import '../../models/table_model.dart';

class ReservationAvalibleTabelsPage extends StatefulWidget {
  const ReservationAvalibleTabelsPage(
      {super.key,
      required this.resturantDetails,
      required this.date,
      required this.time,
      required this.numberOfSeats,
      required this.isIndoor});

  @override
  State<ReservationAvalibleTabelsPage> createState() =>
      _ReservationAvalibleTabelsPageState();
  final ResturantModel resturantDetails;
  final String date;
  final String time;
  final String numberOfSeats;
  final bool isIndoor;
}

class _ReservationAvalibleTabelsPageState
    extends State<ReservationAvalibleTabelsPage> {
  int _pageNumber = 1;
  final ScrollController _menuListController = ScrollController();
  final HelperMethods _helperMethods = HelperMethods();
  late Function popUpProgressIndcator;
  bool _isThereNextPage = false;
  bool _isLoading = false;
  String _checkTableMessage = "";
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
          .getResturantAvalibleTabels(
              context: context,
              isIndoor: widget.isIndoor,
              time: widget.time,
              pageNumber: _pageNumber,
              restId: widget.resturantDetails.id,
              date: widget.date,
              seats: widget.numberOfSeats) //3
          .then((informationMap) {
        // print(informationMap.toString());
        if (_pageNumber == 1) {
          _tablesList = informationMap["list"];
        } else {
          _tablesList.addAll(informationMap["list"]);
        }
        _checkTableMessage = informationMap["message"] ?? "";
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
      // print(e.toString());
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
          "Select Table",
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
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
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_checkTableMessage.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Styles.DividerColor),
                          child: Text(
                            _checkTableMessage,
                            style: Styles.mainTextStyle.copyWith(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      if (_checkTableMessage.isNotEmpty)
                        const SizedBox(
                          height: 10,
                        ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: refreshList,
                          child: ListView.separated(
                              separatorBuilder: (context, index) =>
                                  const SizedBox(
                                    height: 10,
                                  ),
                              itemCount: _tablesList.length,
                              itemBuilder: (context, index) {
                                return TableItem(
                                  table: _tablesList[index],
                                  time: widget.time,
                                  date: widget.date,
                                  resturantDetails: widget.resturantDetails,
                                );
                              }),
                        ),
                      ),
                    ],
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
    required this.time,
    required this.date,
  });
  final ResturantModel resturantDetails;
  final TableModel table;
  final String time;
  final String date;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ReservationDetailsPage(
                  tableModel: table,
                  time: time,
                  date: date,
                  resturantDetails: resturantDetails)),
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
              borderRadius: const BorderRadius.only(
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
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
            // const SizedBox(
            //   height: 16,
            // ),
            Container(
              margin: const EdgeInsets.all(16),
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
                        // "Corner Table",
                        table.descreption,
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

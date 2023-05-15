import 'package:elite/models/order_model.dart';
import 'package:elite/screens/profile_pages/widgtes/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helper_methods.dart';
import '../../core/styles.dart';
import '../../providers/resturant_provider.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
  static const routeName = "/my-orders-page";
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  int? _selectedOrderType = 0;
  List<String> ordersType = ["All", "Indoor", "Outdoor"];

  int _pageNumber = 1;
  final ScrollController _ordersListController = ScrollController();
  final HelperMethods _helperMethods = HelperMethods();
  late Function popUpProgressIndcator;
  List<OrderModel> _ordersList = [];
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

    fetchOrders();

    super.initState();
  }

  Future refreshList() async {
    _pageNumber = 1;
    _selectedOrderType = 0;
    fetchOrders();
  }

  Future fetchOrders() async {
    // popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ResturantProvider>(context, listen: false)
          .getMyOrders(
              context: context,
              pageNumber: _pageNumber,
              orderType: _selectedOrderType!)
          .then((map) {
        // if (_pageNumber == 1) {
        //   _mealsList = informationMap["list"];
        // } else {
        //   _mealsList.addAll(informationMap["list"]);
        // }
        _ordersList = map["list"];
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
          "My orders",
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
                                : const BorderSide(
                                    width: 1, color: Styles.midGrayColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            // padding: EdgeInsets.all(8),
                            label: Container(
                              // width: 50,
                              child: Text(
                                ordersType[index],
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
                              fetchOrders();
                            },
                          ),
                        );
                      },
                    ).toList(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  _ordersList.isEmpty
                      ? Center(
                          child: Text(
                            "No orders",
                            style: Styles.mainTextStyle,
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                            itemBuilder: (context, index) => OrderItem(
                              orderModel: _ordersList[index],
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              height: 8,
                            ),
                            itemCount: _ordersList.length,
                          ),
                        )
                ],
              ),
      ),
    );
  }
}

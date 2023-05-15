import 'package:elite/models/resturant_model.dart';
import 'package:elite/providers/resturant_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helper_methods.dart';
import '../../core/styles.dart';
import '../../models/resturant_menu_item.dart';
import 'widgets/resturant_menu_Item.dart';

class ResturanMenuPage extends StatefulWidget {
  const ResturanMenuPage(
      {super.key,
      required this.resturantDetails,
      required this.isFormAddOrderPage});

  @override
  State<ResturanMenuPage> createState() => _ResturanMenuPageState();
  final ResturantModel? resturantDetails;
  final bool? isFormAddOrderPage;
  static const routeName = "ResturanMenuPage" ;
}

class _ResturanMenuPageState extends State<ResturanMenuPage> {
  int _pageNumber = 1;
  final ScrollController _menuListController = ScrollController();
  final HelperMethods _helperMethods = HelperMethods();
  late Function popUpProgressIndcator;
  bool _isThereNextPage = false;
  List<ResturantMenuItemModel> _menusList = [];

  @override
  void initState() {
    _menuListController.addListener(() {
      if (_menuListController.position.pixels ==
          _menuListController.position.maxScrollExtent) {
        print("from inist satate");

        if (!_isThereNextPage) return;
        fetchMenu();
      }
    });

    fetchMenu();

    super.initState();
  }

  Future refreshList() async {
    _pageNumber = 1;
    fetchMenu();
  }

  Future fetchMenu() async {
    popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();
    try {
      await Provider.of<ResturantProvider>(context, listen: false)
          .getResturantMenu(
              context: context,
              pageNumber: _pageNumber,
              restId: widget.resturantDetails!.id) //3
          .then((informationMap) {
        if (_pageNumber == 1) {
          _menusList = informationMap["list"];
        } else {
          _menusList.addAll(informationMap["list"]);
        }
        setState(() {
          _isThereNextPage = informationMap["isThereNextPage"] ?? false;
          _pageNumber++;
          popUpProgressIndcator.call();
        });
      });
    } catch (e) {
      popUpProgressIndcator.call();
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Styles.grayColor),
        title: Text(
          "Menu",
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: _menusList.isEmpty
            ? Center(
                child: Text(
                  "لا يوجد قائمة",
                  style: Styles.mainTextStyle,
                ),
              )
            : RefreshIndicator(
                onRefresh: refreshList,
                child: ListView.builder(
                    itemCount: _menusList.length,
                    itemBuilder: (context, index) {
                      return ResturantMenuItem(
                        menusItem: _menusList[index],
                        resturantDetails: widget.resturantDetails!,
                        isFormAddOrderPage: widget.isFormAddOrderPage!,
                      );
                    }),
              ),
      ),
    );
  }
}

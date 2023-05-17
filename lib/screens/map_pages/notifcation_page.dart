import 'package:elite/core/styles.dart';
import 'package:elite/models/notification_model.dart';
import 'package:elite/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helper_methods.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
  static const routeName = "/notification - page";
}

class _NotificationPageState extends State<NotificationPage> {
  int _pageNumber = 1;
  final ScrollController _mealsListController = ScrollController();
  final HelperMethods _helperMethods = HelperMethods();
  late Function popUpProgressIndcator;
  bool _isThereNextPage = false;
  List<NotificationModel> _notifiactionList = [];

  @override
  void initState() {
    _mealsListController.addListener(() {
      if (_mealsListController.position.pixels ==
          _mealsListController.position.maxScrollExtent) {
        print("from inist satate");

        if (!_isThereNextPage) return;
        fetchNotification();
      }
    });

    fetchNotification();

    super.initState();
  }

  Future refreshList() async {
    _pageNumber = 1;
    fetchNotification();
  }

  Future fetchNotification() async {
    popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .getUserNotification(
        context: context,
        pageNumber: _pageNumber,
      ) //3
          .then((informationMap) {
        if (_pageNumber == 1) {
          _notifiactionList = informationMap["list"];
        } else {
          _notifiactionList.addAll(informationMap["list"]);
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
      body: Stack(
        children: [
          Positioned(
            top: 1,
            // bottom: 1,
            left: 1,
            right: 1,
            child: Image.asset("assets/images/food_background.png"),
          ),
          Positioned(
              top: 16,
              left: 16,
              child: SafeArea(
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(Icons.arrow_back_ios),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Text(
                      "Notifications",
                      style: Styles.mainTextStyle
                          .copyWith(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              )),
          Positioned(
            top: 56,
            left: 1,
            right: 1,
            bottom: 16,
            child: SafeArea(
              child: Container(
                margin: const EdgeInsets.all(16),
                child: _notifiactionList.isEmpty
                    ? Center(
                        child: Text(
                          "لا يوجد اشعارات",
                          style: Styles.mainTextStyle,
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: refreshList,
                        child: ListView.separated(
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 12,
                                ),
                            itemCount: _notifiactionList.length,
                            itemBuilder: (context, index) {
                              return Container(
                                child: ListTile(
                                  tileColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    side: const BorderSide(color: Colors.grey),
                                  ),
                                  leading: const Icon(
                                    Icons.error,
                                    color: Styles.grayColor,
                                  ),
                                  title: Text(
                                    _notifiactionList[index].notificationTitle,
                                    style: Styles.mainTextStyle.copyWith(
                                      color: Styles.grayColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text(
                                    _notifiactionList[index].notificationBody,
                                    style: Styles.mainTextStyle.copyWith(
                                      color: Styles.grayColor,
                                      fontSize: 15,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

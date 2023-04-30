import 'package:elite/core/styles.dart';
import 'package:elite/models/nutrations_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/helper_methods.dart';
import '../../models/menu_item_meals_list_model.dart';
import '../../providers/resturant_provider.dart';

class MealNatruationsPage extends StatefulWidget {
  const MealNatruationsPage({super.key, required this.meal});

  @override
  State<MealNatruationsPage> createState() => _MealNatruationsPageState();

  final MenuItemMealsListModel meal;
}

class _MealNatruationsPageState extends State<MealNatruationsPage>
    with AutomaticKeepAliveClientMixin {
  final HelperMethods _helperMethods = HelperMethods();
  late Function popUpProgressIndcator;
  List<NutirationModel> _mealNutrationsList = [];
  bool _isLoading = false;

  @override
  void initState() {
    fetchMealNutrations();

    super.initState();
  }

  Future fetchMealNutrations() async {
    // popUpProgressIndcator = _helperMethods.showPopUpProgressIndcator();
    try {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<ResturantProvider>(context, listen: false)
          .getMealNutration(
        context: context,
        menuItemId: widget.meal.mealId,
      )
          .then((list) {
        _mealNutrationsList = list;
        setState(() {
          _isLoading = false;
        });
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
      body: _isLoading
          ? Center(
              child: _helperMethods.progressIndcator(),
            )
          : _mealNutrationsList.isEmpty
              ? Center(
                  child: Text(
                    "لا يوجد قائمة",
                    style: Styles.mainTextStyle,
                  ),
                )
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: _mealNutrationsList.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          //header data
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Calories",
                                  style: Styles.mainTextStyle.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                _mealNutrationsList[index].NutrationTotal,
                                style: Styles.mainTextStyle.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          const Divider(
                            height: 8,
                            thickness: 8,
                            color: Styles.DividerColor,
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          // body
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "Total Fat ${_mealNutrationsList[index].NutrationTotal} g",
                                      style: Styles.mainTextStyle.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                  Text(
                                    "10 %",
                                    style: Styles.mainTextStyle.copyWith(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              const Divider(),
                              // Sub items
                              Wrap(
                                children: _mealNutrationsList[index]
                                    .subItems
                                    .map((subItem) => Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: const EdgeInsets.only(
                                                  left: 20),
                                              child: Text(
                                                  "${subItem.name} ${subItem.amount} g"),
                                            ),
                                            const Divider(),
                                          ],
                                        ))
                                    .toList(),
                              )
                            ],
                          )
                        ],
                      ),
                    );
                  }),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

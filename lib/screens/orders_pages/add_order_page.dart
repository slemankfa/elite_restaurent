import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite/core/helper_methods.dart';
import 'package:elite/models/cart_item_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';
import '../../models/meal_size_model.dart';
import '../../models/resturant_model.dart';
import '../../providers/cart_provider.dart';
import '../main_tabs_page.dart';
import '../resturant_pages/resturant_menu_page.dart';

class AddOrderPage extends StatefulWidget {
  const AddOrderPage({super.key, required this.resturantDetails});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
  final ResturantModel resturantDetails;
}

class _AddOrderPageState extends State<AddOrderPage> {
  List<MealSizeModel> list = [];
  final HelperMethods _helperMethods = HelperMethods();
  @override
  void initState() {
    // TODO: implement initState
    list.add(MealSizeModel(id: "1", name: "S", price: 2));
    list.add(MealSizeModel(id: "2", name: "M", price: 4));
    list.add(MealSizeModel(id: "3", name: "L", price: 6));
    // list.add(MealSizeModel(id: "3", name: "L", price: 6));
    // list.add(MealSizeModel(id: "3", name: "L", price: 6));
    // list.add(MealSizeModel(id: "3", name: "L", price: 6));
    // list.add(MealSizeModel(id: "3", name: "L", price: 6));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Styles.grayColor),
        title: Text(
          "Place Order",
          style: Styles.appBarTextStyle,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        // alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // meals body
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Styles.listTileBorderColr)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Table #2",
                      style: Styles.mainTextStyle
                          .copyWith(fontSize: 14, color: Styles.midGrayColor),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Wrap(
                      children: cart.items.values
                          .map((cartItem) => MealOrderItem(
                                cartItem: cartItem,
                              ))
                          .toList(),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResturanMenuPage(
                                    resturantDetails: widget.resturantDetails,
                                    isFormAddOrderPage: true,
                                  )),
                        );
                      },
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              "Add Dish".toUpperCase(),
                              style: Styles.mainTextStyle.copyWith(
                                  fontSize: 14,
                                  overflow: TextOverflow.ellipsis,
                                  color: Styles.mainColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const Icon(
                            Icons.add,
                            color: Styles.mainColor,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              // extras body
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Styles.listTileBorderColr)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Extras",
                      style: Styles.mainTextStyle
                          .copyWith(fontSize: 14, color: Styles.midGrayColor),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    cart.items.values.isNotEmpty
                        ? Wrap(
                            children: cart.items.values
                                .map((cartMealItem) => Column(
                                      children: [
                                        Wrap(
                                          children: cartMealItem.sideDishes
                                              .map((sideDish) => Transform(
                                                    transform: Matrix4
                                                        .translationValues(
                                                            -15, 0, 0),
                                                    child: ListTile(
                                                      // contentPadding: EdgeInsets.zero,
                                                      trailing: InkWell(
                                                        onTap: () {
                                                          _helperMethods
                                                              .showAlertDilog(
                                                                  message:
                                                                      "Are you sure to remove ${sideDish.name} ?",
                                                                  context:
                                                                      context,
                                                                  function: () {
                                                                    cart.removeSideDish(
                                                                        mealId: cart
                                                                            .items
                                                                            .values
                                                                            .first
                                                                            .mealId,
                                                                        sideDishId:
                                                                            sideDish.id);
                                                                  });
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
                                                          decoration: BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              color: Styles
                                                                  .deleteBackGroundColor),
                                                          child: const Icon(
                                                            Icons.delete,
                                                            color: Styles
                                                                .cancelREdColor,
                                                          ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        sideDish.name,
                                                        style: Styles
                                                            .mainTextStyle
                                                            .copyWith(
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Styles
                                                                    .grayColor),
                                                      ),
                                                      subtitle: RichText(
                                                        // textAlign: TextAlign.end,
                                                        text: TextSpan(
                                                          text:
                                                              '${sideDish.price}',
                                                          style: Styles
                                                              .mainTextStyle
                                                              .copyWith(
                                                                  color: Styles
                                                                      .mainColor,
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: ' JOD',
                                                                style: Styles.mainTextStyle.copyWith(
                                                                    color: Styles
                                                                        .midGrayColor,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ))
                                              .toList(),
                                        ),
                                        const Divider(),
                                      ],
                                    ))
                                .toList(),
                          )
                        : Container(),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Styles.listTileBorderColr)),
                child: Row(
                  children: [
                    Expanded(
                        child: Text("Total",
                            textAlign: TextAlign.start,
                            style: Styles.mainTextStyle.copyWith(
                                color: Styles.resturentNameColor,
                                fontSize: 16,
                                fontWeight: FontWeight.w600))),
                    Expanded(
                      child: RichText(
                        textAlign: TextAlign.end,
                        text: TextSpan(
                          text: '${cart.totalAmount} ',
                          style: Styles.mainTextStyle.copyWith(
                              color: Styles.mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          children: <TextSpan>[
                            TextSpan(
                                text: ' JOD',
                                style: Styles.mainTextStyle.copyWith(
                                    color: Styles.midGrayColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(
                height: 20,
              ),

              CustomOutlinedButton(
                  label: "Confirm Order",
                  // borderSide: BorderSide(),
                  rectangleBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  icon: Container(),
                  isIconVisible: false,
                  onPressedButton: () {
                    Navigator.pushAndRemoveUntil<dynamic>(
                      context,
                      MaterialPageRoute<dynamic>(
                        builder: (BuildContext context) => const MainTabsPage(),
                      ),
                      (route) =>
                          false, //if you want to disable back feature set to false
                    );
                  },
                  backGroundColor: Styles.mainColor,
                  // backGroundColor: Styles.mainColor,
                  textStyle: Styles.mainTextStyle.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              CustomOutlinedButton(
                  label: "Cancel",
                  // borderSide: BorderSide(),
                  rectangleBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  icon: Container(),
                  isIconVisible: false,
                  onPressedButton: () {},
                  backGroundColor: Styles.supportChatBBlMessageColor,
                  // backGroundColor: Styles.mainColor,
                  textStyle: Styles.mainTextStyle.copyWith(
                      color: Styles.resturentNameColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MealOrderItem extends StatelessWidget {
  MealOrderItem({
    super.key,
    required this.cartItem,
  });

  final CartItemModel cartItem;

  final HelperMethods _helperMethods = HelperMethods();

  @override
  Widget build(BuildContext context) {
    return Consumer<CartProvider>(
      builder: (ctx, cart, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Transform(
            transform: Matrix4.translationValues(-15, 0, 0),
            child: ListTile(
              trailing: cart.items.keys.first == cartItem.mealId
                  ? null
                  : InkWell(
                      onTap: () {
                        _helperMethods.showAlertDilog(
                            message:
                                "Are you sure to remove ${cartItem.mealName} ?",
                            context: context,
                            function: () {
                              cart.removeItem(cartItem.mealId);
                            });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Styles.deleteBackGroundColor),
                        child: const Icon(
                          Icons.delete,
                          color: Styles.cancelREdColor,
                        ),
                      ),
                    ),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: cartItem.mealImage,
                  height: 64,
                  width: 64,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const FlutterLogo(
                    size: 64,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              title: Text(
                cartItem.mealName,
                style: Styles.mainTextStyle.copyWith(
                    color: Styles.grayColor,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              subtitle: RichText(
                text: TextSpan(
                  text: '${cart.items[cartItem.mealId]!.price} ',
                  style: Styles.mainTextStyle.copyWith(
                      color: Styles.mainColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                        text: ' JOD',
                        style: Styles.mainTextStyle.copyWith(
                            color: Styles.midGrayColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Text("Size",
                      textAlign: TextAlign.start,
                      style: Styles.mainTextStyle.copyWith(
                          color: Styles.resturentNameColor,
                          fontSize: 16,
                          fontWeight: FontWeight.normal))),
              Expanded(
                  flex: 2,
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Wrap(
                        spacing: 5,
                        children: cartItem.mealSizeList
                            .map((item) => InkWell(
                                  onTap: () {
                                    cart.updateItemSize(
                                        mealId: cartItem.mealId,
                                        currentMealSize: item);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: item.id ==
                                              cart.items[cartItem.mealId]!
                                                  .mealSize.id
                                          ? 57
                                          : 44,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: item.id ==
                                                  cart.items[cartItem.mealId]!
                                                      .mealSize.id
                                              ? Styles
                                                  .selectedSizeOrderBackgrounColor
                                              : Styles.chipBackGroundColor,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color:
                                                  Styles.listTileBorderColr)),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            item.name[0],
                                            style: item.id !=
                                                    cart.items[cartItem.mealId]!
                                                        .mealSize.id
                                                ? Styles.mainTextStyle.copyWith(
                                                    color: Styles
                                                        .timeBackGroundColor,
                                                  )
                                                : Styles.mainTextStyle.copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Visibility(
                                            visible: item.id ==
                                                cart.items[cartItem.mealId]!
                                                    .mealSize.id,
                                            child: const Flexible(
                                              child: Icon(
                                                Icons.check,
                                                size: 12,
                                                color:
                                                    Styles.checkOrderSizeColor,
                                              ),
                                            ),
                                          )
                                        ],
                                      )),
                                ))
                            .toList(),
                      ),
                    ),
                  ))
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              // shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4),
              color: Styles.RatingRivewBoxBorderColor,
              // border: Border.all(color: Styles.mainColor),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    cart.addItem(
                        mealId: cartItem.mealId,
                        mealImage: cartItem.mealImage,
                        size: cartItem.mealSize,
                        price: cartItem.price,
                        title: cartItem.mealName,
                        sideDishes: cartItem.sideDishes,
                        mealSizeList: cartItem.mealSizeList);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    // padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        // shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                        color: Styles.RatingRivewBoxBorderColor,
                        border: Border.all(color: Styles.mainColor)),
                    child: const Icon(
                      Icons.add,
                      color: Styles.mainColor,
                    ),
                  ),
                ),
                Text(
                  "${cartItem.quantity}",
                  style: Styles.mainTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Styles.resturentNameColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (cartItem.quantity == 1) return;
                    cart.removeSingleItem(cartItem.mealId);
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    // padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        // shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                        color: Styles.RatingRivewBoxBorderColor,
                        border: Border.all(color: Styles.mainColor)),
                    child: const Icon(
                      Icons.remove,
                      color: Styles.mainColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Divider(),
        ],
      ),
    );
  }
}

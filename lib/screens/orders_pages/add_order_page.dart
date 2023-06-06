import 'package:bot_toast/bot_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:elite/core/helper_methods.dart';
import 'package:elite/core/valdtion_helper.dart';
import 'package:elite/models/cart_item_model.dart';
import 'package:elite/models/user_model.dart';
import 'package:elite/providers/auth_provider.dart';
import 'package:elite/screens/profile_pages/my_orders_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/styles.dart';
import '../../core/widgets/custom_outline_button.dart';
import '../../models/meal_size_model.dart';
import '../../models/order_address_model.dart';
import '../../models/resturant_model.dart';
import '../../providers/cart_provider.dart';
import '../main_tabs_page.dart';
import '../profile_pages/widgtes/profile_custom_form_field.dart';
import '../resturant_pages/resturant_menu_page.dart';

class AddOrderNavgiator extends StatefulWidget {
  const AddOrderNavgiator({super.key, required this.resturantDetails});

  @override
  State<AddOrderNavgiator> createState() => _AddOrderNavgiatorState();
  final ResturantModel resturantDetails;
}

class _AddOrderNavgiatorState extends State<AddOrderNavgiator> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: _navigatorKey,
        initialRoute: AddOrderPage.routeName,
        onGenerateRoute: _onGenerateRoute);
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case AddOrderPage.routeName:
        page = AddOrderPage(
          resturantDetails: widget.resturantDetails,
        );
        break;
      case ResturanMenuPage.routeName:
        page = ResturanMenuPage(
          resturantDetails: widget.resturantDetails,
          isFormAddOrderPage: true,
        );
        break;
    }

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }
}

class AddOrderPage extends StatefulWidget {
  // static _AddOrderPageState of(BuildContext context) {
  //   return context.findAncestorStateOfType<_AddOrderPageState>()!;
  // }

  const AddOrderPage({super.key, required this.resturantDetails});

  @override
  State<AddOrderPage> createState() => _AddOrderPageState();
  final ResturantModel? resturantDetails;

  static const routeName = "/add-order";
}

class _AddOrderPageState extends State<AddOrderPage> {
  List<MealSizeModel> list = [];
  final HelperMethods _helperMethods = HelperMethods();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    checkUserStatus();
    super.initState();
  }

  OrderAddressModel? orderAddress;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _optaionalAddressController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final ValidationHelper _validationHelper = ValidationHelper();

  final TextEditingController _orderNoteController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _nameController.dispose();
    _addressController.dispose();
    _optaionalAddressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _orderNoteController.dispose();
  }

  checkUserStatus() async {
    bool isUserGuest = await _helperMethods.checkIsGuest() ?? false;
    final cart = Provider.of<CartProvider>(context, listen: false);

    if (cart.OrderAddressInformation != null) {
      _nameController.text = cart.OrderAddressInformation!.username;
      _emailController.text = cart.OrderAddressInformation!.email;
      _phoneController.text = cart.OrderAddressInformation!.phone;
      _addressController.text = cart.OrderAddressInformation!.address;
      _optaionalAddressController.text =
          cart.OrderAddressInformation!.optaionalAddress!;
    } else {
      if (!isUserGuest) {
        UserModel? userModel =
            Provider.of<AuthProvider>(context, listen: false).userInformation;

        if (userModel == null) return;

        _nameController.text = "${userModel.firstName}  ${userModel.lastName}";
        _emailController.text = userModel.email;
        _phoneController.text = userModel.userPhone;
      }
    }
  }

  addNewOrder(isIndoor) async {
    if (!isIndoor) {
      if (!_formKey.currentState!.validate()) {
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.
        return;
      }
    }

    Function showPopUpLoading = _helperMethods.showPopUpProgressIndcator();
    try {
      OrderAddressModel orderAddressModel = OrderAddressModel(
          username: _nameController.text,
          address: _addressController.text,
          email: _emailController.text,
          optaionalAddress: _optaionalAddressController.text,
          phone: _phoneController.text);

      Provider.of<CartProvider>(context, listen: false)
          .CreateNewOrderOrder(
              addressinformation: orderAddressModel,
              orderNote: _orderNoteController.text,
              resturantDetails: widget.resturantDetails!)
          .then((status) {
        showPopUpLoading.call();
        if (status) {
          showConfirmDilog(context: context);
        } else {
          BotToast.showText(text: "can't create this order!");
        }
      });
    } catch (e) {
      showPopUpLoading.call();
    }

    // Navigator.push(context, route)
    // Navigator.pushAndRemoveUntil<dynamic>(
    //   context,
    //   MaterialPageRoute<dynamic>(
    //     builder: (BuildContext context) => const MainTabsPage(),
    //   ),
    //   (route) => false, //if you want to disable back feature set to false
    // );
  }

  showConfirmDilog({required BuildContext context}) {
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
                title: Center(
                  child: Text(
                    "Confirmed",
                    style: Styles.mainTextStyle.copyWith(
                        color: Styles.grayColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
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
                          "your order on the way, to track your order go to orders into your profile.",
                          style: Styles.mainTextStyle
                              .copyWith(color: Styles.grayColor, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      // margin: EdgeInsets.symmetric(horizontal: 50),
                      width: 150,
                      child: CustomOutlinedButton(
                          label: "View Order",
                          isIconVisible: false,
                          onPressedButton: () async {
                            /* 
                            after cheking the order we will go to the main page */
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyOrdersPage(),
                                // settings: const RouteSettings(
                                //     name: ProfilePage.routeName),
                              ),
                            );

                            Navigator.pushAndRemoveUntil<dynamic>(
                              context,
                              MaterialPageRoute<dynamic>(
                                builder: (BuildContext context) =>
                                    const MainTabsPage(),
                              ),
                              (route) =>
                                  false, //if you want to disable back feature set to false
                            );
                          },
                          rectangleBorder: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          icon: Container(),
                          borderSide: const BorderSide(color: Styles.mainColor),
                          textStyle: Styles.mainTextStyle.copyWith(
                              color: Styles.mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ));
  }

/////
  ///
  ///
  ///

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
                    if (cart.isInsideResturant)
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
                        OrderAddressModel orderAddressModel = OrderAddressModel(
                            username: _nameController.text,
                            address: _addressController.text,
                            email: _emailController.text,
                            optaionalAddress: _optaionalAddressController.text,
                            phone: _phoneController.text);

                        cart.updateOrderAddressInformation(orderAddressModel);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResturanMenuPage(
                                    resturantDetails: widget.resturantDetails,
                                    isFormAddOrderPage: true,
                                  )),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Styles.mainColor,
                        ),
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
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Icon(
                              Icons.add,
                              color: Colors.white,
                            )
                          ],
                        ),
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
                                                                        mealId: cartMealItem
                                                                            .mealLocalId,
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
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Styles.listTileBorderColr)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order notes",
                      style: Styles.mainTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Styles.grayColor),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    ProfileCustomFormField(
                        controller: _orderNoteController,
                        formatter: const [],
                        action: TextInputAction.done,
                        hintText: "Add more souce...",
                        maxline: 5,
                        // maxLength: ,
                        isPrefixeIconAvalibel: false,
                        textStyle: Styles.mainTextStyle
                            .copyWith(fontSize: 16, color: Styles.mainColor),
                        hintStyle: Styles.mainTextStyle
                            .copyWith(fontSize: 14, color: Styles.grayColor),
                        vladationFunction: _validationHelper.validateField,
                        textInputType: TextInputType.emailAddress,
                        isSuffixIconAvalibel: false,
                        suffixWidget: null,
                        readOnly: false,
                        onTapFuncation: () async {},
                        textAlign: TextAlign.start,
                        label: "",
                        labelTextStyle: Styles.mainTextStyle.copyWith(
                            color: Styles.unslectedItemColor, fontSize: 16),
                        formFillColor: Colors.white),
                  ],
                ),
              ),
              if (!cart.isInsideResturant) const Divider(),
              // address
              if (!cart.isInsideResturant)
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Styles.listTileBorderColr)),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Shipping Address",
                          style: Styles.mainTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Styles.grayColor),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        ProfileCustomFormField(
                            controller: _nameController,
                            formatter: const [],
                            action: TextInputAction.done,
                            hintText: "Name",
                            isPrefixeIconAvalibel: false,
                            textStyle: Styles.mainTextStyle.copyWith(
                                fontSize: 16, color: Styles.mainColor),
                            hintStyle: Styles.mainTextStyle.copyWith(
                                fontSize: 16, color: Styles.grayColor),
                            vladationFunction: _validationHelper.validateField,
                            textInputType: TextInputType.emailAddress,
                            isSuffixIconAvalibel: false,
                            suffixWidget: null,
                            readOnly: false,
                            onTapFuncation: () async {},
                            textAlign: TextAlign.start,
                            label: "",
                            labelTextStyle: Styles.mainTextStyle.copyWith(
                                color: Styles.unslectedItemColor, fontSize: 16),
                            formFillColor: Colors.white),
                        const SizedBox(
                          height: 12,
                        ),
                        ProfileCustomFormField(
                            controller: _addressController,
                            formatter: const [],
                            action: TextInputAction.done,
                            hintText: "Address",
                            isPrefixeIconAvalibel: false,
                            textStyle: Styles.mainTextStyle.copyWith(
                                fontSize: 16, color: Styles.mainColor),
                            hintStyle: Styles.mainTextStyle.copyWith(
                                fontSize: 16, color: Styles.grayColor),
                            vladationFunction: _validationHelper.validateField,
                            textInputType: TextInputType.emailAddress,
                            isSuffixIconAvalibel: false,
                            suffixWidget: null,
                            readOnly: false,
                            onTapFuncation: () async {},
                            textAlign: TextAlign.start,
                            label: "",
                            labelTextStyle: Styles.mainTextStyle.copyWith(
                                color: Styles.unslectedItemColor, fontSize: 16),
                            formFillColor: Colors.white),
                        const SizedBox(
                          height: 12,
                        ),
                        ProfileCustomFormField(
                            controller: _optaionalAddressController,
                            formatter: const [],
                            action: TextInputAction.done,
                            hintText: "Address line 2 (optional)",
                            isPrefixeIconAvalibel: false,
                            textStyle: Styles.mainTextStyle.copyWith(
                                fontSize: 16, color: Styles.mainColor),
                            hintStyle: Styles.mainTextStyle.copyWith(
                                fontSize: 16, color: Styles.grayColor),
                            vladationFunction:
                                _validationHelper.optionalEmailValdation,
                            textInputType: TextInputType.emailAddress,
                            isSuffixIconAvalibel: false,
                            suffixWidget: null,
                            readOnly: false,
                            onTapFuncation: () async {},
                            textAlign: TextAlign.start,
                            label: "",
                            labelTextStyle: Styles.mainTextStyle.copyWith(
                                color: Styles.unslectedItemColor, fontSize: 16),
                            formFillColor: Colors.white),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          "Contact Information",
                          style: Styles.mainTextStyle.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Styles.grayColor),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        ProfileCustomFormField(
                            controller: _emailController,
                            formatter: const [],
                            action: TextInputAction.done,
                            hintText: "email",
                            isPrefixeIconAvalibel: true,
                            textStyle: Styles.mainTextStyle.copyWith(
                                fontSize: 16, color: Styles.mainColor),
                            hintStyle: Styles.mainTextStyle.copyWith(
                                fontSize: 16, color: Styles.grayColor),
                            vladationFunction:
                                _validationHelper.optionalEmailValdation,
                            textInputType: TextInputType.emailAddress,
                            isSuffixIconAvalibel: false,
                            prefixWidget: const Icon(Icons.email_outlined),
                            suffixWidget: null,
                            readOnly: false,
                            onTapFuncation: () async {},
                            textAlign: TextAlign.start,
                            label: "",
                            labelTextStyle: Styles.mainTextStyle.copyWith(
                                color: Styles.unslectedItemColor, fontSize: 16),
                            formFillColor: Colors.white),
                        const SizedBox(
                          height: 12,
                        ),
                        ProfileCustomFormField(
                            controller: _phoneController,
                            formatter: const [],
                            action: TextInputAction.done,
                            hintText: "phone number",
                            isPrefixeIconAvalibel: true,
                            textStyle: Styles.mainTextStyle.copyWith(
                                fontSize: 16, color: Styles.mainColor),
                            hintStyle: Styles.mainTextStyle.copyWith(
                                fontSize: 16, color: Styles.grayColor),
                            vladationFunction: _validationHelper.validateField,
                            textInputType: TextInputType.emailAddress,
                            isSuffixIconAvalibel: false,
                            prefixWidget: const Icon(Icons.phone),
                            suffixWidget: null,
                            readOnly: false,
                            onTapFuncation: () async {},
                            textAlign: TextAlign.start,
                            label: "",
                            labelTextStyle: Styles.mainTextStyle.copyWith(
                                color: Styles.unslectedItemColor, fontSize: 16),
                            formFillColor: Colors.white),
                      ],
                    ),
                  ),
                ),
              const SizedBox(
                height: 20,
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
                    addNewOrder(cart.isInsideResturant);
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
              trailing: cart.items.keys.first == cartItem.mealLocalId
                  ? null
                  : InkWell(
                      onTap: () {
                        _helperMethods.showAlertDilog(
                            message:
                                "Are you sure to remove ${cartItem.mealName} ?",
                            context: context,
                            function: () {
                              cart.removeItem(cartItem.mealLocalId);
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
                  text: '${cart.items[cartItem.mealLocalId]!.price} ',
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
                                        localMealId: cartItem.mealLocalId,
                                        currentMealSize: item);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      width: item.id ==
                                              cart.items[cartItem.mealLocalId]!
                                                  .mealSize.id
                                          ? 57
                                          : 44,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: item.id ==
                                                  cart
                                                      .items[
                                                          cartItem.mealLocalId]!
                                                      .mealSize
                                                      .id
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
                                                    cart
                                                        .items[cartItem
                                                            .mealLocalId]!
                                                        .mealSize
                                                        .id
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
                                                cart
                                                    .items[
                                                        cartItem.mealLocalId]!
                                                    .mealSize
                                                    .id,
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
                        mealLocalId: cartItem.mealLocalId,
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
                    cart.removeSingleItem(cartItem.mealLocalId);
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

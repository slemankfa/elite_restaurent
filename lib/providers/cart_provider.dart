import 'package:dio/dio.dart';
import 'package:elite/core/helper_methods.dart';
import 'package:elite/models/cart_item_model.dart';
import 'package:elite/models/order_address_model.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import '../models/meal_size_model.dart';
import '../models/resturant_model.dart';
import '../models/side_dishes.dart';
import '../models/user_model.dart';

class CartProvider with ChangeNotifier {
  final Dio _dio = Dio();
  final HelperMethods _helperMethods = HelperMethods();
  final Map<String, CartItemModel> _items = {};

  String _isIndoor = "1";

// order from inside resturn or outside resturan
/* 
Indoor 1
Outdoor 2 */
  updateIsIndoorStatus(String status) {
    _isIndoor = status;
    notifyListeners();
  }

  OrderAddressModel? _orderAddressModel;

  OrderAddressModel? get OrderAddressInformation {
    return _orderAddressModel;
  }

  updateOrderAddressInformation(OrderAddressModel orderAddressModel) {
    _orderAddressModel = orderAddressModel;
    notifyListeners();
  }

  Map<String, CartItemModel> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.quantity * cartItem.price;
      for (var element in cartItem.sideDishes) {
        total += element.price;
      }
    });

    return total;
  }

  void updateItemSize({
    required String mealId,
    required MealSizeModel currentMealSize,
  }) {
    if (_items.containsKey(mealId)) {
      _items.update(
          mealId,
          (existingCartItem) => CartItemModel(
              mealId: mealId,
              sideDishes: existingCartItem.sideDishes,
              mealName: existingCartItem.mealName,
              mealImage: existingCartItem.mealImage,
              quantity: existingCartItem.quantity,
              price: currentMealSize.price,
              maxQuntity: existingCartItem.maxQuntity,
              mealSize: currentMealSize,
              mealSizeList: existingCartItem.mealSizeList));
      notifyListeners();
      print("update meal Size");
    }
  }

  void addItem(
      {required String mealId,
      required String mealImage,
      required MealSizeModel size,
      required double price,
      required String title,
      required List<SideMealDishes> sideDishes,
      required List<MealSizeModel> mealSizeList}) {
    if (_items.containsKey(mealId)) {
      _items.update(
          mealId,
          (existingCartItem) => CartItemModel(
              mealId: mealId,
              mealName: title,
              mealImage: existingCartItem.mealImage,
              quantity: existingCartItem.quantity + 1,
              price: price,
              maxQuntity: 1,
              mealSize: size,
              sideDishes: existingCartItem.sideDishes,
              mealSizeList: existingCartItem.mealSizeList));
    } else {
      _items.putIfAbsent(
          mealId,
          () => CartItemModel(
                mealId: mealId,
                mealName: title,
                quantity: 1,
                sideDishes: sideDishes,
                mealImage: mealImage,
                price: price,
                maxQuntity: 1,
                mealSizeList: mealSizeList,
                mealSize: size,
              ));
    }
    notifyListeners();
    print("addItemMethod");
  }

  void removeItem(String mealId) {
    _items.remove(mealId);
    notifyListeners();
  }

  int getItemQuntity(String mealId) {
    if (!_items.containsKey(mealId)) {
      return 0;
    }
    return _items[mealId]!.quantity;
  }

  removeSideDish({required String mealId, required String sideDishId}) {
    if (!_items.containsKey(mealId)) {
      return;
    }
    for (var i = 0; i < _items[mealId]!.sideDishes.length; i++) {
      if (_items[mealId]!.sideDishes[i].id == sideDishId) {
        _items[mealId]!.sideDishes.removeAt(i);
      }
    }

    notifyListeners();
    print(" removee side dish");
  }

  removeSingleItem(String mealId) {
    if (!_items.containsKey(mealId)) {
      return;
    }
    if (_items[mealId]!.quantity > 1) {
      _items.update(
          mealId,
          (existingCartItem) => CartItemModel(
              mealId: existingCartItem.mealId,
              mealName: existingCartItem.mealName,
              mealImage: existingCartItem.mealImage,
              quantity: existingCartItem.quantity - 1,
              price: existingCartItem.price,
              maxQuntity: 1,
              sideDishes: existingCartItem.sideDishes,
              mealSizeList: existingCartItem.mealSizeList,
              mealSize: existingCartItem.mealSize));
    } else {
      _items.remove(mealId);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
    print("clear cart");
  }

  Future<bool> CreateNewOrderOrder(
      {required OrderAddressModel addressinformation,
      required ResturantModel resturantDetails}) async {
    List<Map<String, dynamic>> mealsDetails = [];
    try {
      _items.forEach((key, cartItem) {
        mealsDetails.add({
          "itemID": cartItem.mealId,
          "qty": cartItem.quantity,
          "price": cartItem.price,
          "sizeID": cartItem.mealSize.id,
          "note": "",
          "ExtrasItemID": cartItem.sideDishes.first.id,
          "ExtrasPrice": cartItem.sideDishes.first.price,
          "ExtrasQty": 1,
        });
      });

      // print(mealsDetails.toString());
      final token = await _helperMethods.getToken();
      final UserModel? tempUser = await _helperMethods.getUser();
      if (tempUser == null) {
        return false;
      }
      Response response = await _dio.post("${API_URL}Order",
          options: Options(
            headers: {
              "Accept": "application/json",
              "content-type": "application/json",
              // "Authorization": token
            },
          ),
          data: {
            "resturantID": resturantDetails.id,
            "userID": tempUser.userId,
            "requestDate": "2023-05-30",
            "reservationID": 0,
            "tableID": 0,
            "note": "",
            "orderTotal": totalAmount,
            "discount": 0,
            "taxAmount": 0,
            "additionalAmount": 0,
            "statusID": 0,
            "isPayment": true,
            "GuestName": addressinformation.username,
            "Email": addressinformation.email,
            "PhoneNo": addressinformation.phone,
            "Address": addressinformation.address,
            "IsIndoor": _isIndoor,
            "details": mealsDetails
          });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}

import 'package:elite/models/cart_item_model.dart';
import 'package:flutter/material.dart';

import '../models/meal_size_model.dart';

class CartProvider with ChangeNotifier {
  final Map<String, CartItemModel> _items = {};

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
              mealSizeList: existingCartItem.mealSizeList));
    } else {
      _items.putIfAbsent(
          mealId,
          () => CartItemModel(
                mealId: mealId,
                mealName: title,
                quantity: 1,
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
  }
}

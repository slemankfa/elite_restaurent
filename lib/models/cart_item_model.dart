import 'meal_size_model.dart';

class CartItemModel {
  final String mealId;
  final String mealName;
  final String mealImage;
  final int quantity;
  final double price;
  final int maxQuntity;
  final MealSizeModel mealSize;
  final List<MealSizeModel> mealSizeList;

  CartItemModel(
      {required this.mealId,
      required this.mealName,
      required this.quantity,
      required this.price,
      required this.mealImage,
      required this.maxQuntity,
      required this.mealSizeList,
      required this.mealSize});
}

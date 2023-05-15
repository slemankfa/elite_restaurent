class SideMealDishes {
  final String id;
  final String name;
  final double price;

  SideMealDishes({
    required this.id,
    required this.name,
    required this.price,
  });

  factory SideMealDishes.fromJson(Map<String, dynamic> map) {
    return SideMealDishes(
      id: map["itemID"].toString(),
      name: map["itemNameA"],
      price: map["price"]??0,
    );
  }
}

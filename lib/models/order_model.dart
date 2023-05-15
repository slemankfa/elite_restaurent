class OrderModel {
  final String orderId;
  final String requestDare;
  bool? isCnacel;

  OrderModel({
    required this.orderId,
    required this.requestDare,
    this.isCnacel,
  });

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    return OrderModel(
        orderId: map["orderID"].toString(),
        requestDare: map["requestDate"],
        isCnacel: map["isCancel"] ?? false);
  }
}

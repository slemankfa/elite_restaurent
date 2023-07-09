class OrderModel {
  final String orderId;
  final String requestDare;
  bool? isCnacel;
  int? tabelId;

  OrderModel({
    required this.orderId,
    required this.requestDare,
    required this.tabelId,
    this.isCnacel,
  });

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    return OrderModel(
        orderId: map["orderID"].toString(),
        requestDare: map["requestDate"],
        tabelId: map["tableID"],
        isCnacel: map["isCancel"] ?? false);
  }
}

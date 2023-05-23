class CusineModel {
  final int id;
  final String name;

  CusineModel({
    required this.id,
    required this.name,
  });

  factory CusineModel.fromJson(Map<String, dynamic> map) {
    return CusineModel(id: map["typesID"], name: map['nameE']);
  }
}

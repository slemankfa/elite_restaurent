
import '../core/constants.dart';

class TableModel {
  final String name;
  final String id;
  final String qrCode;
  final int noOfSeats;
  final String tableImage;
  final String descreption;

  TableModel({
    required this.name,
    required this.id,
    required this.qrCode,
    required this.noOfSeats,
    required this.descreption,
    required this.tableImage,
  });

  factory TableModel.fromJson(Map<String, dynamic> map) {
    return TableModel(
        name: map["tableName"],
        id: map["tableID"].toString(),
        qrCode: map["qrCode"],
        descreption: map["descreption"],
        noOfSeats: map["noOfSeat"],
        tableImage: "$IMAGE_PATH_URL${map["tableImage"]}");
  }
}

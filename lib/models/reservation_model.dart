class ReservationModel {
  final int status;
  final String reservationDate;
  final String reservationId;
  final String? tableNumber;
  final int? peopleCount;
  final String? reservationFromTime;
  final String? reservationToTime;
  final String? reservationNote;
  final int? reservationAmountPaid;
  String? reservationRemaningTime;

  ReservationModel({
    required this.status,
    required this.reservationDate,
    required this.reservationId,
    required this.tableNumber,
    required this.peopleCount,
    required this.reservationFromTime,
    required this.reservationToTime,
    required this.reservationNote,
    required this.reservationAmountPaid,
    required this.reservationRemaningTime,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> map) {
    return ReservationModel(
        status: map["stauts"],
        reservationId: map["reservationID"].toString(),
        reservationDate: map["reservationDate"],
        tableNumber: map["tableID"].toString(),
        peopleCount: map["noOfSeat"],
        reservationFromTime: map["reservationTime"],
        reservationToTime: map["toTime"],
        reservationNote: map["anySpecialNote"],
        reservationAmountPaid: map["amountPaid"],
        reservationRemaningTime: map["remainingTime"]);
  }
}

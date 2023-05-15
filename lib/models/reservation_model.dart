class ReservationModel {
  final int status;
  final String reservationDate;
  final String reservationId;

  ReservationModel({
    required this.status,
    required this.reservationDate,
    required this.reservationId,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> map) {
    return ReservationModel(
      status: map["stauts"],
      reservationId: map["reservationID"].toString(),
      reservationDate: map["reservationDate"],
    );
  }
}

class ReservationModel {
  final int status;
  final String reservationDate;

  ReservationModel({
    required this.status,
    required this.reservationDate,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> map) {
    return ReservationModel(
      status: map["stauts"],
      reservationDate: map["reservationDate"],
    );
  }
}

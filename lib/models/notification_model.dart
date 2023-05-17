class NotificationModel {
  final int notificationId;
  final String notificationTitle;
  final String notificationBody;

  NotificationModel({
    required this.notificationId,
    required this.notificationTitle,
    required this.notificationBody,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> map) {
    return NotificationModel(
        notificationId: map["notificatioN_ID"],
        notificationTitle: map["notificatioN_TITLE"],
        notificationBody: map["notificatioN_BODY"]);
  }
}

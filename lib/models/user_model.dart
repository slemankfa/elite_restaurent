import '../core/constants.dart';

class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String? password;
  final String age;
  final String cityId;
  final String areaId;
  final String? userImage;
  final String userGender;
  final String userId;
  final String userPhone;
  final int? myOrdersCount;
  final int? myReservationCount;
  final int? loginType;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.age,
    required this.cityId,
    required this.userGender,
    required this.areaId,
    required this.userId,
    required this.userPhone,
    required this.loginType,
    this.userImage,
    this.myOrdersCount,
    this.myReservationCount,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
        firstName: map["firstName"],
        lastName: map["lastName"] ?? "",
        email: map["email"],
        password: "",
        age: map["age"],
        userPhone: map["phoneNo"],
        cityId: map["cityID"].toString(),
        userGender: map["sexID"].toString(),
        areaId: map["areaID"].toString(),
        loginType: map["signUp"],
        userImage: "$IMAGE_PATH_URL${map["userImage"]}",
        userId: map["userID"].toString());
  }
// Google = 1 ,platform=0

  factory UserModel.fromGetUserIdJson(Map<String, dynamic> map) {
    return UserModel(
        firstName: map["user"]["firstName"],
        lastName: map["user"]["lastName"] ?? "",
        email: map["user"]["email"],
        password: "",
        loginType: map["user"]["signUp"],
        age: map["user"]["age"],
        userPhone: map["user"]["phoneNo"],
        cityId: map["user"]["cityID"].toString(),
        userGender: map["user"]["sexID"].toString(),
        myOrdersCount: map["myOrders"] ?? 0,
        myReservationCount: map["myReservations"] ?? 0,
        areaId: map["user"]["areaID"].toString(),
        userImage: map["user"]["userImage"] == null
            ? null
            : "$IMAGE_PATH_URL${map["user"]["userImage"]}",
        userId: map["user"]["userID"].toString());
  }

  factory UserModel.fromSavedJson(Map<String, dynamic> map) {
    return UserModel(
        firstName: map["firstName"],
        lastName: map["lastName"],
        email: map["email"],
        password: "",
        userPhone: map["phoneNo"],
        age: map["age"],
        loginType: map["signUp"],
        cityId: map["cityID"],
        userGender: map["sexID"],
        areaId: map["areaID"],
        userImage: map["userImage"],
        userId: map["userID"].toString());
  }

  Map<String, dynamic> toJson() => {
        "firstName": firstName,
        "lastName": firstName,
        "email": email,
        "age": age,
        "cityID": cityId,
        "sexID": userGender,
        "areaID": areaId,
        "signUp": loginType,
        "userImage": userImage,
        "userID": userId,
        "phoneNo": userPhone
      };
}

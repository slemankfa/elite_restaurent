import '../core/constants.dart';

class UserModel {
  final String userName;
  final String email;
  final String? password;
  final String age;
  final String cityId;
  final String areaId;
  final String? userImage;
  final String userGender;
  final String userId;
  final String userPhone;

  UserModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.age,
    required this.cityId,
    required this.userGender,
    required this.areaId,
    required this.userId,
    required this.userPhone,
    this.userImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
        userName: map["userName"],
        email: map["email"],
        password: "",
        age: map["age"],
        userPhone: map["phoneNo"],
        cityId: map["cityID"].toString(),
        userGender: map["sexID"].toString(),
        areaId: map["areaID"].toString(),
        userImage: "$IMAGE_PATH_URL${map["userImage"]}",
        userId: map["userID"].toString());
  }

  factory UserModel.fromSavedJson(Map<String, dynamic> map) {
    return UserModel(
        userName: map["userName"],
        email: map["email"],
        password: "",
        userPhone: map["phoneNo"],
        age: map["age"],
        cityId: map["cityID"],
        userGender: map["sexID"],
        areaId: map["areaID"],
        userImage: map["userImage"],
        userId: map["userID"].toString());
  }

  Map<String, dynamic> toJson() => {
        "userName": userName,
        "email": email,
        "age": age,
        "cityID": cityId,
        "sexID": userGender,
        "areaID": areaId,
        "userImage": userImage,
        "userID": userId,
        "phoneNo":userPhone
      };
}

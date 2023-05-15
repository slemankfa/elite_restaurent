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
    this.userImage,
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
        userImage: "$IMAGE_PATH_URL${map["userImage"]}",
        userId: map["userID"].toString());
  }

  factory UserModel.fromSavedJson(Map<String, dynamic> map) {
    return UserModel(
        firstName: map["firstName"],
        lastName: map["lastName"],
        email: map["email"],
        password: "",
        userPhone: map["phoneNo"],
        age: map["age"],
        cityId: map["cityID"],
        userGender: map["sexID"],
        areaId: map["areaID"],
        userImage: map["userImage"].toString(),
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
        "userImage": userImage.toString(),
        "userID": userId,
        "phoneNo": userPhone
      };
}

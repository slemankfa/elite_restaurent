class UserModel {
  final String userName;
  final String email;
  final String? password;
  final String age;
  final String cityId;
  final String areaId;
  final String? userImage;
  final String userGender;

  UserModel({
    required this.userName,
    required this.email,
    required this.password,
    required this.age,
    required this.cityId,
    required this.userGender,
    required this.areaId,
    this.userImage,
  });
}

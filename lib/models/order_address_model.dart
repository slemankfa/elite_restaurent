class OrderAddressModel {
  String username;
  String address;
  String? optaionalAddress;
  String email;
  String phone;

  OrderAddressModel(
      {required this.username,
      required this.address,
      this.optaionalAddress,
      required this.email,
      required this.phone});
}

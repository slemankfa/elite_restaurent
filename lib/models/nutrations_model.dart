class NutirationModel {
  final String NutrationId;
  final String NutrationTotal;
  final List<NutirationSubItems> subItems;

  NutirationModel({
    required this.NutrationId,
    required this.NutrationTotal,
    required this.subItems,
  });

  factory NutirationModel.fromJson(Map<String, dynamic> map) {
    List<NutirationSubItems> temSubItems = [];
    //
    if (map["details"] != null) {
      List? loadedSubItems = map["details"] as List;
      for (var item in loadedSubItems) {
        temSubItems.add(NutirationSubItems.fromJson(item));
      }
    }

    return NutirationModel(
        NutrationId: map["caloriesID"].toString(),
        NutrationTotal: map["total"].toString(),
        subItems: temSubItems);
  }
}

class NutirationSubItems {
  final String subItemId;
  final String name;
  final String amount;

  NutirationSubItems({
    required this.subItemId,
    required this.name,
    required this.amount,
  });

  factory NutirationSubItems.fromJson(Map<String, dynamic> map) {
    return NutirationSubItems(
        subItemId: map["caloriesDetID"].toString(),
        name: map["name"],
        amount: map["amount"].toString());
  }
}

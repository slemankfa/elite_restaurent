class FilterItemModel {
  final int id;
  final String name;
  bool isselectd;

  FilterItemModel({
    required this.id,
    required this.name,
    this.isselectd = false,
  });
}

class ItemModel {
  final String name;
  final String location;
  final int fee;
  final String phone;
  final String website;
  final List<String> images;

  ItemModel({
    required this.name,
    required this.location,
    required this.fee,
    this.phone = "",
    this.website = "",
    this.images = const [],
  });
}
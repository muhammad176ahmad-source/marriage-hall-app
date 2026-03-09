class HallModel {
  final String name;
  final String location;
  final String phone;
  final int fee;
  final List<String> images;

  // ✅ Add missing fields used in HallDetailsScreen
  final String city;
  final String email;
  final String address;

  HallModel({
    required this.name,
    required this.location,
    required this.phone,
    required this.fee,
    required this.images,
    this.city = "",
    this.email = "",
    this.address = "",
  });
}
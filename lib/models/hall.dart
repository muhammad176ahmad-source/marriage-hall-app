class Hall {
  final String id;
  final String name;
  final String location;
  final String description;
  final String price;
  final String image;
  final String category;
  final String? availableDate;
  final String? ownerUid;

  // ===== NEW OWNER FIELDS =====
  final String? ownerName;
  final String? ownerPhone;
  final String? ownerWhatsapp;
  final String? bookingTime;

  Hall({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.price,
    required this.image,
    required this.category,
    this.availableDate,
    this.ownerUid,

    // NEW (optional so old code break nahi hoga)
    this.ownerName,
    this.ownerPhone,
    this.ownerWhatsapp,
    this.bookingTime,
  });

  // ✅ Create Hall from Firestore
  factory Hall.fromFirestore(Map<String, dynamic> data, String docId) {
    return Hall(
      id: docId,
      name: data['name']?.toString() ?? '',
      location: data['location']?.toString() ?? '',
      description: data['description']?.toString() ?? '',
      price: data['price']?.toString() ?? '',
      image: data['image']?.toString() ?? 'assets/images/placeholder.jpg',
      category: data['category']?.toString() ?? 'Others',
      availableDate: data['availableDate']?.toString(),
      ownerUid: data['ownerUid']?.toString(),

      // NEW FIELDS (safe if not in firebase)
      ownerName: data['ownerName']?.toString(),
      ownerPhone: data['ownerPhone']?.toString(),
      ownerWhatsapp: data['ownerWhatsapp']?.toString(),
      bookingTime: data['bookingTime']?.toString(),
    );
  }

  // ✅ Convert Hall to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "location": location,
      "description": description,
      "price": price,
      "image": image,
      "category": category,
      "availableDate": availableDate,
      "ownerUid": ownerUid,

      // NEW FIELDS
      "ownerName": ownerName,
      "ownerPhone": ownerPhone,
      "ownerWhatsapp": ownerWhatsapp,
      "bookingTime": bookingTime,
    };
  }
}

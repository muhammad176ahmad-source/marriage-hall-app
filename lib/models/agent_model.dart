class Agent {
  String id;
  String fullName;
  String email;
  String phone;
  String cnic;
  String password;
  String city;
  String profilePic;
  List<String> categories;
  bool verified;

  Agent({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.cnic,
    required this.password,
    required this.city,
    required this.profilePic,
    required this.categories,
    this.verified = false,
  });

  factory Agent.empty() => Agent(
    id: "AGENT${DateTime.now().millisecondsSinceEpoch}",
    fullName: "",
    email: "",
    phone: "",
    cnic: "",
    password: "",
    city: "",
    profilePic: "",
    categories: [],
  );
}
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../helpers/location_helper.dart';
import '../../helpers/uploaded_data.dart';
import 'final_list_screen.dart';

class AddRestaurantScreen extends StatefulWidget {
  const AddRestaurantScreen({super.key});

  @override
  State<AddRestaurantScreen> createState() => _AddRestaurantScreenState();
}

class _AddRestaurantScreenState extends State<AddRestaurantScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ownerName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _whatsapp = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _restaurantName = TextEditingController();
  final TextEditingController _perHeadRate = TextEditingController();
  final TextEditingController _deliveryArea = TextEditingController();
  final TextEditingController _deliveryFee = TextEditingController();
  final TextEditingController _deliveryTime = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final ImagePicker _picker = ImagePicker();
  XFile? profileImage;
  XFile? restaurantImage;

  double? latitude;
  double? longitude;

  // ================= EXTRA LIST DATA =================
  List<String> cuisineList = [
    "Chinese","Continental","Fast Food","Desserts","Italian","BBQ","Cafe"
  ];
  List<String> selectedCuisines = [];

  List<String> deliveryOptions = [
    "Home Delivery","Pick Up","Dine In"
  ];
  List<String> selectedDelivery = [];

  List<String> perHeadOptions = ["300","400","500","600","700"];
  List<String> selectedPerHead = [];

  double totalEstimate = 0;

  void calculateTotal() {
    if (selectedPerHead.isNotEmpty && selectedDelivery.isNotEmpty) {
      double rate = double.tryParse(selectedPerHead.first) ?? 0;
      double deliveryCount = selectedDelivery.length.toDouble();
      setState(() {
        totalEstimate = rate * deliveryCount;
      });
    }
  }

  // ===== Image Pickers =====
  Future<void> pickProfile() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => profileImage = img);
  }

  Future<void> pickRestaurantImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => restaurantImage = img);
  }

  // ===== Location =====
  Future<void> fetchLocation() async {
    final loc = await LocationHelper.getCurrentLocation();
    setState(() {
      latitude = loc?.latitude ?? 0.0;
      longitude = loc?.longitude ?? 0.0;
    });
  }

  // ===== Submit =====
  void _submit() async {
    await fetchLocation();
    if (_formKey.currentState!.validate()) {
      UploadedData.addData({
        "type": "Restaurant",
        "ownerName": _ownerName.text,
        "phone": _phone.text,
        "whatsapp": _whatsapp.text,
        "address": _address.text,
        "restaurantName": _restaurantName.text,
        "perHeadRate": _perHeadRate.text,
        "deliveryArea": _deliveryArea.text,
        "deliveryFee": _deliveryFee.text,
        "deliveryTime": _deliveryTime.text,
        "profileImage": profileImage?.path,
        "restaurantImage": restaurantImage?.path,
        "lat": latitude,
        "lng": longitude,
        // ✅ Extra professional selections
        "selectedCuisines": selectedCuisines,
        "selectedDeliveryOptions": selectedDelivery,
        "selectedPerHead": selectedPerHead,
        "totalEstimate": totalEstimate,
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (_) => FinalListScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Restaurant"),
        backgroundColor: Colors.deepPurple.shade700,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/restaurant_bg.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.65)),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickProfile,
                      child: CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        backgroundImage: profileImage != null
                            ? FileImage(File(profileImage!.path))
                            : null,
                        child: profileImage == null
                            ? const Icon(Icons.person,
                                size: 50, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _glassField(_ownerName, "Owner Name"),
                    _glassField(_phone, "Phone Number"),
                    _glassField(_whatsapp, "WhatsApp Number"),
                    _glassField(_address, "Address"),
                    _glassField(_restaurantName, "Restaurant Name"),
                    _glassField(_perHeadRate, "Per Head Rate"),
                    _glassField(_deliveryArea, "Delivery Area"),
                    _glassField(_deliveryFee, "Delivery Fee Per KM"),
                    _glassField(_deliveryTime, "Delivery Time Table"),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: pickRestaurantImage,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          image: restaurantImage != null
                              ? DecorationImage(
                                  image:
                                      FileImage(File(restaurantImage!.path)),
                                  fit: BoxFit.cover)
                              : null,
                        ),
                        child: restaurantImage == null
                            ? const Center(
                                child: Text("Upload Restaurant Image",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _sectionTitle("Select Cuisines"),
                    _buildChecklist(cuisineList, selectedCuisines, true),

                    _sectionTitle("Delivery Options"),
                    _buildChecklist(deliveryOptions, selectedDelivery, false),

                    _sectionTitle("Per Head Options"),
                    _buildChecklist(perHeadOptions, selectedPerHead, false),

                    const SizedBox(height: 16),
                    if (totalEstimate > 0)
                      Text(
                        "Estimated Total: Rs $totalEstimate",
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    const SizedBox(height: 24),
                    _premiumButton(_submit),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== Widgets =====
  Widget _glassField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        validator: (v) => v!.isEmpty ? "This field is required" : null,
      ),
    );
  }

  Widget _premiumButton(VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple.shade700,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          "Submit",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  // ================= Extra Helper Widgets =================
  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildChecklist(
      List<String> items, List<String> selected, bool showSelectAll) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          if (showSelectAll)
            CheckboxListTile(
              value: selected.length == items.length,
              onChanged: (val) {
                setState(() {
                  if (val == true) {
                    selected.clear();
                    selected.addAll(items);
                  } else {
                    selected.clear();
                  }
                  calculateTotal();
                });
              },
              activeColor: Colors.deepPurple,
              title: const Text(
                "Select All",
                style: TextStyle(color: Colors.white),
              ),
            ),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: items.map((item) {
              final isSelected = selected.contains(item);
              return FilterChip(
                label: Text(item),
                selected: isSelected,
                selectedColor: Colors.deepPurple.shade400,
                checkmarkColor: Colors.white,
                labelStyle: const TextStyle(color: Colors.white),
                backgroundColor: Colors.white.withOpacity(0.1),
                onSelected: (val) {
                  setState(() {
                    if (val) {
                      selected.add(item);
                    } else {
                      selected.remove(item);
                    }
                    calculateTotal();
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
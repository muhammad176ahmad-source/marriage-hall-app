import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../helpers/location_helper.dart';
import '../../helpers/uploaded_data.dart';
import 'final_list_screen.dart'; // ✅ Fixed import

class AddHotelScreen extends StatefulWidget {
  const AddHotelScreen({super.key});

  @override
  State<AddHotelScreen> createState() => _AddHotelScreenState();
}

class _AddHotelScreenState extends State<AddHotelScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ownerName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _whatsapp = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _hotelName = TextEditingController();
  final TextEditingController _perNightRate = TextEditingController();
  final TextEditingController _roomCapacity = TextEditingController();
  final TextEditingController _facilities = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final ImagePicker _picker = ImagePicker();
  XFile? profileImage;
  XFile? hotelImage;

  double? latitude;
  double? longitude;

  // ================= EXTRA LIST DATA =================
  List<String> functionList = [
    "Wedding","Mehndi","Baraat","Walima","Engagement",
    "Birthday","Corporate Event","Anniversary",
    "Nikkah","Bridal Shower"
  ];
  List<String> selectedFunctions = [];

  List<String> facilityList = [
    "AC","WiFi","Parking","Room Service","Restaurant",
    "Pool","Gym","Conference Room","Laundry","Security"
  ];
  List<String> selectedFacilities = [];

  List<String> perNightRateOptions = ["3000","4000","5000","6000","7000"];
  List<String> selectedRates = [];

  List<String> roomOptions = ["1","2","3","4","5"];
  List<String> selectedRooms = [];

  double totalAmount = 0;

  void calculateTotal() {
    if (selectedRates.isNotEmpty && selectedRooms.isNotEmpty) {
      double rate = double.tryParse(selectedRates.first) ?? 0;
      double rooms = double.tryParse(selectedRooms.first) ?? 0;
      setState(() {
        totalAmount = rate * rooms;
      });
    }
  }

  // ===== Image Pickers =====
  Future<void> pickProfileImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => profileImage = img);
  }

  Future<void> pickHotelImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => hotelImage = img);
  }

  // ===== Date & Time Pickers =====
  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> pickTime() async {
    final picked = await showTimePicker(
        context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  // ===== Location (null-safe) =====
  Future<void> fetchLocation() async {
    final loc = await LocationHelper.getCurrentLocation();
    setState(() {
      latitude = loc?.latitude ?? 0.0;
      longitude = loc?.longitude ?? 0.0;
    });
  }

  // ===== Submit =====
  void _submitHotel() async {
    await fetchLocation();
    if (_formKey.currentState!.validate()) {
      UploadedData.addData({
        "type": "Hotel",
        "ownerName": _ownerName.text,
        "phone": _phone.text,
        "whatsapp": _whatsapp.text,
        "address": _address.text,
        "hotelName": _hotelName.text,
        "perNightRate": _perNightRate.text,
        "roomCapacity": _roomCapacity.text,
        "facilities": _facilities.text,
        "date": _dateController.text,
        "time": _timeController.text,
        "profileImage": profileImage?.path,
        "hotelImage": hotelImage?.path,
        "lat": latitude,
        "lng": longitude,
        // ✅ Extra selections
        "selectedFunctions": selectedFunctions,
        "selectedFacilities": selectedFacilities,
        "selectedRates": selectedRates,
        "selectedRooms": selectedRooms,
        "totalAmount": totalAmount,
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (_) => FinalListScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Hotel"),
        backgroundColor: Colors.deepPurple.shade700,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/hotel_bg.jpg"),
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
                      onTap: pickProfileImage,
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
                    _glassField(_hotelName, "Hotel Name"),
                    _glassField(_perNightRate, "Per Night Rate"),
                    _glassField(_roomCapacity, "Room Capacity"),
                    _glassField(_facilities, "Facilities"),
                    _dateTimeField(_dateController, "Select Date", pickDate),
                    _dateTimeField(_timeController, "Select Time", pickTime),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: pickHotelImage,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          image: hotelImage != null
                              ? DecorationImage(
                                  image: FileImage(File(hotelImage!.path)),
                                  fit: BoxFit.cover)
                              : null,
                        ),
                        child: hotelImage == null
                            ? const Center(
                                child: Text("Upload Hotel Image",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18)),
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ================= Extra Checklists =================
                    _sectionTitle("Select Functions"),
                    _buildChecklist(functionList, selectedFunctions, true),

                    _sectionTitle("Hotel Facilities"),
                    _buildChecklist(facilityList, selectedFacilities, false),

                    _sectionTitle("Per Night Rate Options"),
                    _buildChecklist(perNightRateOptions, selectedRates, false),

                    _sectionTitle("Room Options"),
                    _buildChecklist(roomOptions, selectedRooms, false),

                    const SizedBox(height: 20),

                    if (totalAmount > 0)
                      Text(
                        "Total Estimate: Rs $totalAmount",
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    const SizedBox(height: 24),

                    _premiumButton(_submitHotel),
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

  Widget _dateTimeField(
      TextEditingController controller, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(controller.text.isEmpty ? label : controller.text,
                style: const TextStyle(color: Colors.white70)),
            const Icon(Icons.calendar_today, color: Colors.white),
          ],
        ),
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
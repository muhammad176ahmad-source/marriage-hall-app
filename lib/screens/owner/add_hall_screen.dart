import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../helpers/location_helper.dart';
import '../../helpers/uploaded_data.dart';
import 'final_list_screen.dart'; // ✅ Fixed import

class AddHallScreen extends StatefulWidget {
  const AddHallScreen({super.key});

  @override
  State<AddHallScreen> createState() => _AddHallScreenState();
}

class _AddHallScreenState extends State<AddHallScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _ownerName = TextEditingController();
  final TextEditingController _ownerPhone = TextEditingController();
  final TextEditingController _ownerWhatsapp = TextEditingController();
  final TextEditingController _ownerAddress = TextEditingController();
  final TextEditingController _hallName = TextEditingController();
  final TextEditingController _perHeadRate = TextEditingController();
  final TextEditingController _guestCapacity = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _availableItems = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  final ImagePicker _picker = ImagePicker();
  XFile? profileImage;
  XFile? hallImage;

  double? latitude;
  double? longitude;

  // ================= EXTRA LIST DATA =================
  List<String> functionList = [
    "Wedding","Mehndi","Baraat","Walima","Engagement",
    "Birthday","Corporate Event","Anniversary",
    "Nikkah","Bridal Shower"
  ];
  List<String> selectedFunctions = [];

  List<String> availableItemList = [
    "Stage","Lighting","Sound System","DJ",
    "Bridal Room","Parking","AC","Generator",
    "Security","Decoration Setup"
  ];
  List<String> selectedAvailableItems = [];

  List<String> perHeadRateOptions = [
    "1000","1200","1500","1800",
    "2000","2500","3000","3500"
  ];
  List<String> selectedRates = [];

  List<String> guestOptions = [
    "100","200","300","500","700","1000"
  ];
  List<String> selectedGuests = [];

  double totalAmount = 0;

  void calculateTotal() {
    if (selectedRates.isNotEmpty && selectedGuests.isNotEmpty) {
      double rate = double.tryParse(selectedRates.first) ?? 0;
      double guests = double.tryParse(selectedGuests.first) ?? 0;
      setState(() {
        totalAmount = rate * guests;
      });
    }
  }

  // ===== Image Pickers =====
  Future<void> pickProfileImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => profileImage = picked);
  }

  Future<void> pickHallImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => hallImage = picked);
  }

  // ===== Date & Time Pickers =====
  Future<void> pickDate() async {
    final DateTime? picked = await showDatePicker(
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
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
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
  void _submitHall() async {
    await fetchLocation();
    if (_formKey.currentState!.validate()) {
      UploadedData.addData({
        "type": "Hall",
        "ownerName": _ownerName.text,
        "phone": _ownerPhone.text,
        "whatsapp": _ownerWhatsapp.text,
        "address": _ownerAddress.text,
        "hallName": _hallName.text,
        "perHeadRate": _perHeadRate.text,
        "guestCapacity": _guestCapacity.text,
        "availableItems": _availableItems.text,
        "date": _dateController.text,
        "time": _timeController.text,
        "profileImage": profileImage?.path,
        "hallImage": hallImage?.path,
        "lat": latitude,
        "lng": longitude,
        // ✅ Extra selections
        "selectedFunctions": selectedFunctions,
        "selectedAvailableItems": selectedAvailableItems,
        "selectedRates": selectedRates,
        "selectedGuests": selectedGuests,
        "totalAmount": totalAmount,
      });

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => FinalListScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Hall"),
        backgroundColor: Colors.deepPurple.shade700,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/hall_bg.jpg"),
                  fit: BoxFit.cover),
            ),
          ),
          Container(color: Colors.black.withOpacity(0.6)),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(color: Colors.black.withOpacity(0.1)),
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
                        radius: 50,
                        backgroundColor: Colors.deepPurple.shade100,
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
                    _glassField(_ownerPhone, "Phone Number"),
                    _glassField(_ownerWhatsapp, "WhatsApp Number"),
                    _glassField(_ownerAddress, "Address"),
                    const SizedBox(height: 16),
                    _glassField(_hallName, "Hall Name"),
                    _glassField(_perHeadRate, "Per Head Rate",
                        keyboardType: TextInputType.number),
                    _glassField(_guestCapacity, "Guest Capacity",
                        keyboardType: TextInputType.number),
                    _glassField(_availableItems, "Available Items"),
                    _dateTimeField(_dateController, "Select Date", pickDate),
                    _dateTimeField(_timeController, "Select Time", pickTime),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: pickHallImage,
                      child: Container(
                        height: 180,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          image: hallImage != null
                              ? DecorationImage(
                                  image: FileImage(File(hallImage!.path)),
                                  fit: BoxFit.cover)
                              : null,
                        ),
                        child: hallImage == null
                            ? const Center(
                                child: Text("Upload Hall Image",
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

                    _sectionTitle("Hall Facilities"),
                    _buildChecklist(availableItemList, selectedAvailableItems, false),

                    _sectionTitle("Per Head Rate Options"),
                    _buildChecklist(perHeadRateOptions, selectedRates, false),

                    _sectionTitle("Guest Capacity Options"),
                    _buildChecklist(guestOptions, selectedGuests, false),

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

                    _premiumButton(_submitHall),
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
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
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 18),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
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
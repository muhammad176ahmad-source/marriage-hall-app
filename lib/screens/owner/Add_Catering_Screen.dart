import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../helpers/location_helper.dart';
import '../../helpers/uploaded_data.dart';
import 'final_list_screen.dart';

class AddCateringScreen extends StatefulWidget {
  const AddCateringScreen({super.key});

  @override
  State<AddCateringScreen> createState() => _AddCateringScreenState();
}

class _AddCateringScreenState extends State<AddCateringScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _ownerName = TextEditingController();
  final TextEditingController _phone = TextEditingController();
  final TextEditingController _whatsapp = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _cateringName = TextEditingController();
  final TextEditingController _perHeadRate = TextEditingController();
  final TextEditingController _guestCapacity = TextEditingController();
  final TextEditingController _menuDetails = TextEditingController();
  final TextEditingController _functions = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final ImagePicker _picker = ImagePicker();
  XFile? profileImage;
  XFile? cateringImage;
  double? latitude;
  double? longitude;

  // ================= LIST DATA =================

  List<String> functionList = [
    "Wedding","Mehndi","Baraat","Walima","Engagement",
    "Birthday","Corporate Event","Anniversary",
    "Nikkah","Bridal Shower"
  ];

  List<String> selectedFunctions = [];

  List<String> menuList =
      List.generate(50, (index) => "Menu Item ${index + 1}");
  List<String> selectedMenus = [];

  List<String> dishTypeList = ["1 Dish Available","2 Dish Available"];
  List<String> selectedDishType = [];

  List<String> perHeadRateList = [
    "1000","1200","1500","1800","2000",
    "2500","3000","3500"
  ];
  List<String> selectedRates = [];

  List<String> guestList = [
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

  // ================= IMAGE PICKERS =================

  Future<void> pickProfile() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => profileImage = img);
  }

  Future<void> pickCateringImage() async {
    final img = await _picker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => cateringImage = img);
  }

  // ================= DATE TIME =================

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
        _dateController.text =
            "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> pickTime() async {
    final picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  Future<void> fetchLocation() async {
    final loc = await LocationHelper.getCurrentLocation();
    setState(() {
      latitude = loc?.latitude ?? 0.0;
      longitude = loc?.longitude ?? 0.0;
    });
  }

  // ================= SUBMIT =================

  void _submit() async {
    await fetchLocation();
    if (_formKey.currentState!.validate()) {
      UploadedData.addData({
        "type": "Catering",
        "ownerName": _ownerName.text,
        "phone": _phone.text,
        "whatsapp": _whatsapp.text,
        "address": _address.text,
        "cateringName": _cateringName.text,
        "perHeadRate": _perHeadRate.text,
        "guestCapacity": _guestCapacity.text,
        "menuDetails": _menuDetails.text,
        "functions": selectedFunctions,
        "selectedMenus": selectedMenus,
        "dishType": selectedDishType,
        "selectedRates": selectedRates,
        "selectedGuests": selectedGuests,
        "totalAmount": totalAmount,
        "date": _dateController.text,
        "time": _timeController.text,
        "profileImage": profileImage?.path,
        "cateringImage": cateringImage?.path,
        "lat": latitude,
        "lng": longitude,
      });

      Navigator.push(
          context, MaterialPageRoute(builder: (_) => FinalListScreen()));
    }
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Catering"),
        backgroundColor: Colors.deepPurple.shade700,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/catering_bg.jpg"),
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
                        backgroundColor: Colors.white24,
                        backgroundImage: profileImage != null
                            ? FileImage(File(profileImage!.path))
                            : null,
                        child: profileImage == null
                            ? const Icon(Icons.person,size: 50,color: Colors.white)
                            : null,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _glassField(_ownerName,"Owner Name"),
                    _glassField(_phone,"Phone Number"),
                    _glassField(_whatsapp,"WhatsApp Number"),
                    _glassField(_address,"Address"),
                    _glassField(_cateringName,"Catering Name"),

                    const SizedBox(height: 20),

                    _sectionTitle("Select Functions"),
                    _buildChecklist(functionList, selectedFunctions, true),

                    _sectionTitle("Select Menus"),
                    _buildChecklist(menuList, selectedMenus, false),

                    _sectionTitle("Dish Type"),
                    _buildChecklist(dishTypeList, selectedDishType, false),

                    _sectionTitle("Per Head Rate"),
                    _buildChecklist(perHeadRateList, selectedRates, false),

                    _sectionTitle("Guest Capacity"),
                    _buildChecklist(guestList, selectedGuests, false),

                    const SizedBox(height: 20),

                    if (totalAmount > 0)
                      Text("Total Estimate: Rs $totalAmount",
                          style: const TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),

                    const SizedBox(height: 25),

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

  Widget _sectionTitle(String text){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(text,
          style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white)),
    );
  }

  Widget _buildChecklist(List<String> items,List<String> selected,bool showSelectAll){
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          if(showSelectAll)
            CheckboxListTile(
              value: selected.length==items.length,
              onChanged: (val){
                setState(() {
                  if(val==true){ selected.addAll(items);}
                  else{ selected.clear();}
                });
              },
              title: const Text("Select All",
                  style: TextStyle(color: Colors.white)),
            ),
          Wrap(
            spacing: 8,
            children: items.map((item){
              final isSelected=selected.contains(item);
              return FilterChip(
                label: Text(item),
                selected: isSelected,
                selectedColor: Colors.deepPurple,
                labelStyle: const TextStyle(color: Colors.white),
                onSelected: (val){
                  setState(() {
                    if(val){ selected.add(item);}
                    else{ selected.remove(item);}
                    calculateTotal();
                  });
                },
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  Widget _glassField(TextEditingController controller,String label){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: InputBorder.none,
        ),
        validator: (v)=> v!.isEmpty ? "Required" : null,
      ),
    );
  }

  Widget _premiumButton(VoidCallback onTap){
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
        child: const Text("Submit",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
      ),
    );
  }
}
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'photographer_model.dart';
import 'photographer_data.dart';

class AddPhotographerScreen extends StatefulWidget {
  const AddPhotographerScreen({Key? key}) : super(key: key);

  @override
  State<AddPhotographerScreen> createState() => _AddPhotographerScreenState();
}

class _AddPhotographerScreenState extends State<AddPhotographerScreen> {

  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final city = TextEditingController();
  final exp = TextEditingController();
  final price = TextEditingController();
  final desc = TextEditingController();

  final ImagePicker picker = ImagePicker();
  List<File> selectedImages = [];
  List<String> selectedServices = [];

  String category = "Wedding";

  final categories = [
    "Wedding",
    "Bridal",
    "Engagement",
    "Birthday",
    "Corporate",
    "Fashion",
    "Drone",
    "Cinematography"
  ];

  final servicesList = [
    "Full Day Coverage",
    "Highlight Video",
    "Drone Shoot",
    "Album Design",
    "Live Streaming",
    "Pre-Wedding Shoot"
  ];

  Future<void> pickImages() async {
    final picked = await picker.pickMultiImage();
    if (picked.isNotEmpty) {
      setState(() {
        selectedImages = picked.map((e) => File(e.path)).toList();
      });
    }
  }

  void savePhotographer() {

    if (!_formKey.currentState!.validate()) return;

    if (selectedServices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select at least one service")),
      );
      return;
    }

    photographersList.add(
      Photographer(
        id: const Uuid().v4(),
        name: name.text.trim(),
        phone: phone.text.trim(),
        email: email.text.trim(),
        city: city.text.trim(),
        experience: exp.text.trim(),
        category: category,
        price: price.text.trim(),
        description: desc.text.trim(),
        services: selectedServices,
        images: selectedImages,
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Photographer Added Successfully")),
    );

    _formKey.currentState!.reset();
    selectedImages.clear();
    selectedServices.clear();

    Navigator.pop(context);
  }

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    email.dispose();
    city.dispose();
    exp.dispose();
    price.dispose();
    desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("Add Photographer (Owner Panel)")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ===== Basic Info =====
              const Text("Basic Information", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

              TextFormField(
                controller: name,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),

              TextFormField(
                controller: phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Phone"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),

              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),

              TextFormField(
                controller: city,
                decoration: const InputDecoration(labelText: "City"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),

              TextFormField(
                controller: exp,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Experience (Years)"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),

              DropdownButtonFormField(
                value: category,
                items: categories
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) => setState(() => category = val!),
                decoration: const InputDecoration(labelText: "Category"),
              ),

              TextFormField(
                controller: price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Starting Price (PKR)"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),

              TextFormField(
                controller: desc,
                maxLines: 3,
                decoration: const InputDecoration(labelText: "About Photographer"),
                validator: (val) => val!.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 20),

              // ===== Services =====
              const Text("Select Services", style: TextStyle(fontWeight: FontWeight.bold)),

              ...servicesList.map((service) => CheckboxListTile(
                title: Text(service),
                value: selectedServices.contains(service),
                onChanged: (val) {
                  setState(() {
                    if (val!) {
                      selectedServices.add(service);
                    } else {
                      selectedServices.remove(service);
                    }
                  });
                },
              )),

              const SizedBox(height: 20),

              // ===== Image Upload =====
              ElevatedButton.icon(
                onPressed: pickImages,
                icon: const Icon(Icons.photo_library),
                label: const Text("Upload Portfolio Images"),
              ),

              const SizedBox(height: 10),

              Wrap(
                spacing: 8,
                children: selectedImages
                    .map((img) => Image.file(img, width: 80, height: 80, fit: BoxFit.cover))
                    .toList(),
              ),

              const SizedBox(height: 30),

              // ===== Save Button =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: savePhotographer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Save Photographer"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
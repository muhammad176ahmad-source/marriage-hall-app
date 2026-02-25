import 'dart:io';
import 'package:flutter/material.dart';
import '../../helpers/uploaded_data.dart';

class FinalListScreen extends StatefulWidget {
  const FinalListScreen({super.key});

  @override
  State<FinalListScreen> createState() => _FinalListScreenState();
}

class _FinalListScreenState extends State<FinalListScreen> {
  void _delete(int index) {
    setState(() {
      UploadedData.deleteData(index);
    });
  }

  void _edit(int index) {
    // ✅ SAFE COPY ADDED (error prevention)
    final item = Map<String, dynamic>.from(UploadedData.allData[index]);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditFormScreen(index: index, data: item),
      ),
    ).then((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final allData = UploadedData.allData;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Uploaded Data"),
        backgroundColor: Colors.deepPurple.shade700,
        centerTitle: true,
      ),
      body: allData.isEmpty
          ? const Center(child: Text("No uploads yet"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: allData.length,
              itemBuilder: (_, index) {
                final item = allData[index];
                return Card(
                  color: Colors.deepPurple.shade50.withOpacity(0.3),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    title: Text(
                      "${item['type'] ?? ''}: ${item['restaurantName'] ?? item['hallName'] ?? item['hotelName'] ?? item['cateringName'] ?? ''}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      "Owner: ${item['ownerName'] ?? ''}\nPhone: ${item['phone'] ?? ''}",
                    ),
                    isThreeLine: true,
                    leading: item['profileImage'] != null
                        ? CircleAvatar(
                            backgroundImage:
                                FileImage(File(item['profileImage'])),
                          )
                        : const CircleAvatar(child: Icon(Icons.person)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => _edit(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _delete(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

// ===== Edit Form Screen =====
class EditFormScreen extends StatefulWidget {
  final int index;
  final Map<String, dynamic> data;
  const EditFormScreen({super.key, required this.index, required this.data});

  @override
  State<EditFormScreen> createState() => _EditFormScreenState();
}

class _EditFormScreenState extends State<EditFormScreen> {
  late Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = Map<String, dynamic>.from(widget.data);
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // ✅ NULL SAFE TYPE (error prevention)
    final String type = data['type'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Edit $type"),
        backgroundColor: Colors.deepPurple.shade700,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              ..._buildFields(type),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      UploadedData.updateData(widget.index, data);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple.shade700,
                  ),
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFields(String type) {
    final fields = <Widget>[];

    Widget _textField(String key, String label) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextFormField(
          initialValue: data[key]?.toString() ?? '',
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (v) => data[key] = v,
          validator: (v) => v == null || v.isEmpty ? "Required Field" : null,
        ),
      );
    }

    fields.add(_textField('ownerName', 'Owner Name'));
    fields.add(_textField('phone', 'Phone Number'));
    fields.add(_textField('whatsapp', 'WhatsApp Number'));
    fields.add(_textField('address', 'Address'));

    switch (type) {
      case "Restaurant":
        fields.add(_textField('restaurantName', 'Restaurant Name'));
        fields.add(_textField('perHeadRate', 'Per Head Rate'));
        fields.add(_textField('deliveryArea', 'Delivery Area'));
        fields.add(_textField('deliveryFee', 'Delivery Fee Per KM'));
        fields.add(_textField('deliveryTime', 'Delivery Time Table'));
        break;
      case "Hall":
        fields.add(_textField('hallName', 'Hall Name'));
        fields.add(_textField('perHeadRate', 'Per Head Rate'));
        fields.add(_textField('guestCapacity', 'Guest Capacity'));
        break;
      case "Hotel":
        fields.add(_textField('hotelName', 'Hotel Name'));
        fields.add(_textField('roomType', 'Room Type'));
        fields.add(_textField('pricePerNight', 'Price Per Night'));
        fields.add(_textField('availableRooms', 'Available Rooms'));
        break;
      case "Catering":
        fields.add(_textField('cateringName', 'Catering Name'));
        fields.add(_textField('perHeadRate', 'Per Head Rate'));
        fields.add(_textField('guestCapacity', 'Guest Capacity'));
        fields.add(_textField('menuDetails', 'Menu Details'));
        fields.add(_textField('functions', 'Available Functions'));
        break;
    }

    return fields;
  }
}
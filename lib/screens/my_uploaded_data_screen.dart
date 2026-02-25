import 'package:flutter/material.dart';
import 'uploaded_data.dart';

class MyUploadedDataScreen extends StatefulWidget {
  const MyUploadedDataScreen({super.key});

  @override
  State<MyUploadedDataScreen> createState() => _MyUploadedDataScreenState();
}

class _MyUploadedDataScreenState extends State<MyUploadedDataScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Uploaded Data")),
      body: ListView.builder(
        itemCount: UploadedData.instance.uploadedItems.length,
        itemBuilder: (context, index) {
          final data = UploadedData.instance.uploadedItems[index];
          return Card(
            child: ListTile(
              title: Text(data['Hall Name'] ?? data['Hotel Name'] ?? data['Restaurant Name'] ?? data['Catering Name'] ?? "Unknown"),
              subtitle: Text("Owner: ${data['Owner Name']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // Implement edit functionality
                      }),
                  IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          UploadedData.instance.removeData(index);
                        });
                      }),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
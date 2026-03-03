import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddVenueScreen extends StatefulWidget {
  const AddVenueScreen({super.key});

  @override
  State<AddVenueScreen> createState() => _AddVenueScreenState();
}

class _AddVenueScreenState extends State<AddVenueScreen> {
  int step=0;
  final PageController controller = PageController();

  void next(){
    if(step<2){step++; controller.nextPage(duration: const Duration(milliseconds:300),curve: Curves.easeIn); setState(() {});}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Venue")),
      body: Column(
        children: [
          LinearProgressIndicator(value:(step+1)/3),
          Expanded(
            child: PageView(
              controller: controller,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                VenueBasicInfo(),
                VenuePricing(),
                VenueFacilities(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(onPressed: next, child: const Text("Next")),
          )
        ],
      ),
    );
  }
}

class VenueBasicInfo extends StatelessWidget {
  const VenueBasicInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: const [
          TextField(decoration: InputDecoration(labelText: "Venue Name")),
          TextField(decoration: InputDecoration(labelText: "City")),
          TextField(decoration: InputDecoration(labelText: "Capacity")),
        ],
      ),
    );
  }
}

class VenuePricing extends StatelessWidget {
  const VenuePricing({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView(
        children: const [
          TextField(decoration: InputDecoration(labelText: "Price Per Head")),
          TextField(decoration: InputDecoration(labelText: "Package Details")),
        ],
      ),
    );
  }
}

class VenueFacilities extends StatefulWidget {
  const VenueFacilities({super.key});

  @override
  State<VenueFacilities> createState() => _VenueFacilitiesState();
}

class _VenueFacilitiesState extends State<VenueFacilities> {
  final facilities = ["AC","Parking","Decoration","Stage","Sound"];
  final selected = <String>[];
  final List<File> images=[];
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if(image!=null){setState(()=>images.add(File(image.path)));}
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("Select Facilities:"),
        ...facilities.map((f)=>CheckboxListTile(
          title: Text(f),
          value: selected.contains(f),
          onChanged: (v){setState((){v==true?selected.add(f):selected.remove(f);});},
        )),
        const SizedBox(height:10),
        ElevatedButton(onPressed: pickImage, child: const Text("Upload Photos")),
        Wrap(
          children: images.map((img)=>Padding(
            padding: const EdgeInsets.all(5),
            child: Image.file(img,height:80,width:80,fit:BoxFit.cover),
          )).toList(),
        )
      ],
    );
  }
}
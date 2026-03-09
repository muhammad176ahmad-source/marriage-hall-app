// lib/screens/proposal_screen.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class ProposalScreen extends StatefulWidget {
  const ProposalScreen({super.key});

  @override
  State<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends State<ProposalScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

  // Sample proposals
  final List<Map<String, String>> proposals = [
    {
      "invitee": "Mr. Ali",
      "functionName": "Wedding Ceremony",
      "dateTime": "10 March 2026, 7:00 PM",
      "hall": "Royal Banquet Hall",
      "restaurant": "Biryani Palace",
      "catering": "Delicious Catering",
      "address": "Karachi, Pakistan",
      "notes": "Formal attire required",
    },
  ];

  // Controllers
  final TextEditingController _inviteeController = TextEditingController();
  final TextEditingController _functionController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();
  final TextEditingController _hallController = TextEditingController();
  final TextEditingController _restaurantController = TextEditingController();
  final TextEditingController _cateringController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // Background options
  String _selectedBackground = "assets/images/card_bg.jpg";
  final List<String> _backgroundOptions = [
    "assets/images/card_bg.jpg",
    "assets/images/card_bg2.jpg",
    "assets/images/card_bg3.jpg",
  ];

  // Function type icons
  final Map<String, IconData> functionIcons = {
    "wedding": Icons.favorite,
    "engagement": Icons.card_giftcard,
    "birthday": Icons.cake,
    "corporate": Icons.business_center,
    "other": Icons.event,
  };

  void _addProposal() {
    if (_inviteeController.text.isEmpty) return;

    final newProposal = {
      "invitee": _inviteeController.text,
      "functionName": _functionController.text,
      "dateTime": _dateTimeController.text,
      "hall": _hallController.text,
      "restaurant": _restaurantController.text,
      "catering": _cateringController.text,
      "address": _addressController.text,
      "notes": _notesController.text,
    };

    setState(() {
      proposals.add(newProposal);

      _inviteeController.clear();
      _functionController.clear();
      _dateTimeController.clear();
      _hallController.clear();
      _restaurantController.clear();
      _cateringController.clear();
      _addressController.clear();
      _notesController.clear();
    });

    _showCardPreview(newProposal);
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.amber),
          filled: true,
          fillColor: Colors.black.withOpacity(0.35),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: const TextStyle(
              color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 16),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getFunctionIcon(String functionName) {
    for (var key in functionIcons.keys) {
      if (functionName.toLowerCase().contains(key)) {
        return functionIcons[key]!;
      }
    }
    return functionIcons["other"]!;
  }

  Future<void> _showCardPreview(Map<String, String> data) async {
    final image = await _screenshotController.captureFromWidget(
      _buildProfessionalCard(data),
      pixelRatio: 3.0,
    );

    if (image.isEmpty) return;

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/${data["invitee"]}_proposal.jpg');
    await file.writeAsBytes(image);

    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(file),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: const Icon(Icons.share),
              label: const Text("Share Invitation"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber[400],
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Share.shareXFiles([XFile(file.path)], text: "You're invited!");
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfessionalCard(Map<String, String> data) {
    IconData funcIcon = _getFunctionIcon(data["functionName"] ?? "");

    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          image: DecorationImage(
            image: AssetImage(_selectedBackground),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.25),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 20,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top icon and function name
            Center(
              child: Column(
                children: [
                  Icon(funcIcon, size: 60, color: Colors.amberAccent),
                  const SizedBox(height: 10),
                  Text(
                    data["functionName"] ?? "",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[400],
                      shadows: const [
                        Shadow(
                          color: Colors.black45,
                          blurRadius: 6,
                          offset: Offset(2, 2),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "You're Invited!",
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Details
            _infoRow("Invitee", data["invitee"]!),
            _infoRow("Date & Time", data["dateTime"]!),
            _infoRow("Hall", data["hall"]!),
            _infoRow("Restaurant", data["restaurant"]!),
            _infoRow("Catering", data["catering"]!),
            _infoRow("Address", data["address"]!),
            _infoRow("Notes", data["notes"]!),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundSelector() {
    return SizedBox(
      height: 80,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _backgroundOptions.map((bg) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedBackground = bg;
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: _selectedBackground == bg
                        ? Colors.amber
                        : Colors.transparent,
                    width: 2),
                image: DecorationImage(image: AssetImage(bg), fit: BoxFit.cover),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Proposals"),
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: Image.asset(
            "assets/images/background_home.jpg",
            fit: BoxFit.cover,
          )),
          Container(color: Colors.black.withOpacity(0.5)),
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Input section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Create New Invitation",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber)),
                    const SizedBox(height: 10),
                    _buildInputField("Invitee", _inviteeController),
                    _buildInputField("Function Name", _functionController),
                    _buildInputField("Date & Time", _dateTimeController),
                    _buildInputField("Hall", _hallController),
                    _buildInputField("Restaurant", _restaurantController),
                    _buildInputField("Catering", _cateringController),
                    _buildInputField("Address", _addressController),
                    _buildInputField("Notes", _notesController),
                    const SizedBox(height: 10),
                    const Text("Choose Card Background",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber)),
                    _buildBackgroundSelector(),
                    const SizedBox(height: 10),
                    Center(
                      child: ElevatedButton(
                        onPressed: _addProposal,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber[400],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Generate Invitation",
                            style: TextStyle(color: Colors.black)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Existing proposals
              ...proposals.map((p) => Screenshot(
                    controller: _screenshotController,
                    child: _buildProfessionalCard(p),
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
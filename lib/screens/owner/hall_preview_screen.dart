import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/hall.dart';
import '../../widgets/hall_image_slider.dart';
import '../../screens/booking/booking_inquiry_form.dart';

class HallPreviewScreen extends StatelessWidget {
  final Hall hall;
  const HallPreviewScreen({super.key, required this.hall});

  // ================= CALL FUNCTION =================
  Future<void> _callOwner(String phone) async {
    if (phone.isEmpty) return;
    final Uri uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  // ================= WHATSAPP FUNCTION =================
  Future<void> _openWhatsApp(String phone) async {
    if (phone.isEmpty) return;
    final Uri uri = Uri.parse(
        "https://wa.me/$phone?text=Hello, I am interested in booking your hall.");
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hall Preview'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HallImageSlider(hall: hall),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ---------- Hall Name ----------
                  Text(
                    hall.name,
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // ---------- Location ----------
                  _infoRow(
                    icon: Icons.place,
                    iconColor: Colors.redAccent,
                    text: hall.location,
                  ),
                  const SizedBox(height: 8),

                  // ---------- Available Date ----------
                  _infoRow(
                    icon: Icons.calendar_month,
                    iconColor: Colors.blue,
                    text: _formatAvailableDate(hall.availableDate),
                  ),
                  const SizedBox(height: 16),

                  // ---------- Price ----------
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee, color: Colors.deepPurple),
                      const SizedBox(width: 6),
                      Text(
                        '${hall.price} / day',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ---------- Description ----------
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    hall.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 16),

                  // ---------- View Location ----------
                  Row(
                    children: [
                      const Icon(Icons.map, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        'View Location',
                        style: TextStyle(fontSize: 16, color: Colors.green.shade700),
                      ),
                    ],
                  ),

                  const SizedBox(height: 25),

                  // ================= OWNER PROFESSIONAL SECTION =================

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const Text(
                          "Hall Owner Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 26,
                              backgroundColor: Colors.deepPurple,
                              child: Icon(Icons.person, color: Colors.white),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    hall.ownerName ?? "Owner Name",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Booking Time: ${hall.bookingTime ?? "9:00 AM - 8:00 PM"}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  const SizedBox(height: 4),
                                  const Row(
                                    children: [
                                      Icon(Icons.verified, color: Colors.blue, size: 16),
                                      SizedBox(width: 4),
                                      Text(
                                        "Verified Owner",
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        Row(
                          children: [

                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _callOwner(hall.ownerPhone ?? ""),
                                icon: const Icon(Icons.call),
                                label: const Text("Call Now"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 12),

                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    _openWhatsApp(hall.ownerWhatsapp ?? ""),
                                icon: const Icon(Icons.chat),
                                label: const Text("WhatsApp"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Center(
                          child: Text(
                            "Usually responds within 5 minutes",
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ---------- Send Inquiry Button ----------
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final price = double.tryParse(hall.price) ?? 0.0;
                        final date = hall.availableDate != null
                            ? DateTime.tryParse(hall.availableDate!)
                            : null;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookingInquiryForm(
                              hallName: hall.name,
                              hallPrice: price,
                              hallDate: date,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Send Inquiry',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatAvailableDate(String? dateString) {
    if (dateString == null || dateString.isEmpty)
      return 'Available Date: Flexible';
    try {
      final date = DateTime.tryParse(dateString)?.toLocal();
      if (date != null) {
        return 'Available Date: ${date.toString().split(' ')[0]}';
      } else {
        return 'Available Date: Flexible';
      }
    } catch (_) {
      return 'Available Date: Flexible';
    }
  }

  Widget _infoRow({
    required IconData icon,
    required Color iconColor,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 22),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}

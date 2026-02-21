import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {

  bool bookingNotification = true;
  bool offersNotification = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification Settings")),
      body: Column(
        children: [
          SwitchListTile(
            title: const Text("Booking Notifications"),
            value: bookingNotification,
            onChanged: (val){
              setState(() {
                bookingNotification = val;
              });
            },
          ),
          SwitchListTile(
            title: const Text("Offers & Updates"),
            value: offersNotification,
            onChanged: (val){
              setState(() {
                offersNotification = val;
              });
            },
          ),
        ],
      ),
    );
  }
}

import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  final SharedPreferences _prefs;

  FirestoreService(this._prefs);  // Initialize SharedPreferences instance

  // ✅ Save Booking (using local storage)
  Future<void> saveBooking(Map<String, dynamic> data) async {
    try {
      // Save booking data in local storage (simulating Firestore save)
      await _prefs.setString('booking_${data['hallName']}_${data['date']}_${data['time']}', data.toString());
    } catch (e) {
      throw Exception('Failed to save booking: $e');
    }
  }

  // ✅ Check Availability (using local storage)
  Future<List<Map<String, dynamic>>> checkBookingAvailability({
    required String hallName,
    required String date,
    required String time,
  }) async {
    try {
      // Retrieve all bookings stored in local storage
      List<Map<String, dynamic>> bookings = [];
      for (String key in _prefs.getKeys()) {
        if (key.startsWith('booking_')) {
          String bookingData = _prefs.getString(key) ?? '';
          // Check if the stored booking matches the hallName, date, and time
          if (bookingData.contains(hallName) && bookingData.contains(date) && bookingData.contains(time)) {
            // Simulating checking availability from stored data
            bookings.add({
              'hallName': hallName,
              'date': date,
              'time': time,
              'data': bookingData, // You can return more data if necessary
            });
          }
        }
      }
      return bookings;  // Return matching bookings
    } catch (e) {
      throw Exception('Failed to check availability: $e');
    }
  }
}

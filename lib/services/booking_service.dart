import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> createBooking({

    required String name,
    required String phone,
    required String hall,
    required String date,

  }) async {

    await firestore.collection("bookings").add({

      "name": name,
      "phone": phone,
      "hall": hall,
      "date": date

    });

  }

}
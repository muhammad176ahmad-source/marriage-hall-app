import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewService {

  final firestore = FirebaseFirestore.instance;

  Future<void> addReview({

    required String hallId,
    required String user,
    required String comment,
    required double rating

  }) async {

    await firestore.collection("reviews").add({

      "hallId": hallId,
      "user": user,
      "comment": comment,
      "rating": rating

    });

  }

}
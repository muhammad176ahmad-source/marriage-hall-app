import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads image to Firebase Storage and returns the download URL
  Future<String> uploadImage(File file, String uid) async {
    try {
      final ref = _storage.ref().child('hall_images/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = ref.putFile(file);

      final snapshot = await uploadTask;
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}

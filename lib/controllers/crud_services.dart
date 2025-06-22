import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUDServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Ambil UID user saat ini
  String get currentUserId => _auth.currentUser!.uid;

  // Tambah kontak baru
  Future<void> addNewContact(String name, String phone, String email) async {
    try {
      final data = {
        "name": name,
        "phone": phone,
        "email": email,
        "createdAt": FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection("users")
          .doc(currentUserId)
          .collection("contacts")
          .add(data);

      print("Contact added.");
    } catch (e) {
      print("Error adding contact: $e");
    }
  }

  // Ambil kontak user (real-time)
  Stream<QuerySnapshot> getContacts() {
    return _firestore
        .collection("users")
        .doc(currentUserId)
        .collection("contacts")
        .orderBy("name")
        .snapshots();
  }

  // Perbarui data kontak
  Future<void> updateContact({
    required String docId,
    required String name,
    required String phone,
    required String email,
  }) async {
    try {
      final data = {
        "name": name,
        "phone": phone,
        "email": email,
        "updatedAt": FieldValue.serverTimestamp(),
      };

      await _firestore
          .collection("users")
          .doc(currentUserId)
          .collection("contacts")
          .doc(docId)
          .update(data);

      print("Contact updated.");
    } catch (e) {
      print("Error updating contact: $e");
    }
  }

  // Hapus kontak
  Future<void> deleteContact(String docId) async {
    try {
      await _firestore
          .collection("users")
          .doc(currentUserId)
          .collection("contacts")
          .doc(docId)
          .delete();

      print("Contact deleted.");
    } catch (e) {
      print("Error deleting contact: $e");
    }
  }
}

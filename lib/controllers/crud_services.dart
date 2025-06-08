import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUDServices {
  User? user = FirebaseAuth.instance.currentUser;

  // add new contact to firestore
  Future addNewContacts(String name, String phone, String email) async {
    Map<String, dynamic> data = {"name": name, "email": email, "phone": phone};
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .add(data);
      print("Document Added");
    } catch (e) {
      print(e.toString());
    }
  }

  // read documents inside firestore
  Stream<QuerySnapshot> getContacts() async* {
    var contacts =
        FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection("contacts")
            .orderBy("name")
            .snapshots();

    yield* contacts;
  }

  // update contacts
  Future updateContacts(
    String name,
    String phone,
    String email,
    String docID,
  ) async {
    Map<String, dynamic> data = {"name": name, "email": email, "phone": phone};
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .doc(docID)
          .update(data);
      print("Document Updated");
    } catch (e) {
      print(e.toString());
    }
  }

  // delete contact from firestore
  Future deleteContact(String docID) async {
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(user!.uid)
          .collection("contacts")
          .doc(docID)
          .delete();
      print("Contact Deleted");
    } catch (e) {
      print(e.toString());
    }
  }
}

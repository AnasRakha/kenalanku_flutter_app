import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kenalanku/controllers/crud_services.dart';
import 'package:kenalanku/views/update_contact_page.dart';
import 'package:url_launcher/url_launcher.dart';

class PhonePage extends StatelessWidget {
  const PhonePage({super.key});

  // Fungsi untuk membuka dialer
  void launchDialer(String phoneNumber) async {
    final Uri url = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      debugPrint('Tidak dapat membuka dialer untuk $phoneNumber');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Kontak Saya"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, "/add"),
        child: Icon(Icons.person_add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: CRUDServices().getContacts(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Terjadi kesalahan."));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Belum ada kontak"));
          }

          return ListView(
            children:
                snapshot.data!.docs.map((doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;

                  return ListTile(
                    onTap:
                        () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => UpdateContact(
                                  docID: doc.id,
                                  name: data["name"],
                                  phone: data["phone"],
                                  email: data["email"],
                                ),
                          ),
                        ),
                    leading: CircleAvatar(
                      child: Text(data["name"][0].toUpperCase()),
                    ),
                    title: Text(data["name"]),
                    subtitle: Text(data["phone"]),
                    trailing: IconButton(
                      icon: Icon(Icons.call),
                      onPressed: () => launchDialer(data["phone"]),
                    ),
                  );
                }).toList(),
          );
        },
      ),
    );
  }
}

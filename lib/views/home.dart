import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kenalanku/controllers/auth_services.dart';
import 'package:kenalanku/controllers/crud_services.dart';
import 'package:kenalanku/views/update_contact_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kenalanku")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/add");
        },
        child: Icon(Icons.person_add),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    maxRadius: 32,
                    child: Text(
                      FirebaseAuth.instance.currentUser!.email
                          .toString()[0]
                          .toUpperCase(),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(FirebaseAuth.instance.currentUser!.email.toString()),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                AuthServices().logout();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text("Logged Out")));
                Navigator.pushReplacementNamed(context, "/login");
              },
              leading: Icon(Icons.logout_outlined),
              title: Text("Logout"),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: CRUDServices().getContacts(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No contacts found."));
          }
          if (snapshot.hasError) {
            return Text("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Text("Loading"));
          }
          return ListView(
            children:
                snapshot.data!.docs
                    .map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ListTile(
                        onTap:
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => UpdateContact(
                                      name: data["name"],
                                      phone: data["phone"],
                                      email: data["email"],
                                      docID: document.id,
                                    ),
                              ),
                            ),
                        leading: CircleAvatar(child: Text(data["name"][0])),
                        title: Text(data["name"]),
                        subtitle: Text(data["phone"]),
                        trailing: IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.call),
                        ),
                      );
                    })
                    .toList()
                    .cast(),
          );
        },
      ),
    );
  }
}

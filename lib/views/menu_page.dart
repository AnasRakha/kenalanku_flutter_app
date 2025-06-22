import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kenalanku/controllers/auth_services.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Menu")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Tengah secara vertikal
          crossAxisAlignment:
              CrossAxisAlignment.center, // Tengah secara horizontal
          children: [
            CircleAvatar(
              radius: 40,
              child: Text(
                user!.email.toString()[0].toUpperCase(),
                style: const TextStyle(fontSize: 30),
              ),
            ),
            const SizedBox(height: 12),
            Text(user.email.toString(), style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await AuthServices().logout();
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Logged Out")));
                Navigator.pushReplacementNamed(context, "/login");
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(),
            ),
          ],
        ),
      ),
    );
  }
}

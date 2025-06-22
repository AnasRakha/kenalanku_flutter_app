import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kenalanku/views/chat_detail_page.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      return const Scaffold(body: Center(child: Text("User tidak login")));
    }

    final currentEmail = currentUser.email ?? "";

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Daftar Pengguna")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("users").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Terjadi kesalahan saat memuat data."),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          // Filter & sortir berdasarkan email, tidak termasuk diri sendiri
          final users =
              docs.where((doc) {
                  final data = doc.data() as Map<String, dynamic>?;
                  return data != null &&
                      data.containsKey("email") &&
                      data["email"] != currentEmail;
                }).toList()
                ..sort((a, b) {
                  final emailA =
                      (a.data() as Map<String, dynamic>)["email"]
                          ?.toLowerCase() ??
                      "";
                  final emailB =
                      (b.data() as Map<String, dynamic>)["email"]
                          ?.toLowerCase() ??
                      "";
                  return emailA.compareTo(emailB);
                });

          if (users.isEmpty) {
            return const Center(child: Text("Belum ada pengguna lain."));
          }

          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final userData = users[index].data() as Map<String, dynamic>;
              final email = userData["email"] ?? "(tanpa email)";

              return ListTile(
                leading: CircleAvatar(child: Text(email[0].toUpperCase())),
                title: Text(email),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatDetailPage(receiverEmail: email),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

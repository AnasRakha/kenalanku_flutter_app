import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MessageServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Mendapatkan ID ruang obrolan yang konsisten (berdasarkan urutan alfabet email)
  String getChatRoomId(String user1, String user2) {
    return user1.compareTo(user2) < 0 ? '${user1}_$user2' : '${user2}_$user1';
  }

  // Kirim pesan ke Firestore
  Future<void> sendMessage(String receiverEmail, String message) async {
    final senderEmail = _auth.currentUser?.email;
    if (senderEmail == null || receiverEmail.isEmpty || message.trim().isEmpty)
      return;

    final chatRoomId = getChatRoomId(senderEmail, receiverEmail);

    await _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .add({
          'sender': senderEmail,
          'receiver': receiverEmail,
          'message': message.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });

    // (Opsional) Simpan pesan terakhir di dokumen chat utama
    await _firestore.collection('chats').doc(chatRoomId).set({
      'lastMessage': message.trim(),
      'lastSender': senderEmail,
      'lastReceiver': receiverEmail,
      'timestamp': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Ambil stream real-time dari pesan antara user saat ini dan user lainnya
  Stream<QuerySnapshot> getMessages(String receiverEmail) {
    final senderEmail = _auth.currentUser?.email ?? '';
    final chatRoomId = getChatRoomId(senderEmail, receiverEmail);

    return _firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  // Ambil daftar pengguna lain (selain yang sedang login)
  Stream<QuerySnapshot> getAllOtherUsers() {
    final currentEmail = _auth.currentUser?.email ?? '';
    return _firestore
        .collection('users')
        .where('email', isNotEqualTo: currentEmail)
        .snapshots();
  }

  // Tambahkan user ke koleksi 'users' jika belum terdaftar (dijalankan saat signup)
  Future<void> createUserIfNotExists(String email) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final docRef = _firestore.collection('users').doc(uid);
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      await docRef.set({
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../widgets/user_avatar.dart';
import '../services/auth_service.dart';
import '../services/user_provider.dart';

class UserProfileScreen extends StatelessWidget {
  final String userId;

  const UserProfileScreen({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final isAdmin = authService.currentUser?.uid == userId ||
        Provider.of<UserProvider>(context, listen: false).role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Профіль користувача'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Користувача не знайдено'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          if (userData == null) {
            return const Center(child: Text('Дані користувача відсутні'));
          }
          final displayName = userData['displayName'] ?? 'Користувач';
          final email = userData['email'] ?? '';
          final role = userData['role'] ?? '';
          final familyId = userData['familyId'] ?? '';

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserAvatar(
                  userId: userId,
                  displayName: displayName,
                  size: 80,
                ),
                const SizedBox(height: 16),
                Text(
                  displayName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Сім\'я: $familyId'),
                if (isAdmin) ...[
                  const SizedBox(height: 8),
                  Text('Роль: $role'),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

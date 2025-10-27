import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../services/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserAvatar extends StatelessWidget {
  final String userId;
  final String? displayName;
  final double size;
  final VoidCallback? onTap;

  const UserAvatar({
    Key? key,
    required this.userId,
    this.displayName,
    this.size = 40,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
      builder: (context, snapshot) {
        String? name = displayName;
        if (snapshot.hasData && snapshot.data != null) {
          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          if (userData != null && userData.containsKey('displayName')) {
            name = userData['displayName'];
          }
        }
        return GestureDetector(
          onTap: onTap,
          child: _buildAvatar(name),
        );
      },
    );
  }

  Widget _buildAvatar(String? name) {
    final displayText = name ?? 'User';
    final initial = displayText.isNotEmpty ? displayText[0].toUpperCase() : '?';
    // колір на основі айді
    final random = Random(userId.hashCode);
    final color = Color.fromARGB(
      255,
      random.nextInt(200),
      random.nextInt(200),
      random.nextInt(200),
    );

    return CircleAvatar(
      radius: size / 2,
      backgroundColor: color,
      child: Text(
        initial,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }
}

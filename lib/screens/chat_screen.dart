import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/encryption_service.dart';
import '../services/db_service.dart';
import '../widgets/user_avatar.dart';
import '../screens/user_profile_screen.dart';
import '../services/user_provider.dart';
import '../l10n/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final EncryptionService _encryptionService = EncryptionService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  String? _currentFamilyId;

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return '';

    DateTime dateTime;
    if (timestamp is Timestamp) {
      dateTime = timestamp.toDate();
    } else if (timestamp is String) {
      dateTime = DateTime.parse(timestamp);
    } else {
      return '';
    }
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _updateMessageStatus(String messageId, String status) {
    if (_currentFamilyId == null) return;
    try {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(_currentFamilyId)
          .collection('messages')
          .doc(messageId)
          .update({'status': status})
          .catchError((error) {
        print('Ошибка обновления статуса: $error');
      });
    } catch (e) {
      print('Ошибка при вызове обновления статуса: $e');
    }
  }

  void _sendMessage(String text) {
    if (text.isEmpty || _currentFamilyId == null) return;

    final encryptedText = _encryptionService.encrypt(text);

    try {
      FirebaseFirestore.instance
          .collection('chats')
          .doc(_currentFamilyId)
          .collection('messages')
          .add({
        'text': encryptedText,
        'userId': Provider.of<AuthService>(context, listen: false).currentUser?.uid,
        'timestamp': DateTime.now(),
        'status': 'sent',
      });
      _messageController.clear();
    } catch (e) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorMessage(e.toString()))),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _encryptionService.initialize();
    _loadFamilyKey();
  }

  Future<void> _loadFamilyKey() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dbService = Provider.of<DbService>(context, listen: false);
      final userId = authService.currentUser?.uid ?? '';
      final familyId = await dbService.getFamilyIdForUser(userId);
      if (familyId != null && mounted) {
        setState(() {
          _currentFamilyId = familyId;
        });
        final key = await dbService.getFamilyEncryptionKey(familyId);
        await _encryptionService.initializeWithKey(key);
      }
    } catch (e) {
      print('Помилка завантаження ключа сім\'ї: $e');
    }
  }

  Widget _buildMessage(DocumentSnapshot message) {
    final data = message.data() as Map<String, dynamic>?;
    if (data == null || !data.containsKey('text')) {
      return const SizedBox();
    }
    final encryptedText = data['text'] as String;
    final decryptedText = _encryptionService.decrypt(encryptedText);
    final isCurrentUser = data['userId'] == Provider.of<AuthService>(context, listen: false).currentUser?.uid;
    final messageStatus = data['status'] ?? 'sent';
    final messageUserId = data['userId'] as String;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: UserAvatar(
                userId: messageUserId,
                size: 36,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(userId: messageUserId),
                    ),
                  );
                },
              ),
            ),
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isCurrentUser ? Colors.blue[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    decryptedText,
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTimestamp(data['timestamp']),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: messageStatus == 'sent'
                              ? Colors.grey
                              : messageStatus == 'delivered'
                              ? Colors.blue[200]
                              : Colors.transparent,
                          border: messageStatus == 'read' ? Border.all(color: Colors.blue, width: 1.5) : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: UserAvatar(
                userId: messageUserId,
                size: 36,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UserProfileScreen(userId: messageUserId),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChatScreen(String userId, String familyId) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.familyChat),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chats')
                  .doc(familyId)
                  .collection('messages')
                  .orderBy('timestamp', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text(l10n.errorMessage(snapshot.error.toString())));
                }
                final messages = snapshot.data!.docs;
                if (messages.isEmpty) {
                  return Center(child: Text(l10n.noMessages));
                }
                // прокруч до ост повідомлення після побуд списку
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  try {
                    // Прокрутка до ост повідомлення
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                    // Оновлення статусу повідомлень
                    for (var message in messages) {
                      final data = message.data() as Map<String, dynamic>?;
                      if (data != null &&
                          data['userId'] != userId &&
                          data['status'] != 'read') {
                        if (mounted) {
                          _updateMessageStatus(message.id, 'read');
                        }
                      }
                    }
                  } catch (e) {
                    print('Помилка при обробці повідомлень: $e');
                  }
                });
                return ListView.builder(
                  controller: _scrollController,
                  reverse: false,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return _buildMessage(messages[index]);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(labelText: l10n.message),
                    enabled: true,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      _sendMessage(_messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userId = authService.currentUser?.uid ?? '';

    if (_currentFamilyId != null) {
      return _buildChatScreen(userId, _currentFamilyId!);
    }

    return FutureBuilder<String?>(
      future: Provider.of<DbService>(context, listen: false).getFamilyIdForUser(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final familyId = snapshot.data ?? 'family_id';
        _currentFamilyId = familyId;
        return _buildChatScreen(userId, familyId);
      },
    );
  }
}

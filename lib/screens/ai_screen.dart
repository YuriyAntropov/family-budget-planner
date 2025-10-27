import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import '../models/transaction.dart';
import '../services/ai_service.dart';
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';

class AIScreen extends StatefulWidget {
  const AIScreen({super.key});

  @override
  _AIScreenState createState() => _AIScreenState();
}

class _AIScreenState extends State<AIScreen> with SingleTickerProviderStateMixin {
  bool _isLoading = false;
  bool _isChatLoading = false;
  String _aiResponse = '';
  final AIService _aiService = AIService(); // Line 297
  String _chatInput = '';
  List<Map<String, String>> _chatMessages = [];
  final TextEditingController _chatController = TextEditingController();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dbService = Provider.of<DbService>(context);
    final authService = Provider.of<AuthService>(context);
    final userId = authService.currentUser?.uid ?? '';
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aiAssistant)),
      body: FutureBuilder<String?>(
        future: dbService.getFamilyIdForUser(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final familyId = snapshot.data;
          if (familyId == null) {
            return Center(child: Text(l10n.familyIdError));
          }
          return FutureBuilder<List<Transaction>>(
            future: dbService.getTransactions(familyId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(l10n.insufficientData),
                );
              }

              final transactions = snapshot.data!;

              return Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(text: l10n.recommendations),
                      Tab(text: l10n.chat),
                    ],
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.financialAssistant,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(l10n.personalizedRecommendations),
                                      const SizedBox(height: 16),
                                      ElevatedButton(
                                        onPressed: _isLoading
                                            ? null
                                            : () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          final response = await _aiService.getFinancialAdvice(transactions);
                                          setState(() {
                                            _aiResponse = response;
                                            _isLoading = false;
                                          });
                                        },
                                        child: _isLoading
                                            ? const CircularProgressIndicator(color: Colors.white)
                                            : Text(l10n.getRecommendations),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              if (_aiResponse.isNotEmpty) ...[
                                const SizedBox(height: 24),
                                Card(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          l10n.recommendations,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(_aiResponse),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                              const SizedBox(height: 24),
                              Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n.recentTransactions,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: transactions.length > 5 ? 5 : transactions.length,
                                        itemBuilder: (context, index) {
                                          final transaction = transactions[index];
                                          return ListTile(
                                            title: Text(transaction.category),
                                            subtitle: Text('${l10n.amount}: ${transaction.amount?.toStringAsFixed(2)}'),
                                            leading: Icon(
                                              transaction.isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                                              color: transaction.isExpense ? Colors.red : Colors.green,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16.0),
                                itemCount: _chatMessages.length + (_isChatLoading ? 1 : 0),
                                itemBuilder: (context, index) {
                                  if (index == _chatMessages.length && _isChatLoading) {
                                    return Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              l10n.aiThinking,
                                              style: TextStyle(
                                                color: Theme.of(context).brightness == Brightness.dark
                                                    ? Colors.black
                                                    : Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                  final message = _chatMessages[index];
                                  final isUser = message['role'] == 'user';
                                  final isDarkMode = Theme.of(context).brightness == Brightness.dark;
                                  Color textColor = isDarkMode ? Colors.white : Colors.black87;
                                  Color bubbleColor = isUser
                                      ? Colors.blue[100]!
                                      : (isDarkMode ? Colors.grey[800]! : Colors.grey[200]!);

                                  if (isUser && !isDarkMode) {
                                    textColor = Colors.black87;
                                  } else if (!isUser && isDarkMode) {
                                    textColor = Colors.white;
                                  } else if (isUser && isDarkMode) {
                                    textColor = Colors.white;
                                    bubbleColor = Colors.blue[600]!;
                                  }

                                  return Align(
                                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(vertical: 4.0),
                                      padding: const EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        color: bubbleColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth: MediaQuery.of(context).size.width * 0.7,
                                      ),
                                      child: Text(
                                        message['content'] ?? '',
                                        style: TextStyle(
                                          color: textColor,
                                        ),
                                      ),
                                    ),
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
                                      controller: _chatController,
                                      decoration: InputDecoration(
                                        hintText: l10n.askFinances,
                                        border: const OutlineInputBorder(),
                                      ),
                                      onChanged: (value) {
                                        _chatInput = value;
                                      },
                                      onSubmitted: (value) async {
                                        if (!_isChatLoading && value.isNotEmpty) {
                                          setState(() {
                                            _chatMessages.add({
                                              'role': 'user',
                                              'content': value,
                                            });
                                            _chatInput = '';
                                            _isChatLoading = true;
                                          });

                                          _chatController.clear();

                                          try {
                                            final response = await _aiService.getChatResponse(value, transactions);

                                            if (mounted) {
                                              setState(() {
                                                _chatMessages.add({
                                                  'role': 'assistant',
                                                  'content': response,
                                                });
                                                _isChatLoading = false;
                                              });
                                            }
                                          } catch (e) {
                                            if (mounted) {
                                              setState(() {
                                                _isChatLoading = false;
                                              });
                                            }
                                          }
                                        }
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.send),
                                    onPressed: _isChatLoading
                                        ? null
                                        : () async {
                                      if (_chatInput.isEmpty) return;
                                      final userMessage = _chatInput;

                                      setState(() {
                                        _chatMessages.add({
                                          'role': 'user',
                                          'content': userMessage,
                                        });
                                        _chatInput = '';
                                        _isChatLoading = true;
                                      });

                                      _chatController.clear();

                                      try {
                                        final response = await _aiService.getChatResponse(userMessage, transactions);

                                        if (mounted) {
                                          setState(() {
                                            _chatMessages.add({
                                              'role': 'assistant',
                                              'content': response,
                                            });
                                            _isChatLoading = false;
                                          });
                                        }
                                      } catch (e) {
                                        if (mounted) {
                                          setState(() {
                                            _isChatLoading = false;
                                          });
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import '../services/auth_service.dart';
import '../models/transaction.dart' as model;
import '../l10n/app_localizations.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  _ExpensesScreenState createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  List<String> expenseCategories = [];

  void _showEditTransactionDialog(
      BuildContext context,
      model.Transaction transaction,
      DbService dbService,
      String userId,
      String familyId,
      ) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController amountController = TextEditingController(
      text: transaction.amount?.toString() ?? '',
    );
    final TextEditingController notesController = TextEditingController(
      text: transaction.notes ?? '',
    );

    DateTime selectedDate = transaction.date ?? DateTime.now();
    String selectedCategory = transaction.category;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.editExpense),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.amount,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: l10n.category,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        l10n.products,
                        l10n.transport,
                        l10n.entertainment,
                        l10n.utilities,
                        l10n.clothing,
                        l10n.other,
                      ].map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: notesController,
                      decoration: InputDecoration(
                        labelText: l10n.comment,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('${l10n.date}: '),
                        TextButton(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(selectedDate),
                              );
                              if (time != null) {
                                setState(() {
                                  selectedDate = DateTime(
                                    date.year,
                                    date.month,
                                    date.day,
                                    time.hour,
                                    time.minute,
                                  );
                                });
                              }
                            }
                          },
                          child: Text(
                            '${selectedDate.day}.${selectedDate.month}.${selectedDate.year} ${selectedDate.hour}:${selectedDate.minute.toString().padLeft(2, '0')}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.cancel),
                ),
                TextButton(
                  onPressed: () {
                    try {
                      final amount = double.parse(amountController.text);
                      dbService.updateTransaction(
                        transactionId: transaction.serverId!,
                        amount: amount,
                        category: selectedCategory,
                        date: selectedDate,
                        notes: notesController.text,
                        userId: userId,
                        familyId: familyId,
                        accountId: transaction.accountId!,
                        isExpense: transaction.isExpense,
                      );
                      Navigator.of(context).pop();
                      setState(() {});
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.invalidAmount)),
                      );
                    }
                  },
                  child: Text(l10n.save),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final dbService = Provider.of<DbService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.currentUser?.uid ?? '';

    final familyId = await dbService.getFamilyIdForUser(userId);
    if (familyId != null) {
      final categories = await dbService.getCategories(familyId, true);
      if (mounted) {
        setState(() {
          expenseCategories = categories.isNotEmpty ? categories :
          [l10n.products, l10n.transport, l10n.entertainment, l10n.utilities, l10n.clothing, l10n.other];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dbService = Provider.of<DbService>(context);
    final authService = Provider.of<AuthService>(context);
    final userId = authService.currentUser?.uid ?? '';

    return FutureBuilder<String?>(
      future: dbService.getFamilyIdForUser(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final familyId = snapshot.data;
        if (familyId == null) {
          return Center(child: Text(l10n.familyIdError));
        }
        return FutureBuilder<List<model.Transaction>>(
          future: dbService.getTransactions(familyId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text(l10n.noExpenses));
            }
            final expenses = snapshot.data!
                .where((transaction) => transaction.isExpense)
                .toList();
            if (expenses.isEmpty) {
              return Center(child: Text(l10n.noExpenses));
            }
            expenses.sort((a, b) => b.date!.compareTo(a.date!));

            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (context, index) {
                final transaction = expenses[index];
                return ListTile(
                  title: Text(transaction.category),
                  subtitle: Text(
                      '${l10n.amount}: ${transaction.amount?.toStringAsFixed(2)} • ${transaction.date != null ? _formatDate(transaction.date!) : ""}'),
                  leading: const Icon(Icons.money_off, color: Colors.red),
                  onTap: () {
                    _showEditTransactionDialog(context, transaction, dbService, userId, familyId);
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}

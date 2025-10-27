import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import '../services/auth_service.dart';
import '../utils/constants.dart';
import '../models/account.dart';

class DragDropWidget extends StatefulWidget {
  final List<String> categories;
  final Function(String, String, double, DateTime, String) onTransaction;
  final Function()? onTransactionComplete;
  final String familyId;

  const DragDropWidget({
    super.key,
    required this.categories,
    required this.onTransaction,
    required this.familyId,
    this.onTransactionComplete,
  });

  @override
  _DragDropWidgetState createState() => _DragDropWidgetState();
}

class _DragDropWidgetState extends State<DragDropWidget> {
  final TextEditingController _amountController = TextEditingController();

  Future<Account?> _showAccountSelectionDialog(BuildContext context, List<Account> accounts) async {
    return showDialog<Account>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Виберіть рахунок'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];
                return ListTile(
                  title: Text(account.name ?? 'Рахунок'),
                  subtitle: Text('${account.balance?.toStringAsFixed(2)} ${account.currency}'),
                  onTap: () {
                    Navigator.of(context).pop(account);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  Future<String?> _showCategorySelectionDialog(BuildContext context, List<String> categories) async {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Виберіть категорію'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category),
                  onTap: () {
                    Navigator.of(context).pop(category);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final dbService = Provider.of<DbService>(context);
    final authService = Provider.of<AuthService>(context);
    final userId = authService.currentUser?.uid ?? '';

    return Column(
      children: [
        SizedBox(
          height: 100,
          child: FutureBuilder<List<Account>>(
            future: dbService.getAccounts(widget.familyId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Text('Помилка: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('Немає рахунків'));
              }
              final accounts = snapshot.data!;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  final account = accounts[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Draggable<String>(
                      data: account.accountId ?? '',
                      feedback: Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppConstants.accentColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            account.name ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            account.name ?? '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      child: Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppConstants.accentColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            account.name ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      childWhenDragging: Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            account.name ?? '',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      child: Container(
                        width: 120,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppConstants.accentColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            account.name ?? '',
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1,
            ),
            itemCount: widget.categories.length,
            itemBuilder: (context, index) {
              final category = widget.categories[index];
              return DragTarget<String>(
                builder: (context, candidateData, rejectedData) {
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: candidateData.isNotEmpty
                          ? Colors.blue.withOpacity(0.5)
                          : AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        category,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
                onAcceptWithDetails: (details) {
                  final accountId = details.data;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) {
                      DateTime selectedDate = DateTime.now();
                      bool isNowSelected = true;
                      String comment = '';
                      return StatefulBuilder(
                        builder: (context, setModalState) {
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                              left: 16.0,
                              right: 16.0,
                              top: 16.0,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Рахунок → $category', style: const TextStyle(fontSize: 18)),

                                const SizedBox(height: 16),

                                TextField(
                                  controller: _amountController,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    labelText: 'Сума',
                                    border: OutlineInputBorder(),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                // для ком
                                TextField(
                                  decoration: const InputDecoration(
                                    labelText: 'Коментар',
                                    border: OutlineInputBorder(),
                                  ),
                                  onChanged: (value) {
                                    comment = value;
                                  },
                                ),

                                const SizedBox(height: 16),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    // "Зараз"
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.access_time),
                                      label: const Text('Зараз'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: isNowSelected ? Colors.green : null,
                                      ),
                                      onPressed: () {
                                        setModalState(() {
                                          selectedDate = DateTime.now();
                                          isNowSelected = true;
                                        });
                                      },
                                    ),
                                    ElevatedButton.icon(
                                      icon: const Icon(Icons.calendar_today),
                                      label: Text(isNowSelected ? 'Вибрати дату' :
                                      '${selectedDate.day}.${selectedDate.month}.${selectedDate.year} ${selectedDate.hour}:${selectedDate.minute.toString().padLeft(2, '0')}'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: !isNowSelected ? Colors.blue : null,
                                      ),
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
                                            setModalState(() {
                                              selectedDate = DateTime(
                                                date.year,
                                                date.month,
                                                date.day,
                                                time.hour,
                                                time.minute,
                                              );
                                              isNowSelected = false;
                                            });
                                          }
                                        }
                                      },
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 16),

                                ElevatedButton(
                                  onPressed: () {
                                    if (_amountController.text.isNotEmpty) {
                                      try {
                                        final amount = double.parse(_amountController.text);
                                        widget.onTransaction(
                                          accountId,
                                          category,
                                          amount,
                                          selectedDate,
                                          comment,
                                        );
                                        _amountController.clear();
                                        Navigator.pop(context);
                                        if (widget.onTransactionComplete != null) {
                                          widget.onTransactionComplete!();
                                        }
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Некоректна сума')),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text('Додати витрату'),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
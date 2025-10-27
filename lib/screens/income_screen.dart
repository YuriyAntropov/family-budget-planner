import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import '../services/auth_service.dart';
import '../models/account.dart';
import '../models/transaction.dart' as model;
import '../utils/constants.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import '../services/user_provider.dart';
import '../l10n/app_localizations.dart';
import 'package:animations/animations.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  _IncomeScreenState createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> with TickerProviderStateMixin {

  final TextEditingController _amountController = TextEditingController();
  bool _isEditMode = false;
  List<String> incomeCategories = [];
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _handleLongPress() {
    setState(() {
      _isEditMode = true;
    });
    _shakeController.repeat(reverse: true);
  }

  void _exitEditMode() {
    setState(() {
      _isEditMode = false;
    });
    _shakeController.stop();
    _shakeController.reset();
  }

  void _showAddAccountDialog(BuildContext context, String userId, String familyId, DbService dbService) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController balanceController = TextEditingController();
    String selectedCurrency = 'UAH';
    String accountOwner = 'self';

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isAdminUser = userProvider.isAdmin;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.addAccount),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: l10n.accountName,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: balanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.initialBalance,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCurrency,
                      decoration: InputDecoration(
                        labelText: l10n.currency,
                        border: const OutlineInputBorder(),
                      ),
                      items: ['UAH', 'USD', 'EUR', 'PLN'].map((currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Text(currency),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCurrency = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    Text('${l10n.accountOwner}:'),
                    RadioListTile<String>(
                      title: Text(l10n.personal),
                      value: 'self',
                      groupValue: accountOwner,
                      onChanged: (value) {
                        setState(() {
                          accountOwner = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Text(l10n.familyAccount),
                      value: 'family',
                      groupValue: accountOwner,
                      onChanged: (value) {
                        setState(() {
                          accountOwner = value!;
                        });
                      },
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
                    if (nameController.text.isNotEmpty && balanceController.text.isNotEmpty) {
                      try {
                        final balance = double.parse(balanceController.text);
                        dbService.addAccount(
                          name: nameController.text,
                          balance: balance,
                          currency: selectedCurrency,
                          userId: accountOwner == 'family' ? '' : userId,
                          familyId: familyId,
                          isShared: accountOwner == 'family',
                        );
                        Navigator.of(context).pop();
                        if (mounted) {
                          setState(() {});
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.invalidBalance)),
                        );
                      }
                    }
                  },
                  child: Text(l10n.add),
                ),
              ],
            );
          },
        );
      },
    );
  }

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
    String selectedCurrency = transaction.currency ?? 'UAH';
    DateTime selectedDate = transaction.date ?? DateTime.now();
    String selectedCategory = transaction.category;
    String selectedAccountId = transaction.accountId ?? '';

    final validCategories = [l10n.salary, l10n.gifts, l10n.dividends, l10n.partTime, l10n.sale, l10n.other];
    if (!validCategories.contains(selectedCategory)) {
      selectedCategory = l10n.other;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.editIncome),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<Account?>(
                      future: dbService.getAccountById(transaction.accountId ?? ''),
                      builder: (context, snapshot) {
                        final accountName = snapshot.data?.name ?? l10n.unknownAccount;
                        return Text('${l10n.currentAccount}: $accountName', style: const TextStyle(fontWeight: FontWeight.bold));
                      },
                    ),
                    const SizedBox(height: 16),
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
                      value: selectedCurrency,
                      decoration: InputDecoration(
                        labelText: l10n.currency,
                        border: const OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'UAH', child: Text('UAH')),
                        DropdownMenuItem(value: 'USD', child: Text('USD')),
                        DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedCurrency = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory,
                      decoration: InputDecoration(
                        labelText: l10n.category,
                        border: const OutlineInputBorder(),
                      ),
                      items: [
                        l10n.salary,
                        l10n.gifts,
                        l10n.dividends,
                        l10n.partTime,
                        l10n.sale,
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
                    FutureBuilder<List<Account>>(
                      future: dbService.getAccounts(familyId),
                      builder: (context, accountsSnapshot) {
                        if (!accountsSnapshot.hasData) {
                          return const CircularProgressIndicator();
                        }

                        final accounts = accountsSnapshot.data!;
                        bool accountExists = accounts.any((account) => account.accountId == selectedAccountId);

                        if (!accountExists && accounts.isNotEmpty) {
                          selectedAccountId = accounts[0].accountId ?? '';
                        }
                        return DropdownButtonFormField<String>(
                          value: accountExists ? selectedAccountId : null,
                          decoration: InputDecoration(
                            labelText: l10n.account,
                            border: const OutlineInputBorder(),
                          ),
                          items: accounts.map((account) {
                            return DropdownMenuItem<String>(
                              value: account.accountId,
                              child: Text(account.name ?? l10n.account),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                selectedAccountId = value;
                              });
                            }
                          },
                        );
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
                        accountId: selectedAccountId,
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

  void _removeCategory(String category, String familyId, DbService dbService) async {
    setState(() {
      incomeCategories.remove(category);
    });
    await dbService.saveCategories(familyId, incomeCategories, false);
  }

  Widget buildEditModeOverlay() {
    return Positioned.fill(
      child: IgnorePointer(
        ignoring: true,
        child: GestureDetector(
          onTap: _exitEditMode,
          behavior: HitTestBehavior.opaque,
          child: Container(
            color: Colors.transparent,
          ),
        ),
      ),
    );
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
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final familyId = snapshot.data;
        if (familyId == null) {
          return Scaffold(
            body: Center(child: Text(l10n.familyIdError)),
          );
        }

        return FutureBuilder<List<String>>(
          future: dbService.getCategories(familyId, false),
          builder: (context, categoriesSnapshot) {
            if (categoriesSnapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }

            if (categoriesSnapshot.hasData && categoriesSnapshot.data!.isNotEmpty) {
              incomeCategories = categoriesSnapshot.data!;
            } else {
              incomeCategories = [l10n.salary, l10n.gifts, l10n.dividends, l10n.partTime, l10n.sale, l10n.other];
            }

            return Scaffold(
              floatingActionButton: _isEditMode
                  ? FloatingActionButton(
                onPressed: _exitEditMode,
                backgroundColor: Colors.green,
                child: const Icon(Icons.check),
              )
                  : null,
              floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
              body: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      if (familyId != null) {
                        await dbService.syncAllData(familyId);
                        setState(() {});
                      }
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: Builder(
                              builder: (context) {
                                final int totalItems = incomeCategories.length + 1;

                                int crossAxisCount = 3;
                                if (totalItems > 18) {
                                  crossAxisCount = 6;
                                } else if (totalItems > 12) {
                                  crossAxisCount = 5;
                                } else if (totalItems > 6) {
                                  crossAxisCount = 4;
                                }

                                if (_isEditMode) {
                                  return ReorderableGridView.count(
                                    crossAxisCount: crossAxisCount,
                                    childAspectRatio: 1.5,
                                    physics: const NeverScrollableScrollPhysics(),
                                    footer: const [],
                                    children: List.generate(totalItems, (index) {
                                      if (index < incomeCategories.length) {
                                        final category = incomeCategories[index];
                                        return Stack(
                                          key: ValueKey(category),
                                          children: [
                                            AnimatedBuilder(
                                              animation: _shakeController,
                                              builder: (context, child) {
                                                return Transform.translate(
                                                  offset: _isEditMode
                                                      ? Offset(
                                                      (_shakeController.value - 0.5) * 4 * (index % 2 == 0 ? 1 : -1),
                                                      0
                                                  )
                                                      : Offset.zero,
                                                  child: Container(
                                                    margin: const EdgeInsets.all(4.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors.green,
                                                      borderRadius: BorderRadius.circular(10),
                                                      border: Border.all(color: Colors.white, width: 1),
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        category,
                                                        textAlign: TextAlign.center,
                                                        style: const TextStyle(color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),

                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: GestureDetector(
                                                onTap: () => _removeCategory(category, familyId, dbService),
                                                child: Container(
                                                  padding: const EdgeInsets.all(2),
                                                  decoration: const BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                    size: 16,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      } else {
                                        return GestureDetector(
                                          key: const ValueKey('add_category'),
                                          onTap: () {
                                            _showAddCategoryDialog(context);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: Colors.green, width: 2),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.add,
                                                color: Colors.green,
                                                size: 30,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }),
                                    onReorder: (oldIndex, newIndex) {
                                      setState(() {
                                        if (oldIndex < newIndex) {
                                          newIndex -= 1;
                                        }
                                        if (oldIndex < incomeCategories.length && newIndex < incomeCategories.length) {
                                          final item = incomeCategories.removeAt(oldIndex);
                                          incomeCategories.insert(newIndex, item);
                                        }
                                      });
                                    },
                                  );
                                } else {
                                  return GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: 1.5,
                                    ),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: totalItems,
                                    itemBuilder: (context, index) {
                                      if (index < incomeCategories.length) {
                                        final category = incomeCategories[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/stats',
                                                arguments: {
                                                  'selectedCategory': category,
                                                  'showExpenses': false,
                                                },
                                              );
                                            },
                                            onLongPress: _handleLongPress,
                                            child: Stack(
                                              children: [
                                                AnimatedBuilder(
                                                  animation: _shakeController,
                                                  builder: (context, child) {
                                                    return Transform.rotate(
                                                      angle: _isEditMode
                                                          ? ((_shakeController.value - 0.5) * 0.13) * (index % 2 == 0 ? 1 : -1)
                                                          : 0,
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius: BorderRadius.circular(10),
                                                          border: Border.all(color: Colors.white, width: 1),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            category,
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(color: Colors.white),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      } else {
                                        final userProvider = Provider.of<UserProvider>(context, listen: false);
                                        if (!userProvider.isChild) {
                                          return Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                _showAddCategoryDialog(context);
                                              },
                                              onLongPress: _handleLongPress,
                                              child: Container(
                                                margin: const EdgeInsets.all(4.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: Colors.green, width: 2),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: Colors.green,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      }
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          const Icon(
                            Icons.arrow_downward,
                            size: 40,
                            color: Colors.green,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            child: FutureBuilder<List<Account>>(
                              future: dbService.getAccounts(familyId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }

                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Center(child: Text(l10n.noAccounts));
                                }

                                final accounts = snapshot.data!;
                                final int totalItems = accounts.length;

                                int crossAxisCount = 3;
                                if (totalItems > 18) {
                                  crossAxisCount = 6;
                                } else if (totalItems > 12) {
                                  crossAxisCount = 5;
                                } else if (totalItems > 6) {
                                  crossAxisCount = 4;
                                }
                                if (_isEditMode) {
                                  return ReorderableGridView.count(
                                    crossAxisCount: crossAxisCount,
                                    childAspectRatio: 1.5,
                                    physics: const NeverScrollableScrollPhysics(),
                                    footer: const [],
                                    children: List.generate(totalItems, (index) {
                                      final account = accounts[index];
                                      return Stack(
                                        key: ValueKey(account.accountId),
                                        children: [
                                          AnimatedBuilder(
                                            animation: _shakeController,
                                            builder: (context, child) {
                                              return Transform.rotate(
                                                angle: _isEditMode
                                                    ? ((_shakeController.value - 0.5) * 0.13) * (index % 2 == 0 ? 1 : -1)
                                                    : 0,
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
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
                                              );
                                            },
                                          ),
                                          Positioned(
                                            top: 0,
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: () {
                                                dbService.deleteAccount(account.accountId!);
                                                setState(() {});
                                              },
                                              child: Container(
                                                padding: const EdgeInsets.all(2),
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  color: Colors.red,
                                                  size: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                    onReorder: (oldIndex, newIndex) {
                                      setState(() {
                                        if (oldIndex < newIndex) {
                                          newIndex -= 1;
                                        }
                                        final item = accounts.removeAt(oldIndex);
                                        accounts.insert(newIndex, item);
                                      });
                                    },
                                  );
                                } else {
                                  return GridView.builder(
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: crossAxisCount,
                                      childAspectRatio: 1.5,
                                    ),
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: totalItems,
                                    itemBuilder: (context, index) {
                                      final account = accounts[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            _showIncomeDialog(context, account.accountId ?? '', '', familyId, userId, dbService);
                                          },
                                          onLongPress: _handleLongPress,
                                          child: Stack(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: AppConstants.accentColor,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    account.name ?? '',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }
                              },
                            ),
                          ),
                          FutureBuilder<List<model.Transaction>>(
                            future: dbService.getTransactions(familyId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text(l10n.noIncomes));
                              }

                              final incomes = snapshot.data!
                                  .where((transaction) => !transaction.isExpense)
                                  .toList();

                              if (incomes.isEmpty) {
                                return Center(child: Text(l10n.noIncomes));
                              }

                              incomes.sort((a, b) => b.date!.compareTo(a.date!));

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: incomes.length,
                                itemBuilder: (context, index) {
                                  final transaction = incomes[index];
                                  return FutureBuilder<Account?>(
                                    future: dbService.getAccountById(transaction.accountId ?? ''),
                                    builder: (context, accountSnapshot) {
                                      final accountName = accountSnapshot.data?.name ?? l10n.unknownAccount;

                                      return Dismissible(
                                        key: Key(transaction.serverId ?? ''),
                                        background: Container(
                                          color: Colors.red,
                                          alignment: Alignment.centerRight,
                                          padding: const EdgeInsets.only(right: 20.0),
                                          child: const Icon(Icons.delete, color: Colors.white),
                                        ),
                                        direction: DismissDirection.endToStart,
                                        confirmDismiss: (direction) async {
                                          return await showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text(l10n.confirmation),
                                                content: Text(l10n.deleteTransactionConfirm),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(false),
                                                    child: Text(l10n.cancel),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.of(context).pop(true),
                                                    child: Text(l10n.delete),
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        onDismissed: (direction) async {
                                          final success = await dbService.deleteTransaction(transaction.serverId!);
                                          if (success) {
                                            setState(() {});
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text(l10n.transactionDeleted)),
                                            );
                                          }
                                        },
                                        child: ListTile(
                                          title: Text(transaction.category),
                                          subtitle: Text(
                                              '${l10n.amount}: ${transaction.amount?.toStringAsFixed(2)} • ${transaction.date != null ? _formatDate(transaction.date!) : ""}\n${l10n.account}: $accountName'),
                                          leading: const Icon(Icons.add_circle, color: Colors.green),
                                          onTap: () {
                                            _showEditTransactionDialog(context, transaction, dbService, userId, familyId);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_isEditMode) buildEditModeOverlay(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController nameController = TextEditingController();
    final dbService = Provider.of<DbService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.currentUser?.uid ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.addCategory),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: l10n.categoryName,
              border: const OutlineInputBorder(),
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
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  final familyId = await dbService.getFamilyIdForUser(userId);
                  if (familyId != null) {
                    incomeCategories.add(nameController.text);
                    await dbService.saveCategories(familyId, incomeCategories, false);
                    if (mounted) {
                      setState(() {});
                    }
                  }
                  Navigator.of(context).pop();
                }
              },
              child: Text(l10n.add),
            ),
          ],
        );
      },
    );
  }

  void _showIncomeDialog(BuildContext context, String accountId, String category, String familyId, String userId, DbService dbService) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController amountController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    bool isNowSelected = true;
    String comment = '';
    String selectedCurrency = 'UAH';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
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
                  FutureBuilder<Account?>(
                    future: dbService.getAccountById(accountId),
                    builder: (context, snapshot) {
                      final accountName = snapshot.data?.name ?? l10n.account;
                      return Text('$category → $accountName', style: const TextStyle(fontSize: 18));
                    },
                  ),
                  const SizedBox(height: 16),
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
                    value: selectedCurrency,
                    decoration: InputDecoration(
                      labelText: l10n.currency,
                      border: const OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'UAH', child: Text('UAH')),
                      DropdownMenuItem(value: 'USD', child: Text('USD')),
                      DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        setModalState(() {
                          selectedCurrency = value;
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    decoration: InputDecoration(
                      labelText: l10n.comment,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      comment = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.access_time),
                        label: Text(l10n.now),
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
                        label: Text(isNowSelected ? l10n.selectDate :
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
                      if (amountController.text.isNotEmpty) {
                        try {
                          final amount = double.parse(amountController.text);
                          dbService.addTransaction(
                            amount: amount,
                            category: category,
                            isExpense: false,
                            accountId: accountId,
                            userId: userId,
                            familyId: familyId,
                            date: selectedDate,
                            notes: comment,
                          );
                          amountController.clear();
                          Navigator.pop(context);
                          setState(() {});
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.invalidAmount)),
                          );
                        }
                      }
                    },
                    child: Text(l10n.addIncome),
                  ),
                ],
              ),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import '../models/transaction.dart';
import '../services/auth_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/currency_service.dart';
import '../services/user_provider.dart';
import '../l10n/app_localizations.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  _StatsScreenState createState() => _StatsScreenState();
}

enum HistoryType { all, expenses, income }

class _StatsScreenState extends State<StatsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String _selectedAccountId = 'all';
  bool _sortByDate = true;
  bool _sortAscending = false;
  bool? _showExpenses = true;
  String? _selectedCategory;
  String preferredCurrency = 'UAH';
  String _selectedUserId = 'all';

  String _formatAmount(double amount, String currency) {
    final currencyService = Provider.of<CurrencyService>(context, listen: false);
    final convertedAmount = currencyService.convert(amount, 'UAH', currency);
    return '${convertedAmount.toStringAsFixed(2)} $currency';
  }

  HistoryType _historyType = HistoryType.expenses;
  final GlobalKey<_TransactionListState> _transactionListKey = GlobalKey<_TransactionListState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        if (args.containsKey('selectedAccountId')) {
          setState(() {
            _selectedAccountId = args['selectedAccountId'];
          });
        }
        if (args.containsKey('selectedCategory')) {
          setState(() {
            _selectedCategory = args['selectedCategory'];
            _historyType = _showExpenses == true ? HistoryType.expenses : HistoryType.income;
            _showExpenses = args['showExpenses'] == true;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context);
    if (userProvider.isChild) {
      return Scaffold(
        appBar: AppBar(
          title: Text(l10n.statistics),
        ),
        body: Center(
          child: Text(l10n.noAccessToStats),
        ),
      );
    }
    final dbService = Provider.of<DbService>(context);
    final authService = Provider.of<AuthService>(context);
    final userId = authService.currentUser?.uid ?? '';

    if (_showExpenses == false) {
      _historyType = HistoryType.income;
    }
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
        return Scaffold(
          appBar: AppBar(
            title: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: Text(l10n.expenseStats),
                          onTap: () {
                            setState(() {
                              _showExpenses = true;
                              _selectedCategory = null;
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ListTile(
                          title: Text(l10n.generalStats),
                          onTap: () {
                            setState(() {
                              _showExpenses = null;
                              _selectedCategory = null;
                              Navigator.pop(context);
                            });
                          },
                        ),
                        ListTile(
                          title: Text(l10n.incomeStats),
                          onTap: () {
                            setState(() {
                              _showExpenses = false;
                              _selectedCategory = null;
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              child: Row(
                children: [
                  Text(
                    _showExpenses == null
                        ? l10n.generalStats
                        : (_showExpenses! ? l10n.expenseStats : l10n.incomeStats),
                  ),
                  const Icon(Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _startDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _startDate = date;
                            });
                          }
                        },
                        child: Text(DateFormat('dd.MM.yyyy').format(_startDate)),
                      ),
                      const Text('—'),
                      TextButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: _endDate,
                            firstDate: _startDate,
                            lastDate: DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _endDate = date;
                            });
                          }
                        },
                        child: Text(DateFormat('dd.MM.yyyy').format(_endDate)),
                      ),
                    ],
                  ),
                ),
                if (Provider.of<UserProvider>(context).isAdmin)
                  FutureBuilder(
                    future: dbService.getFamilyMembers(familyId),
                    builder: (context, membersSnapshot) {
                      if (!membersSnapshot.hasData) {
                        return const SizedBox();
                      }

                      final members = membersSnapshot.data!;

                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedUserId,
                          items: [
                            DropdownMenuItem(
                              value: 'all',
                              child: Text(l10n.wholeFamily),
                            ),
                            ...members.map((member) => DropdownMenuItem(
                              value: member['userId'],
                              child: Text(member['email'] ?? l10n.user),
                            )),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() {
                                _selectedUserId = value;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
                FutureBuilder(
                  future: dbService.getAccounts(familyId),
                  builder: (context, accountsSnapshot) {
                    if (!accountsSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final accounts = accountsSnapshot.data!;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedAccountId,
                        items: [
                          DropdownMenuItem(
                            value: 'all',
                            child: Text(l10n.allAccounts),
                          ),
                          ...accounts.map((account) => DropdownMenuItem(
                            value: account.accountId,
                            child: Text(account.name ?? l10n.account),
                          )),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedAccountId = value;
                            });
                          }
                        },
                      ),
                    );
                  },
                ),
                FutureBuilder<List<Transaction>>(
                  future: dbService.getTransactions(familyId),
                  builder: (context, transactionsSnapshot) {
                    if (!transactionsSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final allTransactions = transactionsSnapshot.data!;
                    final filteredTransactions = allTransactions.where((t) {
                      final isInDateRange = t.date != null &&
                          t.date!.isAfter(_startDate) &&
                          t.date!.isBefore(_endDate.add(const Duration(days: 1)));
                      final isCorrectAccount =
                          _selectedAccountId == 'all' || t.accountId == _selectedAccountId;
                      final isCorrectType = _showExpenses == null
                          ? true
                          : _showExpenses!
                          ? t.isExpense
                          : !t.isExpense;
                      final isCorrectCategory =
                          _selectedCategory == null || t.category == _selectedCategory;
                      final isCorrectUser =
                          _selectedUserId == 'all' || t.userId == _selectedUserId;
                      return isInDateRange &&
                          isCorrectAccount &&
                          isCorrectType &&
                          isCorrectCategory &&
                          isCorrectUser;
                    }).toList();
                    Map<String, double> expensesByCategory = {};
                    for (var t in filteredTransactions) {
                      if (t.category.isNotEmpty) {
                        expensesByCategory[t.category] =
                            (expensesByCategory[t.category] ?? 0) + (t.amount ?? 0);
                      }
                    }
                    List<MapEntry<String, double>> sortedCategories =
                    expensesByCategory.entries.toList()
                      ..sort((a, b) => b.value.compareTo(a.value));

                    final totalExpenses =
                    sortedCategories.fold(0.0, (sum, entry) => sum + entry.value);
                    final daysDifference = _endDate.difference(_startDate).inDays + 1;
                    final averageDailyExpense = totalExpenses / daysDifference;

                    double totalIncome = 0;
                    double totalExpense = 0;
                    double? balance;

                    totalIncome = allTransactions
                        .where((t) => !t.isExpense)
                        .fold(0.0, (sum, t) => sum + (t.amount ?? 0));
                    totalExpense = allTransactions
                        .where((t) => t.isExpense)
                        .fold(0.0, (sum, t) => sum + (t.amount ?? 0));
                    balance = totalIncome - totalExpense;

                    final colors = [
                      Colors.blue,
                      Colors.green,
                      Colors.red,
                      Colors.orange,
                      Colors.purple,
                      Colors.teal,
                      Colors.pink,
                      Colors.amber,
                      Colors.indigo,
                      Colors.cyan
                    ];

                    List<PieChartSectionData> sections = [];
                    for (int i = 0; i < sortedCategories.length; i++) {
                      final category = sortedCategories[i];
                      final percentage = totalExpenses > 0 ? category.value / totalExpenses : 0;
                      final showTitle = percentage > 0.08;

                      sections.add(
                        PieChartSectionData(
                          color: colors[i % colors.length],
                          value: category.value,
                          title: showTitle ? category.key : '',
                          radius: 100,
                          titleStyle: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (_showExpenses == null) ...[
                                      Text(
                                        '${l10n.totalEarned}: ${_formatAmount(totalIncome, preferredCurrency)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        '${l10n.totalSpent}: ${_formatAmount(totalExpense, preferredCurrency)}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red,
                                        ),
                                      ),
                                      Text(
                                        '${l10n.totalBalance}: ${_formatAmount(balance!, preferredCurrency)}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: balance >= 0 ? Colors.green : Colors.red,
                                        ),
                                      ),
                                    ] else
                                      Text(
                                        '${l10n.total} ${_showExpenses! ? l10n.spent : l10n.received}: ${_formatAmount(totalExpenses, preferredCurrency)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    Text(
                                      '${l10n.averagePerDay}: ${_formatAmount(averageDailyExpense, preferredCurrency)}',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              DropdownButton<String>(
                                value: preferredCurrency,
                                items: const [
                                  DropdownMenuItem(value: 'UAH', child: Text('UAH')),
                                  DropdownMenuItem(value: 'USD', child: Text('USD')),
                                  DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                                ],
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      preferredCurrency = value;
                                    });
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                        if (sections.isNotEmpty)
                          SizedBox(
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                sections: sections,
                                centerSpaceRadius: 0,
                                sectionsSpace: 2,
                              ),
                            ),
                          )
                        else
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(l10n.noDataToDisplay),
                            ),
                          ),
                        ...sortedCategories
                            .where((entry) => totalExpenses > 0 && entry.value / totalExpenses >= 0.01)
                            .map((entry) {
                          final percentage = totalExpenses > 0 ? entry.value / totalExpenses * 100 : 0;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = entry.key;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(entry.key),
                                      Text(
                                        '${percentage.toStringAsFixed(1)}% (${entry.value.toStringAsFixed(2)} ${preferredCurrency})',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  LinearProgressIndicator(
                                    value: entry == sortedCategories.first
                                        ? 1.0
                                        : entry.value / sortedCategories.first.value,
                                    backgroundColor: Colors.grey[300],
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      colors[sortedCategories.indexOf(entry) % colors.length],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                        const Divider(thickness: 2),
                        _buildHistorySelector(),
                        _TransactionList(
                          key: _transactionListKey,
                          transactions: allTransactions,
                          startDate: _startDate,
                          endDate: _endDate,
                          selectedAccountId: _selectedAccountId,
                          sortByDate: _sortByDate,
                          sortAscending: _sortAscending,
                          historyType: _historyType,
                          familyId: familyId,
                          selectedCategory: _selectedCategory,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHistorySelector() {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(l10n.generalStats),
                      onTap: () {
                        setState(() {
                          _historyType = HistoryType.all;
                          _selectedCategory = null;
                          Navigator.pop(context);
                        });
                      },
                    ),
                    ListTile(
                      title: Text(l10n.expenseHistory),
                      onTap: () {
                        setState(() {
                          _historyType = HistoryType.expenses;
                          _selectedCategory = null;
                          Navigator.pop(context);
                        });
                      },
                    ),
                    ListTile(
                      title: Text(l10n.incomeHistory),
                      onTap: () {
                        setState(() {
                          _historyType = HistoryType.income;
                          _selectedCategory = null;
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                );
              },
            );
          },
          child: Row(
            children: [
              Text(
                _historyType == HistoryType.all
                    ? l10n.transactionHistory
                    : _historyType == HistoryType.expenses
                    ? l10n.expenseHistory
                    : l10n.incomeHistory,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: _sortByDate ? Colors.blue : Colors.grey,
                  ),
                  if (_sortByDate)
                    Icon(
                      _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.blue,
                      size: 14,
                    ),
                ],
              ),
              onPressed: () {
                if (_sortByDate) {
                  setState(() {
                    _sortAscending = !_sortAscending;
                  });
                  _transactionListKey.currentState?.updateSorting(_sortAscending);
                } else {
                  setState(() {
                    _sortByDate = true;
                    _sortAscending = false;
                  });
                  _transactionListKey.currentState?.updateSorting(_sortAscending);
                }
              },
            ),
            IconButton(
              icon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.attach_money,
                    color: !_sortByDate ? Colors.blue : Colors.grey,
                  ),
                  if (!_sortByDate)
                    Icon(
                      _sortAscending ? Icons.arrow_upward : Icons.arrow_downward,
                      color: Colors.blue,
                      size: 14,
                    ),
                ],
              ),
              onPressed: () {
                _sortTransactions();
              },
            ),
          ],
        ),
      ],
    );
  }

  void _sortTransactions() {
    _transactionListKey.currentState?.updateSorting(!_sortAscending);
    setState(() {
      _sortAscending = !_sortAscending;
      _sortByDate = false;
    });
  }
}

class _TransactionList extends StatefulWidget {
  final List<Transaction> transactions;
  final DateTime startDate;
  final DateTime endDate;
  final String selectedAccountId;
  final bool sortByDate;
  final bool sortAscending;
  final HistoryType historyType;
  final String familyId;
  final String? selectedCategory;

  const _TransactionList({
    super.key,
    required this.transactions,
    required this.startDate,
    required this.endDate,
    required this.selectedAccountId,
    required this.sortByDate,
    required this.sortAscending,
    required this.historyType,
    required this.familyId,
    this.selectedCategory,
  });

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<_TransactionList> {
  void updateSorting(bool ascending) {
    setState(() {});
  }

  List<Transaction> _getFilteredTransactions() {
    final filtered = widget.transactions.where((t) {
      final isInDateRange = t.date != null &&
          t.date!.isAfter(widget.startDate) &&
          t.date!.isBefore(widget.endDate.add(const Duration(days: 1)));
      final isCorrectAccount =
          widget.selectedAccountId == 'all' || t.accountId == widget.selectedAccountId;
      final isCorrectType = widget.historyType == HistoryType.all
          ? true
          : widget.historyType == HistoryType.expenses
          ? t.isExpense
          : !t.isExpense;
      final isCorrectCategory = widget.selectedCategory == null || t.category == widget.selectedCategory;
      final selectedUserId = Provider.of<UserProvider>(context, listen: false).selectedUserId ?? 'all';
      final isCorrectUser = selectedUserId == 'all' || t.userId == selectedUserId;

      return isInDateRange && isCorrectAccount && isCorrectType && isCorrectCategory && isCorrectUser;
    }).toList();
    if (widget.sortByDate) {
      if (widget.sortAscending) {
        filtered.sort((a, b) => (a.date ?? DateTime.now()).compareTo(b.date ?? DateTime.now()));
      } else {
        filtered.sort((a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));
      }
    } else {
      filtered.sort((a, b) {
        final comparison = (b.amount ?? 0).compareTo(a.amount ?? 0);
        return widget.sortAscending ? -comparison : comparison;
      });
    }
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dbService = Provider.of<DbService>(context);
    final transactions = _getFilteredTransactions();

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return FutureBuilder(
          future: dbService.getUserById(transaction.userId ?? ''),
          builder: (context, userSnapshot) {
            final userData = userSnapshot.data as Map<String, dynamic>?;
            final userName = userData?['name'] ?? l10n.unknownUser;

            return FutureBuilder(
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
                  onDismissed: (direction) {
                    dbService.deleteTransaction(transaction.serverId!);
                    setState(() {
                      transactions.remove(transaction);
                    });
                  },
                  child: ListTile(
                    title: Text(transaction.category),
                    subtitle: Text(
                      '${l10n.amount}: ${transaction.amount?.toStringAsFixed(2)} • ' +
                          '${transaction.date != null ? DateFormat('dd.MM.yyyy').format(transaction.date!) : ""}\n' +
                          '${l10n.account}: $accountName • ${l10n.user}: $userName',
                    ),
                    leading: Icon(
                      transaction.isExpense ? Icons.money_off : Icons.add_circle,
                      color: transaction.isExpense ? Colors.red : Colors.green,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

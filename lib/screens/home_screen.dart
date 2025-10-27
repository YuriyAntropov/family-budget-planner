import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../widgets/budget_circle.dart';
import '../services/user_provider.dart';
import 'accounts_screen.dart';
import 'income_screen.dart';
import '../models/account.dart';
import '../models/transaction.dart' as model_transaction;
import '../utils/constants.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import 'package:restart_app/restart_app.dart';
import 'package:animations/animations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isMenuOpen = false;
  final List<Widget> _widgetOptions = [
    const _HomeContent(),
    const IncomeScreen(),
    const AccountsScreen(),
  ];

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    final l10n = AppLocalizations.of(context)!;
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (index == 1 && !userProvider.canAddIncome()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noPermissionIncome)),
      );
      return;
    }
    setState(() {
      _selectedIndex = index;
      _isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authService = Provider.of<AuthService>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final currentUser = authService.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            Text(l10n.welcome(userProvider.displayName ?? "user")),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authService.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),
          Positioned(
            right: 16,
            bottom: 16,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isMenuOpen)
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: FloatingActionButton(
                        heroTag: 'ai',
                        backgroundColor: Colors.purple,
                        onPressed: () {
                          Navigator.pushNamed(context, '/ai');
                          setState(() {
                            _isMenuOpen = false;
                          });
                        },
                        child: const Icon(Icons.psychology),
                      ),
                    ),
                  ),
                if (_isMenuOpen)
                  AnimatedOpacity(
                    opacity: 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: FloatingActionButton(
                        heroTag: 'chat',
                        backgroundColor: Colors.green,
                        onPressed: () {
                          Navigator.pushNamed(context, '/chat');
                          setState(() {
                            _isMenuOpen = false;
                          });
                        },
                        child: const Icon(Icons.chat),
                      ),
                    ),
                  ),
                Opacity(
                  opacity: 0.7,
                  child: FloatingActionButton(
                    heroTag: 'menu',
                    onPressed: () {
                      setState(() {
                        _isMenuOpen = !_isMenuOpen;
                      });
                    },
                    child: Icon(_isMenuOpen ? Icons.close : Icons.menu),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: l10n.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.add_circle),
            label: l10n.income,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet),
            label: l10n.accounts,
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          final l10n = AppLocalizations.of(context)!;
          if (index == 1 && !userProvider.canAddIncome()) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.noPermissionIncome)),
            );
            return;
          }
          _onItemTapped(index);
        },
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class _HomeContent extends StatefulWidget {
  const _HomeContent();

  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<_HomeContent> with TickerProviderStateMixin {
  bool _syncStarted = false;
  bool _isEditMode = false;
  String selectedAccountId = '';
  final GlobalKey<BudgetCircleState> _budgetCircleKey = GlobalKey<BudgetCircleState>();
  List<String> categories = [];
  bool _showRestartButton = false;
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _checkDataLoaded();
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

  Future<void> _checkDataLoaded() async {
    await Future.delayed(const Duration(seconds: 3));

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final dbService = Provider.of<DbService>(context, listen: false);
    final authService = Provider.of<AuthService>(context, listen: false);
    final userId = authService.currentUser?.uid ?? '';

    if (userId.isNotEmpty) {
      final familyId = await dbService.getFamilyIdForUser(userId);
      if (familyId != null) {
        final accounts = await dbService.getAllAccountsForUser(familyId, userId);

        // загрузились ли данные
        bool dataNotLoaded = userProvider.displayName == null ||
            userProvider.displayName == "user" ||
            accounts.isEmpty;

        if (dataNotLoaded && mounted) {
          setState(() {
            _showRestartButton = true;
          });
        }
      }
    }
  }

  void _restartApp() {
    Restart.restartApp();
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
                        setState(() {});
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

  void _refreshUI() {
    setState(() {});
    _budgetCircleKey.currentState?.refresh();
  }

  void _removeCategory(String category, String familyId, DbService dbService) async {
    setState(() {
      categories.remove(category);
    });
    await dbService.saveCategories(familyId, categories, true);
  }

  void _removeAccount(Account account, DbService dbService, String familyId) {
    dbService.deleteAccount(account.accountId!);
    setState(() {});
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
            return const Center(child: CircularProgressIndicator());
          }
          final familyId = snapshot.data;
          if (familyId == null) {
            return Center(child: Text(l10n.familyIdError));
          }
          if (categories.isEmpty) {
            categories = [l10n.products, l10n.transport, l10n.entertainment, l10n.utilities, l10n.clothing, l10n.other];
          }
          if (!_syncStarted) {
            _syncStarted = true;
            Future.delayed(const Duration(seconds: 2), () {
              dbService.syncAllData(familyId);
            });
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
                      setState(() {
                        _showRestartButton = false;
                      });
                      _budgetCircleKey.currentState?.refresh();
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        if (_showRestartButton)
                          Container(
                            width: double.infinity,
                            margin: const EdgeInsets.all(16),
                            child: ElevatedButton.icon(
                              onPressed: _restartApp,
                              icon: const Icon(Icons.refresh),
                              label: Text(
                                l10n.restartApp,
                                style: const TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(16),
                              ),
                            ),
                          ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/stats');
                            },
                            child: BudgetCircle(
                              key: _budgetCircleKey,
                              familyId: familyId,
                              userId: Provider.of<UserProvider>(context).isChild ? userId : null,
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: FutureBuilder<List<Account>>(
                              future: dbService.getAllAccountsForUser(familyId, userId),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                }
                                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Center(child: Text(l10n.noAccounts));
                                }
                                final accounts = snapshot.data!;
                                final userProvider = Provider.of<UserProvider>(context);
                                final filteredAccounts = userProvider.isChild
                                    ? accounts.where((account) => account.userId == userId || account.isShared == true).toList()
                                    : accounts;
                                final int totalItems = filteredAccounts.length + 1;

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
                                    children: List.generate(totalItems, (index) {
                                      if (index < filteredAccounts.length) {
                                        final account = filteredAccounts[index];
                                        return Stack(
                                          key: ValueKey(account.accountId),
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
                                                );
                                              },
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: GestureDetector(
                                                onTap: () => _removeAccount(account, dbService, familyId),
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
                                          key: const ValueKey('add_account'),
                                          onTap: () {
                                            Navigator.pushNamed(context, '/accounts');
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.all(4.0),
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: AppConstants.accentColor, width: 1),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.add,
                                                color: AppConstants.accentColor,
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
                                        if (oldIndex < filteredAccounts.length && newIndex < filteredAccounts.length) {
                                          final item = filteredAccounts.removeAt(oldIndex);
                                          filteredAccounts.insert(newIndex, item);
                                        }
                                      });
                                    },
                                  );
                                } else {
                                  return GridView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1.5,
                                    ),
                                    itemCount: totalItems,
                                    itemBuilder: (context, index) {
                                      if (index < filteredAccounts.length) {
                                        final account = filteredAccounts[index];
                                        return Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                '/stats',
                                                arguments: {'selectedAccountId': account.accountId},
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
                                                    );
                                                  },
                                                ),
                                                if (_isEditMode)
                                                  Positioned(
                                                    top: -5,
                                                    right: -5,
                                                    child: GestureDetector(
                                                      onTap: () => _removeAccount(account, dbService, familyId),
                                                      child: Container(
                                                        padding: const EdgeInsets.all(4),
                                                        decoration: const BoxDecoration(
                                                          color: Colors.red,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: const Icon(
                                                          Icons.close,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
                                                _showAddAccountDialog(context, userId, familyId, dbService);
                                              },
                                              onLongPress: _handleLongPress,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(10),
                                                  border: Border.all(color: AppConstants.accentColor, width: 1),
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.add,
                                                    color: AppConstants.accentColor,
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
                              }
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Builder(
                            builder: (context) {
                              final int totalItems = categories.length + 1;

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
                                  children: List.generate(totalItems, (index) {
                                    if (index < categories.length) {
                                      final category = categories[index];
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
                                                    color: Colors.red,
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
                                            border: Border.all(color: Colors.red, width: 2),
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.red,
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
                                      if (oldIndex < categories.length && newIndex < categories.length) {
                                        final item = categories.removeAt(oldIndex);
                                        categories.insert(newIndex, item);
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
                                    if (index < categories.length) {
                                      final category = categories[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(
                                              context,
                                              '/stats',
                                              arguments: {
                                                'selectedCategory': category,
                                                'showExpenses': true,
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
                                                        color: Colors.red,
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
                                                border: Border.all(color: Colors.red, width: 2),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.red,
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
                        FutureBuilder<List<model_transaction.Transaction>>(
                            future: dbService.getTransactions(familyId),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                return Center(child: Text(l10n.noTransactions));
                              }

                              final userProvider = Provider.of<UserProvider>(context);
                              final transactions = userProvider.isChild
                                  ? snapshot.data!.where((t) => t.userId == userId).toList()
                                  : snapshot.data!;
                              final expenses = transactions
                                  .where((transaction) => transaction.isExpense)
                                  .toList();
                              if (expenses.isEmpty) {
                                return Center(child: Text(l10n.noExpenses));
                              }

                              expenses.sort((a, b) => b.date!.compareTo(a.date!));

                              return ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: expenses.length,
                                itemBuilder: (context, index) {
                                  final transaction = expenses[index];
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
                                          leading: const Icon(Icons.money_off, color: Colors.red),
                                          onTap: () {
                                            _showEditTransactionDialog(context, transaction, dbService, userId, familyId);
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }
                        ),
                      ],
                    ),
                  ),
                ),
                if (_isEditMode) buildEditModeOverlay(),
              ],
            ),
          );
        }
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
                  setState(() {
                    categories.add(nameController.text);
                  });
                  final familyId = await dbService.getFamilyIdForUser(userId);
                  if (familyId != null) {
                    await dbService.saveCategories(familyId, categories, true);
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

  void _showTransactionDialog(BuildContext context, String accountId, String category, String familyId, String userId, DbService dbService) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController amountController = TextEditingController();
    DateTime selectedDate = DateTime.now();
    bool isNowSelected = true;
    String comment = '';
    String selectedCurrency = 'UAH';
    String? geoTag;

    Future<void> _getLocation() async {
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) return;

        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) return;
        }

        if (permission == LocationPermission.deniedForever) return;

        Position position = await Geolocator.getCurrentPosition();
        geoTag = '${position.latitude}, ${position.longitude}';
      } catch (e) {
        print('${l10n.locationError}: $e');
      }
    }

    _getLocation();

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
                        return Text('$accountName → $category', style: const TextStyle(fontSize: 18));
                      }
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
                        label: Text(isNowSelected
                            ? l10n.selectDate
                            : '${selectedDate.day}.${selectedDate.month}.${selectedDate.year} ${selectedDate.hour}:${selectedDate.minute.toString().padLeft(2, '0')}'),
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
                            isExpense: true,
                            accountId: accountId,
                            userId: userId,
                            familyId: familyId,
                            date: selectedDate,
                            notes: comment,
                            currency: selectedCurrency,
                            geoTag: geoTag,
                          );
                          amountController.clear();
                          Navigator.pop(context);
                          _refreshUI();
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(l10n.invalidAmount)),
                          );
                        }
                      }
                    },
                    child: Text(l10n.addExpense),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditTransactionDialog(
      BuildContext context,
      model_transaction.Transaction transaction,
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

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            Widget? mapWidget;
            if (transaction.geoTag != null && transaction.geoTag!.isNotEmpty) {
              try {
                final coordinates = transaction.geoTag!.split(',');
                if (coordinates.length == 2) {
                  final lat = double.parse(coordinates[0].trim());
                  final lng = double.parse(coordinates[1].trim());

                  mapWidget = Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 16),
                      Text(l10n.transactionLocation, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(lat, lng),
                              zoom: 15,
                            ),
                            markers: {
                              Marker(
                                markerId: const MarkerId('transaction_location'),
                                position: LatLng(lat, lng),
                              ),
                            },
                            zoomControlsEnabled: true,
                            mapToolbarEnabled: false,
                            myLocationButtonEnabled: false,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              } catch (e) {
                print('${l10n.mapDisplayError}: $e');
              }
            }
            return AlertDialog(
              title: Text(l10n.editExpense),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<Account?>(
                        future: dbService.getAccountById(transaction.accountId ?? ''),
                        builder: (context, snapshot) {
                          final accountName = snapshot.data?.name ?? l10n.unknownAccount;
                          return Text('${l10n.currentAccount}: $accountName', style: const TextStyle(fontWeight: FontWeight.bold));
                        }
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
                      items: categories.map((category) {
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
                        }
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
                    if (mapWidget != null) mapWidget,
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
                        currency: selectedCurrency,
                      );
                      Navigator.of(context).pop();
                      _refreshUI();
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

  String _formatDate(DateTime date) {
    return '${date.day}.${date.month}.${date.year}';
  }
}
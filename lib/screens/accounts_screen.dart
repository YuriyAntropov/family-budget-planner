import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/db_service.dart';
import '../services/auth_service.dart';
import '../models/account.dart';
import '../services/user_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../l10n/app_localizations.dart';

class AccountsScreen extends StatefulWidget {
  const AccountsScreen({super.key});

  @override
  _AccountsScreenState createState() => _AccountsScreenState();
}

class _AccountsScreenState extends State<AccountsScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _balanceController = TextEditingController();
  String _currency = 'UAH';

  void _showUserSelectionDialog(BuildContext context, String familyId, String currentUserId, Function(String) onUserSelected) {
    final l10n = AppLocalizations.of(context)!;
    final dbService = Provider.of<DbService>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.selectUser),
          content: FutureBuilder<List<Map<String, dynamic>>>(
            future: dbService.getFamilyMembers(familyId),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final members = snapshot.data!
                  .where((m) => m['userId'] != currentUserId)
                  .toList();
              if (members.isEmpty) {
                return Text(l10n.noOtherUsers);
              }
              return SizedBox(
                width: double.maxFinite,
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    final member = members[index];
                    return ListTile(
                      title: Text(member['email'] ?? l10n.user),
                      onTap: () {
                        onUserSelected(member['userId']);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(l10n.cancel),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = authService.currentUser?.uid;

      if (userId != null) {
        try {
          final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
          if (userDoc.exists && userDoc.data() != null) {
            final userData = userDoc.data()!;
            final role = userData['role'] as String?;
            if (role != null) {
              await userProvider.setRole(role);
              if (mounted) setState(() {});
            }
          }
        } catch (e) {
          print('Error loading user role: $e');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dbService = Provider.of<DbService>(context);
    final authService = Provider.of<AuthService>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final userId = authService.currentUser?.uid ?? '';
    final isAdmin = userProvider.isAdmin;

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
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () async {
              await dbService.syncAllData(familyId);
              setState(() {});
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    TabBar(
                      tabs: [
                        Tab(text: l10n.myAccounts),
                        Tab(text: l10n.familyAccounts),
                        Tab(text: l10n.userAccounts),
                      ],
                      labelColor: Colors.blue,
                      unselectedLabelColor: Colors.grey,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      child: TabBarView(
                        children: [
                          _buildAccountsList(context, dbService, familyId, userId, false, null),
                          _buildAccountsList(context, dbService, familyId, null, true, null),
                          (userProvider.role == 'admin' || userProvider.role == 'head')
                              ? FutureBuilder<List<Map<String, dynamic>>>(
                            future: dbService.getFamilyMembers(familyId),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              final members = snapshot.data!;
                              return ListView.builder(
                                itemCount: members.length,
                                itemBuilder: (context, index) {
                                  final member = members[index];
                                  if (member['userId'] == userId) return const SizedBox();
                                  return FutureBuilder<List<Account>>(
                                    future: dbService.getFilteredAccounts(familyId, member['userId'], false),
                                    builder: (context, accountsSnapshot) {
                                      final hasAccounts = accountsSnapshot.hasData && accountsSnapshot.data!.isNotEmpty;
                                      return ExpansionTile(
                                        title: Text(member['email'] ?? l10n.user),
                                        subtitle: hasAccounts
                                            ? Text(l10n.accounts_count(accountsSnapshot.data!.length))
                                            : Text(l10n.noUserAccounts),
                                        initiallyExpanded: hasAccounts,
                                        trailing: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if (userProvider.isAdmin || userProvider.isHeadOfFamily)
                                              IconButton(
                                                icon: const Icon(Icons.add_circle, color: Colors.green),
                                                onPressed: () {
                                                  _showAddAccountDialog(context, member['userId'], familyId);
                                                },
                                                tooltip: l10n.addAccountTooltip,
                                              ),
                                            const Icon(Icons.expand_more),
                                          ],
                                        ),
                                        children: [
                                          if (accountsSnapshot.connectionState == ConnectionState.waiting)
                                            const Center(child: CircularProgressIndicator())
                                          else if (!hasAccounts)
                                            Padding(
                                              padding: const EdgeInsets.all(16.0),
                                              child: Center(child: Text(l10n.noUserAccounts)),
                                            )
                                          else
                                            SizedBox(
                                              height: accountsSnapshot.data!.length * 80.0,
                                              child: ListView.builder(
                                                physics: const NeverScrollableScrollPhysics(),
                                                itemCount: accountsSnapshot.data!.length,
                                                itemBuilder: (context, idx) {
                                                  final account = accountsSnapshot.data![idx];
                                                  return Card(
                                                    margin: const EdgeInsets.symmetric(
                                                      horizontal: 16.0,
                                                      vertical: 8.0,
                                                    ),
                                                    child: ListTile(
                                                      title: Text(account.name ?? l10n.noTitle),
                                                      subtitle: Text('${l10n.balance}: ${account.balance?.toStringAsFixed(2)} ${account.currency}'),
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                          context,
                                                          '/stats',
                                                          arguments: {'selectedAccountId': account.accountId},
                                                        );
                                                      },
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          )
                              : Center(child: Text(l10n.adminOnly)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccountsList(
      BuildContext context,
      DbService dbService,
      String familyId,
      String? ownerId,
      bool isShared,
      String? ownerName
      ) {
    final l10n = AppLocalizations.of(context)!;
    return FutureBuilder<List<Account>>(
      future: dbService.getFilteredAccounts(familyId, ownerId, isShared),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('${l10n.errorMessage(snapshot.error.toString())}'));
        }
        final accounts = snapshot.data ?? [];
        if (accounts.isEmpty) {
          return Center(
            child: Text(
                isShared
                    ? l10n.noFamilyAccounts
                    : ownerName != null
                    ? l10n.userNoAccounts(ownerName)
                    : l10n.noPersonalAccounts
            ),
          );
        }
        return ListView.builder(
          itemCount: accounts.length,
          itemBuilder: (context, index) {
            final account = accounts[index];
            return Card(
              margin: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: ListTile(
                title: Text(account.name ?? l10n.noTitle),
                subtitle: Text('${l10n.balance}: ${account.balance?.toStringAsFixed(2)} ${account.currency}'),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    '/stats',
                    arguments: {'selectedAccountId': account.accountId},
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showEditAccountDialog(context, ownerId ?? '', familyId, account),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        if (account.accountId != null) {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(l10n.deleteAccount),
                              content: Text(l10n.deleteAccountConfirm(account.name ?? '')),
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
                            ),
                          ) ?? false;
                          if (confirmed) {
                            final success = await dbService.deleteAccount(account.accountId!);
                            if (success) {
                              setState(() {});
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showTransferDialog(BuildContext context, String userId, String familyId) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController _amountController = TextEditingController();
    String? _fromAccountId;
    String? _toAccountId;

    final dbService = Provider.of<DbService>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.transferBetweenAccounts),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FutureBuilder<List<Account>>(
                      future: dbService.getAccounts(familyId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const CircularProgressIndicator();
                        }
                        final accounts = snapshot.data!;
                        return Column(
                          children: [
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: l10n.fromAccount,
                                border: const OutlineInputBorder(),
                              ),
                              value: _fromAccountId,
                              items: accounts.map((account) {
                                return DropdownMenuItem<String>(
                                  value: account.accountId,
                                  child: Text(
                                      '${account.name} (${account.balance?.toStringAsFixed(2)} ${account.currency})'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _fromAccountId = value;
                                });
                              },
                            ),
                            const SizedBox(height: 16),
                            DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: l10n.toAccount,
                                border: const OutlineInputBorder(),
                              ),
                              value: _toAccountId,
                              items: accounts.map((account) {
                                return DropdownMenuItem<String>(
                                  value: account.accountId,
                                  child: Text(
                                      '${account.name} (${account.balance?.toStringAsFixed(2)} ${account.currency})'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _toAccountId = value;
                                });
                              },
                            ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.amount,
                        border: const OutlineInputBorder(),
                      ),
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
                  onPressed: () async {
                    if (_fromAccountId != null &&
                        _toAccountId != null &&
                        _amountController.text.isNotEmpty) {
                      try {
                        final amount = double.parse(_amountController.text);
                        await dbService.addTransaction(
                          amount: amount,
                          category: l10n.transfer,
                          isExpense: true,
                          accountId: _fromAccountId!,
                          userId: userId,
                          familyId: familyId,
                          notes: l10n.transferNote,
                        );
                        await dbService.addTransaction(
                          amount: amount,
                          category: l10n.transfer,
                          isExpense: false,
                          accountId: _toAccountId!,
                          userId: userId,
                          familyId: familyId,
                          notes: l10n.transferFromNote,
                        );
                        Navigator.of(context).pop();
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 100), () {
                          setState(() {});
                        });
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.invalidAmount)),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.fillAllFields)),
                      );
                    }
                  },
                  child: Text(l10n.transfer),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showEditAccountDialog(
      BuildContext context, String userId, String familyId, Account account) {
    final l10n = AppLocalizations.of(context)!;
    _nameController.text = account.name ?? '';
    _balanceController.text = account.balance?.toString() ?? '0';
    _currency = account.currency ?? 'UAH';

    String _accountOwner = account.isShared == true
        ? 'family'
        : (account.userId == userId ? 'self' : account.userId ?? 'self');

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final isAdminUser = userProvider.isAdmin;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.editAccount),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.accountName,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _balanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.balance,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _currency,
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
                            _currency = value;
                          });
                        }
                      },
                    ),
                    if (isAdminUser) ...[
                      const SizedBox(height: 16),
                      Text('${l10n.accountOwner}:'),
                      RadioListTile<String>(
                        title: Text(l10n.personal),
                        value: 'self',
                        groupValue: _accountOwner,
                        onChanged: (value) {
                          setState(() {
                            _accountOwner = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text(l10n.familyAccount),
                        value: 'family',
                        groupValue: _accountOwner,
                        onChanged: (value) {
                          setState(() {
                            _accountOwner = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Row(
                          children: [
                            Text(l10n.otherUser),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                        value: 'other',
                        groupValue: _accountOwner,
                        onChanged: (value) {
                          if (value == 'other') {
                            _showUserSelectionDialog(context, familyId, userId, (selectedUserId) {
                              setState(() {
                                _accountOwner = selectedUserId;
                              });
                            });
                          } else {
                            setState(() {
                              _accountOwner = value!;
                            });
                          }
                        },
                      ),
                    ],
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
                    if (_nameController.text.isNotEmpty && _balanceController.text.isNotEmpty) {
                      try {
                        final balance = double.parse(_balanceController.text.replaceAll(',', '.'));
                        final dbService = Provider.of<DbService>(context, listen: false);
                        final accountUserId = _accountOwner == 'self' ? userId :
                        _accountOwner == 'family' ? null : _accountOwner;
                        dbService.updateAccount(
                          accountId: account.accountId!,
                          serverId: account.serverId,
                          name: _nameController.text,
                          balance: balance,
                          currency: _currency,
                          userId: accountUserId,
                          isShared: _accountOwner == 'family',
                        );
                        Navigator.of(context).pop();
                        setState(() {});
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.invalidBalance)),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.fillAllFields)),
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

  void _showAddAccountDialog(BuildContext context, String userId, String familyId) {
    final l10n = AppLocalizations.of(context)!;
    _nameController.clear();
    _balanceController.clear();
    _currency = 'UAH';
    String _accountOwner = 'self';

    final dbService = Provider.of<DbService>(context, listen: false);
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: l10n.accountName,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _balanceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: l10n.initialBalance,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _currency,
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
                            _currency = value;
                          });
                        }
                      },
                    ),
                    if (isAdminUser) ...[
                      const SizedBox(height: 16),
                      Text('${l10n.accountOwner}:'),
                      RadioListTile<String>(
                        title: Text(l10n.personal),
                        value: 'self',
                        groupValue: _accountOwner,
                        onChanged: (value) {
                          setState(() {
                            _accountOwner = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Text(l10n.familyAccount),
                        value: 'family',
                        groupValue: _accountOwner,
                        onChanged: (value) {
                          setState(() {
                            _accountOwner = value!;
                          });
                        },
                      ),
                      RadioListTile<String>(
                        title: Row(
                          children: [
                            Text(l10n.otherUser),
                            const Icon(Icons.arrow_drop_down),
                          ],
                        ),
                        value: 'other',
                        groupValue: _accountOwner,
                        onChanged: (value) {
                          if (value == 'other') {
                            _showUserSelectionDialog(context, familyId, userId, (selectedUserId) {
                              setState(() {
                                _accountOwner = selectedUserId;
                              });
                            });
                          } else {
                            setState(() {
                              _accountOwner = value!;
                            });
                          }
                        },
                      ),
                    ],
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
                    if (_nameController.text.isNotEmpty && _balanceController.text.isNotEmpty) {
                      try {
                        final balance = double.parse(_balanceController.text.replaceAll(',', '.'));

                        final accountUserId = _accountOwner == 'self' ? userId :
                        _accountOwner == 'family' ? null : _accountOwner;

                        dbService.addAccount(
                          name: _nameController.text,
                          balance: balance,
                          currency: _currency,
                          userId: accountUserId ?? userId,
                          familyId: familyId,
                          isShared: _accountOwner == 'family',
                        );

                        Navigator.of(context).pop();
                        setState(() {});
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.invalidBalance)),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(l10n.fillAllFields)),
                      );
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
}

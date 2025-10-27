import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/user_provider.dart';
import '../services/nfc_service.dart';
import '../l10n/app_localizations.dart';

class FamilySettingsScreen extends StatefulWidget {
  const FamilySettingsScreen({super.key});

  @override
  State<FamilySettingsScreen> createState() => _FamilySettingsScreenState();
}

class _FamilySettingsScreenState extends State<FamilySettingsScreen> {
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _inviteCodeController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;
  bool _initialized = false;
  String? _errorMessage;
  String? _familyId;
  bool _isAdmin = false;
  List<Map<String, dynamic>> _pendingRequests = [];
  List<Map<String, dynamic>> _familyMembers = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFamilyData();
      if (!_initialized) {
        Provider.of<UserProvider>(context, listen: false).initialize();
        _initialized = true;
      }
    });
  }

  Future<void> _loadFamilyData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final dbService = Provider.of<DbService>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    try {
      final userId = authService.currentUserId;
      if (userId == null) {
        setState(() {
          _errorMessage = 'User not found'; // Временно без локализации
          _isLoading = false;
        });
        return;
      }

      final isInFamily = await dbService.isUserInFamily(userId);

      if (isInFamily) {
        final userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          final userData = userDoc.data();
          if (userData != null && userData.containsKey('familyId')) {
            _familyId = userData['familyId'];
            final familyDoc = await _firestore.collection('families').doc(_familyId).get();
            if (familyDoc.exists) {
              final familyData = familyDoc.data();
              if (familyData != null) {
                _isAdmin = familyData['adminId'] == userId;
                _familyNameController.text = familyData['name'] ?? '';
                _inviteCodeController.text = familyData['inviteCode'] ?? '';
                _familyMembers = await dbService.getFamilyMembers(_familyId!);
                if (_isAdmin && familyData.containsKey('pendingMembers')) {
                  final pendingMembers = familyData['pendingMembers'] as List<dynamic>? ?? [];
                  _pendingRequests = pendingMembers.map<Map<String, dynamic>>((member) => {
                    'userId': member['userId'],
                    'email': member['email'],
                    'deviceModel': member['deviceModel'] ?? 'Unknown',
                    'deviceLocation': member['deviceLocation'] ?? 'Unknown',
                    'requestDate': member['requestDate'],
                  }).toList();
                }
              }
            }
          }
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  Future<void> _createFamily() async {
    final l10n = AppLocalizations.of(context)!;

    if (_familyNameController.text.isEmpty) {
      setState(() {
        _errorMessage = l10n.fillAllFields;
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dbService = Provider.of<DbService>(context, listen: false);
      final userId = authService.currentUserId;
      if (userId == null) {
        setState(() {
          _errorMessage = l10n.userNotFound;
        });
        return;
      }
      final result = await dbService.createFamily(
        name: _familyNameController.text,
        adminId: userId,
      );
      final familyId = result['familyId'];
      final inviteCode = result['inviteCode'];
      if (familyId != null && familyId.isNotEmpty) {
        await dbService.addUserToFamily(
          email: authService.currentUserEmail ?? '',
          role: 'admin',
          familyId: familyId,
          permissions: UserPermissions.fromRole(UserRole.admin),
        );
        setState(() {
          _inviteCodeController.text = inviteCode ?? '';
          _familyId = familyId;
          _isAdmin = true;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.familyCreated)),
        );
        await _loadFamilyData();
      } else {
        setState(() {
          _errorMessage = l10n.registrationError;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '${l10n.errorMessage(e.toString())}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _joinFamily() async {
    final l10n = AppLocalizations.of(context)!;

    if (_inviteCodeController.text.isEmpty) {
      setState(() {
        _errorMessage = l10n.fillAllFields;
      });
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final dbService = Provider.of<DbService>(context, listen: false);
      final userId = authService.currentUserId;
      final email = authService.currentUserEmail;
      if (userId == null || email == null) {
        setState(() {
          _errorMessage = l10n.userNotFound;
        });
        return;
      }
      final success = await dbService.requestJoinFamily(
        _inviteCodeController.text,
        userId,
        email,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.joinRequestSent)),
        );
      } else {
        setState(() {
          _errorMessage = l10n.familyNotFound;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '${l10n.errorMessage(e.toString())}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _shareInviteCode() async {
    final l10n = AppLocalizations.of(context)!;

    if (_inviteCodeController.text.isEmpty) {
      return;
    }
    await Share.share(
      '${l10n.joinFamily} "${l10n.appTitle}"! ${l10n.inviteCode}: ${_inviteCodeController.text}',
      subject: l10n.familySettings,
    );
  }

  Future<void> _acceptRequest(Map<String, dynamic> request) async {
    final l10n = AppLocalizations.of(context)!;

    if (_familyId == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final dbService = Provider.of<DbService>(context, listen: false);
      final role = await _showRoleSelectionDialog(request);
      if (role != null) {
        final success = await dbService.acceptJoinRequest(
          _familyId!,
          request['userId'],
          request['email'],
          role.name,
          UserPermissions.fromRole(role),
        );
        if (success) {
          _reloadAfterAccept();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.removeUserError)),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorMessage(e.toString()))),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _rejectRequest(Map<String, dynamic> request) async {
    final l10n = AppLocalizations.of(context)!;

    if (_familyId == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final dbService = Provider.of<DbService>(context, listen: false);
      final success = await dbService.rejectJoinRequest(
        _familyId!,
        request['userId'],
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.requestRejected)),
        );
        await _loadFamilyData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.rejectError)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.errorMessage(e.toString()))),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<UserRole?> _showRoleSelectionDialog(Map<String, dynamic> request) async {
    final l10n = AppLocalizations.of(context)!;

    return showDialog<UserRole>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.roleSelection(request['email'])),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.administrator),
                subtitle: Text(l10n.fullAccess),
                onTap: () {
                  Navigator.of(context).pop(UserRole.admin);
                },
              ),
              ListTile(
                title: Text(l10n.child),
                subtitle: Text(l10n.expensesOnly),
                onTap: () {
                  Navigator.of(context).pop(UserRole.child);
                },
              ),
              ListTile(
                title: Text(l10n.customRole),
                subtitle: Text(l10n.configurePermissions),
                onTap: () async {
                  final customRole = await _showCustomRoleDialog();
                  Navigator.of(context).pop(customRole);
                },
              ),
            ],
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

  Future<UserRole?> _showCustomRoleDialog() async {
    final l10n = AppLocalizations.of(context)!;
    UserPermissions permissions = UserPermissions();

    return showDialog<UserRole>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(l10n.permissionsConfig),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CheckboxListTile(
                      title: Text(l10n.canAddExpenses),
                      value: permissions.canAddExpense,
                      onChanged: (value) {
                        setState(() {
                          permissions.canAddExpense = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(l10n.canUseChat),
                      value: permissions.canUseChat,
                      onChanged: (value) {
                        setState(() {
                          permissions.canUseChat = value ?? true;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(l10n.canAddIncome),
                      value: permissions.canAddIncome,
                      onChanged: (value) {
                        setState(() {
                          permissions.canAddIncome = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(l10n.canViewAllAccounts),
                      value: permissions.canViewAllAccounts,
                      onChanged: (value) {
                        setState(() {
                          permissions.canViewAllAccounts = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(l10n.canEditAccounts),
                      value: permissions.canEditAccounts,
                      onChanged: (value) {
                        setState(() {
                          permissions.canEditAccounts = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(l10n.canViewStatistics),
                      value: permissions.canViewStatistics,
                      onChanged: (value) {
                        setState(() {
                          permissions.canViewStatistics = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(l10n.canInviteMembers),
                      value: permissions.canInviteMembers,
                      onChanged: (value) {
                        setState(() {
                          permissions.canInviteMembers = value ?? false;
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text(l10n.canManageRoles),
                      value: permissions.canManageRoles,
                      onChanged: (value) {
                        setState(() {
                          permissions.canManageRoles = value ?? false;
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
                    UserRole customRole = UserRole.custom;
                    Navigator.of(context).pop(customRole);
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

  Future<void> _findLocalFamilies() async {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
    });
    try {
      final dbService = Provider.of<DbService>(context, listen: false);
      final families = await dbService.findLocalFamilies();

      if (families.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.noLocalFamilies)),
        );
        return;
      }
      final selectedFamily = await showDialog<String>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(l10n.availableFamilies),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: families.length,
                itemBuilder: (context, index) {
                  final family = families[index];
                  return ListTile(
                    title: Text(family.name ?? l10n.familyNoName),
                    subtitle: Text('${l10n.code}: ${family.inviteCode}'),
                    onTap: () {
                      Navigator.of(context).pop(family.inviteCode);
                    },
                  );
                },
              ),
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
      if (selectedFamily != null) {
        setState(() {
          _inviteCodeController.text = selectedFamily;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.searchError)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _leaveFamily() async {
    final l10n = AppLocalizations.of(context)!;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.leaveFamily),
        content: Text(l10n.leaveFamilyConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.leaveFamily),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });
      try {
        final authService = Provider.of<AuthService>(context, listen: false);
        final dbService = Provider.of<DbService>(context, listen: false);
        final userId = authService.currentUserId;
        if (userId != null && _familyId != null) {
          final success = await dbService.removeUserFromFamily(_familyId!, userId);
          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.leftFamily)),
            );
            _showRestartDialog();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.leaveFamilyError)),
            );
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.errorMessage(e.toString()))),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showRestartDialog() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.restartRequired),
          content: Text(l10n.restartMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                      (route) => false,
                );
              },
              child: Text(l10n.restart),
            ),
          ],
        );
      },
    );
  }

  void _reloadAfterAccept() {
    final l10n = AppLocalizations.of(context)!;

    Future.delayed(const Duration(seconds: 1), () {
      _loadFamilyData();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.userAdded),
        duration: const Duration(seconds: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.familySettingsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFamilyData,
            tooltip: l10n.refreshData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            if (_familyId == null) ...[
              Text(
                l10n.notFamilyMember,
                style: const TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadFamilyData,
                child: Text(l10n.updateStatus),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _showRestartDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.restartApp),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.returnHome),
              ),

              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.createFamily,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _familyNameController,
                        decoration: InputDecoration(
                          labelText: l10n.familyName,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _createFamily,
                        child: Text(l10n.create),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.joinFamily,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _inviteCodeController,
                        decoration: InputDecoration(
                          labelText: l10n.inviteCode,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _joinFamily,
                                  child: Text(l10n.join),
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.wifi),
                                onPressed: _findLocalFamilies,
                                tooltip: l10n.findLocalFamilies,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          FutureBuilder<bool>(
                            future: NfcService.isAvailable(),
                            builder: (context, snapshot) {
                              final nfcAvailable = snapshot.data ?? false;
                              return ElevatedButton.icon(
                                icon: const Icon(Icons.nfc),
                                label: Text(l10n.joinNFC),
                                onPressed: nfcAvailable ? () async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.bringDeviceNFC)),
                                  );
                                  await NfcService.readNfcTag(
                                    onDataRead: (familyId, inviteCode) async {
                                      _inviteCodeController.text = inviteCode;
                                      await _joinFamily();
                                    },
                                  );
                                } : null,
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (_familyId != null) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '${l10n.family}: ${_familyNameController.text}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (_isAdmin) ...[
                        Text('${l10n.inviteCode}:'),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _inviteCodeController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              onPressed: () {},
                              tooltip: l10n.copy,
                            ),
                            IconButton(
                              icon: const Icon(Icons.share),
                              onPressed: _shareInviteCode,
                              tooltip: l10n.share,
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 16),
                      FutureBuilder<bool>(
                        future: NfcService.isAvailable(),
                        builder: (context, snapshot) {
                          final nfcAvailable = snapshot.data ?? false;
                          return ElevatedButton.icon(
                            icon: const Icon(Icons.nfc),
                            label: Text(l10n.shareNFC),
                            onPressed: nfcAvailable ? () async {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.bringDeviceNFC)),
                              );

                              await NfcService.startNfcSession(
                                familyId: _familyId!,
                                inviteCode: _inviteCodeController.text,
                                onDetected: (_, __) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(l10n.dataSentNFC)),
                                  );
                                },
                              );
                            } : null,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (_familyMembers.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  l10n.familyMembers,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _familyMembers.length,
                  itemBuilder: (context, index) {
                    final member = _familyMembers[index];
                    final authService = Provider.of<AuthService>(context, listen: false);
                    return Card(
                      child: ListTile(
                        title: Text(member['email'] ?? l10n.unknownUser),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${l10n.role}: ${member['role'] ?? l10n.unknown}'),
                            Text('${l10n.device}: ${member['deviceModel'] ?? l10n.unknown}'),
                          ],
                        ),
                        trailing: _isAdmin && member['userId'] != authService.currentUserId
                            ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(l10n.removeUser),
                                content: Text(l10n.removeUserConfirm(member['email'])),
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
                            );

                            if (confirmed == true) {
                              setState(() {
                                _isLoading = true;
                              });

                              final dbService =
                              Provider.of<DbService>(context, listen: false);
                              final success = await dbService.removeUserFromFamily(
                                  _familyId!, member['userId']);

                              setState(() {
                                _isLoading = false;
                              });

                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.userRemoved)),
                                );
                                _loadFamilyData();
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(l10n.removeUserError)),
                                );
                              }
                            }
                          },
                          tooltip: l10n.delete,
                        )
                            : null,
                      ),
                    );
                  },
                ),
              ],
              if (_isAdmin && _pendingRequests.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  l10n.joinRequests,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _pendingRequests.length,
                  itemBuilder: (context, index) {
                    final request = _pendingRequests[index];
                    return Card(
                      child: ListTile(
                        title: Text(request['email'] ?? l10n.unknownUser),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${l10n.device}: ${request['deviceModel']}'),
                            Text('${l10n.location}: ${request['deviceLocation']}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.check, color: Colors.green),
                              onPressed: () => _acceptRequest(request),
                              tooltip: l10n.accept,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.red),
                              onPressed: () => _rejectRequest(request),
                              tooltip: l10n.reject,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _leaveFamily,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: Text(l10n.leaveFamily),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

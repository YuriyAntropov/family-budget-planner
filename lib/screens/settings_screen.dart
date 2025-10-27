import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../services/user_provider.dart';
import '../services/currency_service.dart';
import 'profile_settings_screen.dart';
import '../services/backup_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
import '../services/locale_provider.dart';
import '../l10n/app_localizations.dart';
import '../services/theme_provider.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.helpTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.howToUse,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.addIncomeHelp,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.addExpenseHelp,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.viewStatsHelp,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aboutTitle),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              l10n.familyBudget,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(l10n.version),
            const SizedBox(height: 8),
            Text(l10n.copyright),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authService = Provider.of<AuthService>(context);
    final dbService = Provider.of<DbService>(context);
    final userProvider = Provider.of<UserProvider>(context);
    final currencyService = Provider.of<CurrencyService>(context);

    Widget buildCurrencySelector() {
      return FutureBuilder<String>(
        future: currencyService.getPreferredCurrency(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          final preferredCurrency = snapshot.data!;

          return ListTile(
            title: Text(l10n.displayCurrency),
            subtitle: Text(l10n.currencyDesc),
            trailing: DropdownButton<String>(
              value: preferredCurrency,
              items: const [
                DropdownMenuItem(value: 'UAH', child: Text('UAH')),
                DropdownMenuItem(value: 'USD', child: Text('USD')),
                DropdownMenuItem(value: 'EUR', child: Text('EUR')),
              ],
              onChanged: (value) {
                if (value != null) {
                  currencyService.setPreferredCurrency(value);
                  (context as Element).markNeedsBuild();
                }
              },
            ),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          if (userProvider.familyId != null) {
            await dbService.syncAllData(userProvider.familyId!);
          }
        },
        child: ListView(
          children: [
            ListTile(
              title: Text(l10n.language),
              subtitle: Text(
                Provider.of<LocaleProvider>(context).locale.languageCode == 'uk'
                    ? l10n.ukrainian
                    : l10n.english,
              ),
              onTap: () {
                _showLanguageDialog(context);
              },
            ),
            ListTile(
              title: Text(l10n.familySettings),
              subtitle: Text(l10n.familySettingsDesc),
              leading: const Icon(Icons.family_restroom),
              onTap: () {
                Navigator.pushNamed(context, '/family_settings');
              },
            ),
            if (userProvider.isAdmin || userProvider.isHeadOfFamily) ...[
              ListTile(
                title: Text(l10n.geoLocation),
                subtitle: Text(l10n.geoLocationDesc),
                trailing: Switch(
                  value: userProvider.useGeoLocation,
                  onChanged: (value) {
                    userProvider.setUseGeoLocation(value);
                  },
                ),
              ),
            ],
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(l10n.profileSettingsTitle),
              onTap: () {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted) {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const ProfileSettingsScreen()),
                    );
                  }
                });
              },
            ),
            ListTile(
              title: Text(l10n.securitySettings),
              subtitle: Text(l10n.securitySettingsDesc),
              leading: const Icon(Icons.security),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecuritySettingsScreen()),
                );
              },
            ),
            ListTile(
              title: Text(l10n.theme),
              subtitle: Text(Provider.of<ThemeProvider>(context).isDarkMode ? 'Dark' : l10n.light),
              trailing: Switch(
                value: Provider.of<ThemeProvider>(context).isDarkMode,
                onChanged: (value) {
                  Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                },
              ),
            ),
            buildCurrencySelector(),
            ListTile(
              title: Text(l10n.sync),
              subtitle: Text(l10n.syncStatus),
              onTap: () async {
                if (userProvider.familyId == null || userProvider.userId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.userNotInFamily)),
                  );
                  return;
                }
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => AlertDialog(
                    title: Text(l10n.sync),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(l10n.syncProgress),
                      ],
                    ),
                  ),
                );

                final success = await dbService.forceSyncAllData(userProvider.familyId!);

                if (context.mounted) {
                  Navigator.of(context).pop();
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(l10n.syncStatusTitle),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            success ? Icons.check_circle : Icons.sync_problem,
                            color: success ? Colors.green : Colors.orange,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            success ? l10n.syncSuccess : l10n.syncProblems,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(l10n.close),
                        ),
                      ],
                    ),
                  );
                }
              },
            ),
            ListTile(
              title: Text(l10n.help),
              leading: const Icon(Icons.help),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HelpScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(l10n.about),
              leading: const Icon(Icons.info),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(l10n.exportData),
              subtitle: Text(l10n.exportDesc),
              onTap: () async {
                final backupService = Provider.of<BackupService>(context, listen: false);
                await backupService.exportToJson();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.dataExported)),
                );
              },
            ),
            ListTile(
              title: Text(l10n.logout),
              onTap: () async {
                await authService.signOut();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.ukrainian),
                onTap: () {
                  Provider.of<LocaleProvider>(context, listen: false).setLocale(const Locale('uk'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(l10n.english),
                onTap: () {
                  Provider.of<LocaleProvider>(context, listen: false).setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({Key? key}) : super(key: key);

  @override
  _SecuritySettingsScreenState createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _useBiometrics = false;
  bool _usePinCode = false;
  final TextEditingController _pinController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _useBiometrics = prefs.getBool('use_biometrics') ?? false;
      _usePinCode = prefs.getBool('use_pin_code') ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.securityTitle),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: Text(l10n.useBiometrics),
            subtitle: Text(l10n.biometricsDesc),
            value: _useBiometrics,
            onChanged: (value) async {
              if (value) {
                final canCheckBiometrics = await _localAuth.canCheckBiometrics;
                final isDeviceSupported = await _localAuth.isDeviceSupported();

                if (canCheckBiometrics && isDeviceSupported) {
                  if (!_usePinCode) {
                    _showPinSetupDialog();
                  } else {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('use_biometrics', value);
                    setState(() {
                      _useBiometrics = value;
                    });
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.biometricsNotSupported)),
                  );
                }
              } else {
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('use_biometrics', value);
                setState(() {
                  _useBiometrics = value;
                });
              }
            },
          ),
          SwitchListTile(
            title: Text(l10n.usePinCode),
            subtitle: Text(l10n.pinCodeDesc),
            value: _usePinCode,
            onChanged: (value) async {
              if (value) {
                _showPinSetupDialog();
              } else {
                if (_useBiometrics) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('use_biometrics', false);
                  setState(() {
                    _useBiometrics = false;
                  });
                }

                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('use_pin_code', value);
                await prefs.remove('pin_code');
                setState(() {
                  _usePinCode = value;
                });
              }
            },
          ),
        ],
      ),
    );
  }

  void _showPinSetupDialog() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(l10n.setPinCode),
          content: TextField(
            controller: _pinController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            obscureText: true,
            decoration: InputDecoration(
              hintText: l10n.enter4Digits,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _pinController.clear();
              },
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () async {
                if (_pinController.text.length == 4) {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('pin_code', _pinController.text);
                  await prefs.setBool('use_pin_code', true);
                  setState(() {
                    _usePinCode = true;
                  });
                  Navigator.of(context).pop();
                  _pinController.clear();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.pinMust4Digits)),
                  );
                }
              },
              child: Text(l10n.save),
            ),
          ],
        );
      },
    );
  }
}

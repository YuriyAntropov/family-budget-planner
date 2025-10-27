import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/user_provider.dart';
import '../services/db_service.dart';
import '../l10n/app_localizations.dart';

class LockScreen extends StatefulWidget {
  const LockScreen({Key? key}) : super(key: key);

  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  final TextEditingController _pinController = TextEditingController();
  bool _useBiometrics = false;
  bool _usePinCode = false;
  String _storedPin = '';
  bool _isAuthenticating = false;

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
      _storedPin = prefs.getString('pin_code') ?? '';
    });

    if (_useBiometrics) {
      _authenticateWithBiometrics();
    }
  }

  Future<void> _authenticateWithBiometrics() async {
    if (_isAuthenticating) return;
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isAuthenticating = true;
    });

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: l10n.enterBiometrics,
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (authenticated) {
        if (mounted) {
          final authService = Provider.of<AuthService>(context, listen: false);
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          final dbService = Provider.of<DbService>(context, listen: false);

          final user = authService.currentUser;
          if (user != null) {
            userProvider.setUserId(user.uid);
            await userProvider.initialize();
            final familyId = userProvider.familyId;
            if (familyId != null) {
              await dbService.syncAllData(familyId);
            }
          }

          Navigator.of(context).pushReplacementNamed('/home');
        }
      }
    } catch (e) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        print(l10n.biometricAuthError(e.toString()));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  Future<void> _verifyPin() async {
    final l10n = AppLocalizations.of(context)!;

    if (_pinController.text == _storedPin) {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final dbService = Provider.of<DbService>(context, listen: false);

      final user = authService.currentUser;
      if (user != null) {
        userProvider.setUserId(user.uid);
        await userProvider.initialize();
        final familyId = userProvider.familyId;
        if (familyId != null) {
          await dbService.syncAllData(familyId);
        }
      }
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.incorrectPin)),
      );
      _pinController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.appTitle,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                if (_useBiometrics) ...[
                  ElevatedButton.icon(
                    icon: const Icon(Icons.fingerprint),
                    label: Text(l10n.enterWithBiometrics),
                    onPressed: _authenticateWithBiometrics,
                  ),
                  const SizedBox(height: 20),
                  Text(l10n.or),
                  const SizedBox(height: 20),
                ],
                if (_usePinCode) ...[
                  TextField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    obscureText: true,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: l10n.enterPin,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _verifyPin,
                    child: Text(l10n.enter),
                  ),
                ],
                if (!_useBiometrics && !_usePinCode) ...[
                  Text(l10n.loginProtectionNotSet),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/home');
                    },
                    child: Text(l10n.continueAction),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

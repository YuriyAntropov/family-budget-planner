import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/auth_service.dart';
import '../services/db_service.dart';
import '../l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _familyNameController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authService = Provider.of<AuthService>(context);
    final dbService = Provider.of<DbService>(context);
    final firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.registration),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.createAccount,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _displayNameController,
              decoration: InputDecoration(
                labelText: l10n.yourName,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: l10n.password,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                labelText: l10n.confirmPassword,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),

            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 24),
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: () async {
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty ||
                    _confirmPasswordController.text.isEmpty ||
                    _displayNameController.text.isEmpty ||
                    _familyNameController.text.isEmpty) {
                  setState(() {
                    _errorMessage = l10n.fillAllFields;
                  });
                  return;
                }
                if (_passwordController.text != _confirmPasswordController.text) {
                  setState(() {
                    _errorMessage = l10n.passwordsDontMatch;
                  });
                  return;
                }
                setState(() {
                  _isLoading = true;
                });
                try {
                  final success = await authService.signUpWithEmail(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (success != null) {
                    await firestore.collection('users').doc(success.uid).set({
                      'email': success.email,
                      'displayName': _displayNameController.text,
                      'lastUpdated': DateTime.now().toIso8601String(),
                    }, SetOptions(merge: true));
                    await dbService.addUserToFamily(
                      email: success.email!,
                      role: 'admin',
                      familyId: '',
                    );
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                } on firebase_auth.FirebaseAuthException catch (e) {
                  String errorMessage = l10n.registrationError;
                  if (e.code == 'email-already-in-use') {
                    errorMessage = l10n.emailInUse;
                  } else if (e.code == 'weak-password') {
                    errorMessage = l10n.weakPassword;
                  } else if (e.code == 'invalid-email') {
                    errorMessage = l10n.invalidEmail;
                  }
                  setState(() {
                    _errorMessage = errorMessage;
                  });
                } catch (e) {
                  setState(() {
                    _errorMessage = '${l10n.registrationError}: $e';
                  });
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: Text(l10n.register),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(l10n.alreadyHaveAccount),
            ),
          ],
        ),
      ),
    );
  }
}

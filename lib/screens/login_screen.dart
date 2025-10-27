import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../services/auth_service.dart';
import '../l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.login),
        automaticallyImplyLeading: false, // Убираем стрелку назад
      ),
      body: SingleChildScrollView(
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
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: l10n.password,
                border: const OutlineInputBorder(),
              ),
              obscureText: true,
            ),
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
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                setState(() {
                  _errorMessage = null;
                });
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.fillAllFields)),
                  );
                  return;
                }
                setState(() {
                  _isLoading = true;
                });
                try {
                  final user = await authService.signInWithEmail(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    setState(() {
                      _errorMessage = l10n.loginError;
                    });
                  }
                } on firebase_auth.FirebaseAuthException catch (e) {
                  String errorMessage = l10n.loginError;
                  if (e.code == 'user-not-found') {
                    errorMessage = l10n.userNotFound;
                  } else if (e.code == 'wrong-password') {
                    errorMessage = l10n.wrongPassword;
                  } else if (e.code == 'invalid-email') {
                    errorMessage = l10n.invalidEmail;
                  } else if (e.code == 'user-disabled') {
                    errorMessage = l10n.userDisabled;
                  }
                  setState(() {
                    _errorMessage = errorMessage;
                  });
                } catch (e) {
                  setState(() {
                    _errorMessage = '${l10n.loginError}: $e';
                  });
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
              child: Text(l10n.signIn),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: Text(l10n.noAccount),
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () {
                if (_emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.enterEmailReset)),
                  );
                  return;
                }
                authService.resetPassword(_emailController.text);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.resetInstructions)),
                );
              },
              child: Text(l10n.forgotPassword),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: Text(l10n.signInGoogle),
              onPressed: () async {
                setState(() {
                  _errorMessage = null;
                  _isLoading = true;
                });
                try {
                  final user = await authService.signInWithGoogle();

                  if (user != null) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    setState(() {
                      _errorMessage = l10n.googleLoginError;
                    });
                  }
                } catch (e) {
                  setState(() {
                    _errorMessage = '${l10n.googleLoginError}: $e';
                  });
                } finally {
                  setState(() {
                    _isLoading = false;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

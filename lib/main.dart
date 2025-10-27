import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'database/database.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/chat_screen.dart';
import 'screens/income_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/stats_screen.dart';
import 'screens/ai_screen.dart';
import 'services/auth_service.dart';
import 'services/db_service.dart';
import 'services/encryption_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'screens/family_settings_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'services/user_provider.dart';
import 'screens/accounts_screen.dart';
import 'services/currency_service.dart';
import 'services/backup_service.dart';
import 'screens/lock_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/locale_provider.dart';
import 'l10n/app_localizations.dart';
import 'services/theme_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );

  final database = AppDatabase();
  final encryptionService = EncryptionService();
  final localeProvider = LocaleProvider();
  final themeProvider = ThemeProvider();

  await encryptionService.initialize();
  await localeProvider.loadLocale();
  await themeProvider.loadTheme();

  runApp(
      MultiProvider(
        providers: [
          Provider<AuthService>(create: (_) => AuthService()),
          Provider<DbService>(create: (_) => DbService(database)),
          Provider<EncryptionService>(create: (_) => encryptionService),
          Provider<AppDatabase>(create: (_) => database),
          Provider<CurrencyService>(create: (_) => CurrencyService()),
          Provider<BackupService>(
            create: (context) => BackupService(
                Provider.of<DbService>(context, listen: false)
            ),
          ),
          ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
          ChangeNotifierProvider<LocaleProvider>.value(value: localeProvider),
          ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ],
        child: const MyApp(),
      )
  );
}


Future<Map<String, dynamic>> checkUserInFamily(String userId) async {
  try {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (!userDoc.exists) return {'inFamily': false};
    final userData = userDoc.data();
    if (userData == null) return {'inFamily': false};
    final bool inFamily = userData.containsKey('familyId') && userData['familyId'] != null;

    return {
      'inFamily': inFamily,
      'familyId': userData['familyId'],
      'role': userData['role'],
    };
  } catch (e) {
    print('Помилка перевірки користувача в сім\'ї: $e');
    return {'inFamily': false};
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LocaleProvider, ThemeProvider>(
      builder: (context, localeProvider, themeProvider, child) {
        return MaterialApp(
          title: 'Family Budget Planner',
          locale: localeProvider.locale,
          theme: themeProvider.themeData,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('uk'),
            Locale('en'),
          ],
          home: const SplashScreen(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/home': (context) => const HomeScreen(),
            '/chat': (context) => const ChatScreen(),
            '/income': (context) => const IncomeScreen(),
            '/settings': (context) => const SettingsScreen(),
            '/stats': (context) => const StatsScreen(),
            '/ai': (context) => const AIScreen(),
            '/family_settings': (context) => const FamilySettingsScreen(),
            '/accounts': (context) => const AccountsScreen(),
            '/lock': (context) => const LockScreen(),
          },
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String _loadingText = 'Загрузка...';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUserAndNavigate();
    });
  }

  Future<void> _checkUserAndNavigate() async {
    try {
      final authService = Provider.of<AuthService>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final dbService = Provider.of<DbService>(context, listen: false);

      final user = authService.currentUser;

      if (user == null) {
        if (mounted) {
          Navigator.of(context).pushReplacementNamed('/login');
        }
        return;
      }

      setState(() {
        _loadingText = 'Проверка настроек безопасности...';
      });

      try {
        final prefs = await SharedPreferences.getInstance();
        final useBiometrics = prefs.getBool('use_biometrics') ?? false;
        final usePinCode = prefs.getBool('use_pin_code') ?? false;

        if (useBiometrics || usePinCode) {
          if (mounted) {
            Navigator.of(context).pushReplacementNamed('/lock');
            return;
          }
        }
      } catch (e) {
        print('Помилка перевірки налаштувань безпеки: $e');
      }

      setState(() {
        _loadingText = 'Инициализация пользователя...';
      });

      userProvider.setUserId(user.uid);
      await userProvider.initialize();

      // Ждем пока UserProvider полностью инициализируется
      int attempts = 0;
      while ((userProvider.displayName == null || userProvider.familyId == null) && attempts < 10) {
        await Future.delayed(const Duration(milliseconds: 500));
        attempts++;
      }

      final familyId = userProvider.familyId;
      if (familyId != null) {
        setState(() {
          _loadingText = 'Синхронизация данных...';
        });

        await dbService.forceSyncAllData(familyId);

        setState(() {
          _loadingText = 'Завершение...';
        });

        await Future.delayed(const Duration(milliseconds: 1000));
      }

      if (mounted) {
        if (userProvider.familyId != null) {
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          Navigator.of(context).pushReplacementNamed('/family_settings');
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              _loadingText,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

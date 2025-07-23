import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/registration_screen.dart';
import 'package:provider/provider.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MaBoutiqueApp());
}

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;

  bool get isAuthenticated => _isAuthenticated;

  Future<void> checkAuth() async {
    final token = await AuthService.getToken();
    _isAuthenticated = token != null;
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    final success = await AuthService.login(username, password);
    _isAuthenticated = success;
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.deleteToken();
    _isAuthenticated = false;
    notifyListeners();
  }
}

class MaBoutiqueApp extends StatelessWidget {
  const MaBoutiqueApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider()..checkAuth(),
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp(
            title: 'MaBoutique.ma',
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ar'),
              Locale('fr'),
              Locale('tz'),
              Locale('am'),
            ],
            home: auth.isAuthenticated ? const HomeScreen() : LoginScreen(onLoginSuccess: () {
              auth.checkAuth();
            }),
            routes: {
              '/login': (context) => LoginScreen(onLoginSuccess: () {
                    auth.checkAuth();
                  }),
              '/register': (context) => RegistrationScreen(onRegistrationSuccess: () {
                    auth.checkAuth();
                  }),
              '/home': (context) => const HomeScreen(),
            },
          );
        },
      ),
    );
  }
}

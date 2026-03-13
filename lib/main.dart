import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'providers/auth_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/admin_home_screen.dart';
import 'screens/customer_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "VijayReach",
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF042C53),
            primary: const Color(0xFF042C53),
          ),
        ),
        home: const AuthScreen(),
        routes: {
          '/adminHome': (context) => AdminHomeScreen(),
          '/customerHome': (context) => CustomerHomeScreen(),
        },
      ),
    );
  }
}
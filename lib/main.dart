import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:news_app/app_theme.dart';
import 'package:news_app/features/auth/view/login.dart';
import 'package:news_app/features/auth/view/registration.dart';
import 'package:news_app/features/home/view/home.dart';
import 'package:news_app/firebase_options.dart';
import 'package:provider/provider.dart';

import 'provider/auth_provider.dart';
import 'provider/news_provider.dart';

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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: appTheme(),

        home: const HomeScreen(),

        // home: (FirebaseAuth.instance.currentUser != null)
        //     ? const HomePage()
        //     : const LoginScreen(),
      ),
    );
  }
}

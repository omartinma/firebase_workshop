import 'package:firebase_workshop/l10n/l10n.dart';
import 'package:firebase_workshop/login/login.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(color: Colors.brown),
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
            ),
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.green,
          primarySwatch: Colors.brown,
        ),
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const LoginPage(),
    );
  }
}

import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'firebase_options.dart';
import 'ui/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.web,
    );
  } else {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  Stripe.publishableKey =
      'pk_test_51PoCrn05ZmOEFOYpsrKFgDgpYbMyz2WWl4L3cER5j97ivPXRYk8f4UxQan9XSvt8txam1fi6GYcJDWOYlfCiZIid00PIPoA2eR';

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: kIsWeb
              ? NetworkFileTranslationLoader(
                  baseUri: Uri.parse("assets/i18n/"), // For web platform
                  fallbackFile: 'en',
                  useCountryCode: false,
                )
              : FileTranslationLoader(
                  basePath: 'assets/i18n', // For mobile platforms
                  fallbackFile: 'en',
                  useCountryCode: false,
                ),
        ),
        GlobalMaterialLocalizations
            .delegate, // Add this for Material components
        GlobalWidgetsLocalizations
            .delegate, // Add this for general Flutter widgets
        GlobalCupertinoLocalizations
            .delegate, // Add this for Cupertino components
      ],
      locale: const Locale('es', ''),
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
      title: 'Restaurant Alpha',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

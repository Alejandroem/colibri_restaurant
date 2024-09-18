import 'package:colibri_shared/domain/services/backend_service.dart';
import 'package:colibri_shared/infrastructure/services/firebase_backend_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'ui/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BackendService backendService = FirebaseBackendService();
  await backendService.initializeBackendServices();
  

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
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Restaurant Alpha',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Home(),
    );
  }
}

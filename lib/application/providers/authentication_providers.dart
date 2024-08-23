import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../infrastructure/services/firebase_authentication_service.dart';
import '../notifiers/authentication_state_notifier.dart';

final authenticationServiceProvider = Provider(
  (ref) {
    return FirebaseAuthenticationService();
  },
);

final isAuthenticatedStateNotifierProvider =
    StateNotifierProvider<AuthenticationStateNotifier, bool>(
  (ref) => AuthenticationStateNotifier(
    ref.watch(
      authenticationServiceProvider,
    ),
  ),
);

final authenticatedUserIdStreamProvider = StreamProvider<String?>(
  (ref) {
    final authenticationService = ref.watch(authenticationServiceProvider);
    return authenticationService.getAuthenticatedUserIdStream();
  },
);

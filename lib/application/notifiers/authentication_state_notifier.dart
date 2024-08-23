import 'dart:async';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/authentication_service.dart';

class AuthenticationStateNotifier extends StateNotifier<bool> {
  final AuthenticationService _authenticationService;

  StreamSubscription<bool>? _subscription;
  AuthenticationStateNotifier(this._authenticationService) : super(false) {
    _subscription ??= _authenticationService.isAuthenticatedStream().listen(
      (isAuthenticated) {
        log('AuthenticationStateNotifier: $isAuthenticated');
        state = isAuthenticated;
      },
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

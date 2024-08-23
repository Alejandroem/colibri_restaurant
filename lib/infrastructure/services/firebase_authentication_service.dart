import 'dart:async';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/services/authentication_service.dart';

class FirebaseAuthenticationService extends AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final StreamController<String> _verificationStatusController =
      StreamController<String>.broadcast();

  FirebaseAuthenticationService();

  @override
  Future<void> authenticateWithPhoneNumber(String phoneNumber) async {
    await _firebaseAuth.verifyPhoneNumber(
      autoRetrievedSmsCodeForTesting: "123456",
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        log('Verification completed');
        await _firebaseAuth.signInWithCredential(credential);
        _verificationStatusController.add("verification_completed");
      },
      verificationFailed: (FirebaseAuthException e) {
        log('Verification failed');
        _verificationStatusController.add("verification_failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        log('Code sent');
        _verificationStatusController.add("code_sent");
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        log('Code auto retrieval timeout');
        _verificationStatusController.add("code_auto_retrieval_timeout");
      },
    );
  }

  @override
  Future<void> verifyPhoneNumber(String smsCode) async {}

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Future<bool> isAuthenticated() async {
    return _firebaseAuth.currentUser != null;
  }

  @override
  Stream<bool> isAuthenticatedStream() {
    return _firebaseAuth.authStateChanges().map((user) => user != null);
  }

  @override
  Stream<String> getVerificationStatus() {
    return _verificationStatusController.stream;
  }

  @override
  Stream<String?> getAuthenticatedUserIdStream() {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user != null) {
        return user.uid;
      } else {
        return null;
      }
    });
  }

  @override
  Future<String?> getAuthenticatedUserId() async {
    return _firebaseAuth.currentUser?.uid;
  }
}

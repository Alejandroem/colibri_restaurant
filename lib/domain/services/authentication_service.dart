abstract class AuthenticationService {
  Future<String?> getAuthenticatedUserId();
  Stream<String?> getAuthenticatedUserIdStream();
  Future<bool> isAuthenticated();
  Stream<bool> isAuthenticatedStream();
  Future<void> authenticateWithPhoneNumber(String phoneNumber);
  Future<void> verifyPhoneNumber(String smsCode);
  Future<void> signOut();
  Stream<String> getVerificationStatus();
}

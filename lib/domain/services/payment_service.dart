abstract class PaymentService {
  Future<void> processPayment(
    double amount,
    String email,
  );
}

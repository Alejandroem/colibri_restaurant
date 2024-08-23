import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/services/payment_service.dart';
import '../../infrastructure/services/stripe_payment_service.dart';

final paymentServiceProvider = Provider<PaymentService>((ref) {
  return StripePaymentService();
});

final currentPaymentIdProvider = StateProvider<String?>((ref) => null);

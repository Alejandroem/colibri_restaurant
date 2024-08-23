import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../constants.dart';
import 'package:http/http.dart' as http;

import '../../domain/services/payment_service.dart';

class StripePaymentService extends PaymentService {
  @override
  Future<void> processPayment(
    double amount,
    String email,
  ) async {
    final url = Uri.parse('$kApiUrl/paymentIntent');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'amount': (amount * 100),
        'email': email,
      }),
    );
    if (response.statusCode >= 400) {
      throw Exception('Error code: ${response.statusCode}');
    }

    final body = json.decode(response.body);

    if (body['error'] != null) {
      throw Exception('Error code: ${body['error']}');
    }

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        customFlow: true,
        merchantDisplayName: 'Flutter Stripe Store Demo',
        paymentIntentClientSecret: body['paymentIntent'],
        customerEphemeralKeySecret: body['ephemeralKey'],
        customerId: body['customer'],
        // Extra options
        /* applePay: const PaymentSheetApplePay(
          merchantCountryCode: 'US',
        ), */
        //googlePay: const PaymentSheetGooglePay(merchantCountryCode: 'US'),
        style: ThemeMode.light,
      ),
    );
    await Stripe.instance.presentPaymentSheet();
    await Stripe.instance.confirmPaymentSheetPayment();
  }
}

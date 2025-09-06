import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

enum PaymentStatus { success, canceled, failed }

class PaymentManager {
  Future<PaymentStatus> makePayment(int amount, String currency) async {
    try {
      // 1. Create PaymentIntent
      String clientSecret = await _getClientSecret(
        (amount * 100).toString(), // smallest unit (cents, piasters, etc.)
        currency,
      );

      // 2. Init PaymentSheet
      await _initializePaymentSheet(clientSecret);

      // 3. Present PaymentSheet
      await Stripe.instance.presentPaymentSheet();

      return PaymentStatus.success;
    } on StripeException catch (e) {
      if (e.error.code == FailureCode.Canceled) {
        // User canceled
        return PaymentStatus.canceled;
      } else {
        return PaymentStatus.failed;
      }
    } catch (error) {
      return PaymentStatus.failed;
    }
  }

  Future<void> _initializePaymentSheet(String clientSecret) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: clientSecret,
        merchantDisplayName: "Basel",
      ),
    );
  }

  Future<String> _getClientSecret(String amount, String currency) async {
    Dio dio = Dio();

    try {
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(
          headers: {
            'Authorization': 'Bearer ${dotenv.env['secretKey']}',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
        data: {
          'amount': amount,
          'currency': currency,
          // 'metadata': {'integration_check': 'accept_a_payment'},
        },
      );

      return response.data["client_secret"];
    } catch (e) {
      throw Exception("Failed to create PaymentIntent: $e");
    }
  }
}

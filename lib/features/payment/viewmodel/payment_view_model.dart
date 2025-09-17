import 'package:flutter/material.dart';
import 'package:grocery_app/core/service/payment/payment_service.dart';
import 'package:grocery_app/core/utils/payment/payment_manager.dart';
import 'package:grocery_app/features/payment/model/payment_model.dart';

class PaymentViewModel extends ChangeNotifier {
  final PaymentService paymentService;
  final PaymentManager paymentManager;
  PaymentViewModel({
    required this.paymentService,
    required this.paymentManager,
  });

  bool _isLoading = false;
  String _error = '';

  void setError(String message) {
    _isLoading = false;
    _error = message;
    notifyListeners();
  }

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setSuccess() {
    _isLoading = false;
    _error = '';
    notifyListeners();
  }

  bool get isLoading => _isLoading;

  String get error => _error;

  Future<bool> newPayment({required PaymentModel payment}) async {
    try {
      setLoading(true);
      final amount = int.parse(
        payment.amount.toStringAsFixed(0).replaceAll(',', ''),
      );
      final result = await paymentManager.makePayment(amount, "USD").then((
        value,
      ) {
        if (value == PaymentStatus.success) {
          setSuccess();
          paymentService.newPayment(payment: payment);
          return true;
        } else if (value == PaymentStatus.canceled) {
          setError("Canceled");
          return false;
        } else {
          setError("Failed");
          return false;
        }
      });
      setLoading(false);
      return result;
    } catch (e) {
      setError(e.toString());
      return false;
    }
  }
}

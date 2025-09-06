import 'package:grocery_app/core/service/dio/base_class.dart';
import 'package:grocery_app/core/utils/error/failure.dart';
import 'package:grocery_app/features/payment/model/payment_model.dart';

class PaymentService {
  final DioBaseClient dioBaseClient;

  PaymentService({required this.dioBaseClient});
  String table = "payment";
  Future<void> newPayment({required PaymentModel payment}) async {
    try {
      dioBaseClient.post(url: table, body: payment.toJson());
    } catch (e) {
      throw Failure("Failed to add payment: $e");
    }
  }
}

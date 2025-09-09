import 'package:dio/dio.dart';
import 'package:grocery_app/core/service/dio/base_class.dart';
import 'package:grocery_app/core/utils/error/failure.dart';
import 'package:grocery_app/features/payment/model/payment_model.dart';

class PaymentService {
  final DioBaseClient dioBaseClient;

  PaymentService({required this.dioBaseClient});
  String table = "payments";
  Future<void> newPayment({required PaymentModel payment}) async {
    try {
      await dioBaseClient.post(
        url: table,
        body: payment.toJson(),
        options: Options(),
      );
    } catch (e) {
      throw Failure("Failed to add payment: $e");
    }
  }
}

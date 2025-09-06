class PaymentModel {
  final String? id;
  final String orderId;
  final String userId;
  final double amount;
  final String method; // cash_on_delivery / credit_card / wallet
  final String status; // pending / success / failed
  final DateTime createdAt;

  PaymentModel({
    this.id,
    required this.orderId,
    required this.userId,
    required this.amount,
    required this.method,
    required this.status,
    required this.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      orderId: json['order_id'],
      userId: json['user_id'],
      amount: (json['amount'] as num).toDouble(),
      method: json['method'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() => {
    'order_id': orderId,
    'user_id': userId,
    'amount': amount,
    'method': method,
    'status': status,
  };
}

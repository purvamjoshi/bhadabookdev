import 'package:bhadabook/domain/payment/models/payment_dto.dart';

abstract class PaymentRepository {
  Future<List<Payment>> getPayments();
  Future<void> markPaid(String paymentId, String mode, String? notes);
}

class MockPaymentRepository implements PaymentRepository {
  @override Future<List<Payment>> getPayments() async => [];
  @override Future<void> markPaid(String paymentId, String mode, String? notes) async {}
}

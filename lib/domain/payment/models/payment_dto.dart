enum PaymentStatus { pending, paid, partial, overdue }

class Payment {
  final String id, propertyId, tenantId, agreementId, paymentMode, monthYear, receiptId;
  final int amountPaise;
  final PaymentStatus status;
  final DateTime? paymentDate;
  final String? notes, propertyName, tenantName, unitName, propertyImageUrl;
  final DateTime createdAt, updatedAt;

  const Payment({required this.id, required this.propertyId, required this.tenantId, required this.agreementId, required this.amountPaise, required this.status, required this.paymentMode, required this.monthYear, required this.receiptId, this.paymentDate, this.notes, this.propertyName, this.tenantName, this.unitName, this.propertyImageUrl, required this.createdAt, required this.updatedAt});

  bool get isPaid    => status == PaymentStatus.paid;
  bool get isOverdue => status == PaymentStatus.overdue;
  bool get isPending => status == PaymentStatus.pending;
  double get rupees  => amountPaise / 100;

  Payment copyWith({PaymentStatus? status, int? amountPaise, String? paymentMode, DateTime? paymentDate, String? notes}) =>
      Payment(id: id, propertyId: propertyId, tenantId: tenantId, agreementId: agreementId, amountPaise: amountPaise??this.amountPaise, status: status??this.status, paymentMode: paymentMode??this.paymentMode, monthYear: monthYear, receiptId: receiptId, paymentDate: paymentDate??this.paymentDate, notes: notes??this.notes, propertyName: propertyName, tenantName: tenantName, unitName: unitName, propertyImageUrl: propertyImageUrl, createdAt: createdAt, updatedAt: DateTime.now());
}

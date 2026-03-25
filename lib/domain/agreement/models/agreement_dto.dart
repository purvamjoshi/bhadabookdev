enum AgreementStatus { active, expired, terminated }

class Agreement {
  final String id, propertyId, tenantId;
  final AgreementStatus status;
  final int monthlyRentPaise, securityDepositPaise, rentDueDay;
  final DateTime startDate, moveInDate, endDate, createdAt, updatedAt;
  final List<String> documentUrls;
  // optional: filled from join
  final String? tenantName, tenantPhone, tenantAddress, propertyName, unitName;

  const Agreement({required this.id, required this.propertyId, required this.tenantId, required this.status, required this.monthlyRentPaise, required this.securityDepositPaise, required this.rentDueDay, required this.startDate, required this.moveInDate, required this.endDate, required this.createdAt, required this.updatedAt, this.documentUrls = const [], this.tenantName, this.tenantPhone, this.tenantAddress, this.propertyName, this.unitName});

  bool get isActive  => status == AgreementStatus.active;
  bool get isExpired => status == AgreementStatus.expired;
  int get totalMonths => ((endDate.year - startDate.year) * 12 + endDate.month - startDate.month).clamp(1, 999);
  int get monthsLeft {
    final now = DateTime.now();
    if (endDate.isBefore(now)) return 0;
    return ((endDate.year - now.year) * 12 + (endDate.month - now.month)).clamp(0, 999);
  }
  double get monthlyRentRupees => monthlyRentPaise / 100;
  double get securityDepositRupees => securityDepositPaise / 100;
  String get statusLabel => switch (status) { AgreementStatus.active => 'Active', AgreementStatus.expired => 'Expired', AgreementStatus.terminated => 'Terminated' };
}

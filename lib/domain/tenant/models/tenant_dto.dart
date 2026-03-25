class Tenant {
  final String id, name, phone, permanentAddress;
  final List<String> identityProofUrls;
  final String? currentPropertyId, currentAgreementId;
  final DateTime createdAt, updatedAt;

  const Tenant({required this.id, required this.name, required this.phone, required this.permanentAddress, this.identityProofUrls = const [], this.currentPropertyId, this.currentAgreementId, required this.createdAt, required this.updatedAt});

  bool get hasAgreement => currentAgreementId != null;
  String get initials {
    final p = name.trim().split(' ').where((x) => x.isNotEmpty).toList();
    if (p.isEmpty) return '?';
    return p.length == 1 ? p[0][0].toUpperCase() : '${p[0][0]}${p.last[0]}'.toUpperCase();
  }
  Tenant copyWith({String? name, String? phone, String? permanentAddress, List<String>? identityProofUrls, String? currentPropertyId, String? currentAgreementId}) =>
      Tenant(id: id, name: name??this.name, phone: phone??this.phone, permanentAddress: permanentAddress??this.permanentAddress, identityProofUrls: identityProofUrls??this.identityProofUrls, currentPropertyId: currentPropertyId??this.currentPropertyId, currentAgreementId: currentAgreementId??this.currentAgreementId, createdAt: createdAt, updatedAt: DateTime.now());
}

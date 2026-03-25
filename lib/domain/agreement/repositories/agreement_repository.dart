import 'package:bhadabook/domain/agreement/models/agreement_dto.dart';

abstract class AgreementRepository {
  Future<List<Agreement>> getAgreements();
  Future<void> createAgreement(Agreement agreement);
  Future<void> updateAgreement(Agreement agreement);
}

class MockAgreementRepository implements AgreementRepository {
  @override Future<List<Agreement>> getAgreements() async => [];
  @override Future<void> createAgreement(Agreement agreement) async {}
  @override Future<void> updateAgreement(Agreement agreement) async {}
}

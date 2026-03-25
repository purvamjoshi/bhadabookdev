import 'package:bhadabook/domain/tenant/models/tenant_dto.dart';

abstract class TenantRepository {
  Future<List<Tenant>> getTenants();
  Future<void> addTenant(Tenant tenant);
  Future<void> updateTenant(Tenant tenant);
  Future<void> deleteTenant(String id);
}

class MockTenantRepository implements TenantRepository {
  @override Future<List<Tenant>> getTenants() async => [];
  @override Future<void> addTenant(Tenant tenant) async {}
  @override Future<void> updateTenant(Tenant tenant) async {}
  @override Future<void> deleteTenant(String id) async {}
}

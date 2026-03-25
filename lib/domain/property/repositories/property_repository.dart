import 'package:bhadabook/domain/property/models/property_dto.dart';

abstract class PropertyRepository {
  Future<List<Property>> getProperties();
  Future<void> addProperty(Property property);
  Future<void> updateProperty(Property property);
  Future<void> deleteProperty(String id);
}

class MockPropertyRepository implements PropertyRepository {
  @override Future<List<Property>> getProperties() async => [];
  @override Future<void> addProperty(Property property) async {}
  @override Future<void> updateProperty(Property property) async {}
  @override Future<void> deleteProperty(String id) async {}
}

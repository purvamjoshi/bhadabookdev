import 'package:bhadabook/domain/auth/models/user_dto.dart';

abstract class AuthRepository {
  Future<AppUser?> getCurrentUser();
  Future<void> signOut();
}

class MockAuthRepository implements AuthRepository {
  @override Future<AppUser?> getCurrentUser() async => null;
  @override Future<void> signOut() async {}
}

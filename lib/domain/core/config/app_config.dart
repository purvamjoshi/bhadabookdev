import 'package:flutter/material.dart';
import 'package:bhadabook/domain/core/config/flavor_config.dart';
import 'package:bhadabook/domain/auth/models/user_dto.dart';

/// InheritedWidget that provides app-level configuration down the tree.
class AppConfig extends InheritedWidget {
  const AppConfig({super.key, required this.flavor, required super.child});
  final FlavorConfig flavor;

  static AppConfig? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppConfig>();

  @override
  bool updateShouldNotify(AppConfig old) => old.flavor != flavor;
}

/// Global mutable app state — auth user, theme, language.
class AppStateNotifier extends ChangeNotifier {
  AppUser? _user;
  bool _onboarded = false;

  AppUser? get user => _user;
  bool get onboarded => _onboarded;
  bool get isAuthenticated => _user != null;

  void updateUser(AppUser user, {bool onboarded = false}) {
    _user = user;
    _onboarded = onboarded;
    notifyListeners();
  }

  void setOnboarded() {
    _onboarded = true;
    notifyListeners();
  }

  void clearUser() {
    _user = null;
    _onboarded = false;
    notifyListeners();
  }
}

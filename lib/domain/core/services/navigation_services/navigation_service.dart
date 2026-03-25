import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  Future<dynamic>? navigateTo(String routeName, {Object? arguments}) =>
      navigationKey.currentState?.pushNamed(routeName, arguments: arguments);

  Future<dynamic>? replaceWith(String routeName, {Object? arguments}) =>
      navigationKey.currentState?.pushReplacementNamed(routeName, arguments: arguments);

  Future<dynamic>? pushAndRemoveAll(String routeName, {Object? arguments}) =>
      navigationKey.currentState?.pushNamedAndRemoveUntil(
        routeName, (route) => false, arguments: arguments);

  void goBack([dynamic result]) => navigationKey.currentState?.pop(result);

  void popToRoot() => navigationKey.currentState?.popUntil((r) => r.isFirst);

  bool canGoBack() => navigationKey.currentState?.canPop() ?? false;
}

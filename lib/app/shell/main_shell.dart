import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/widgets/bb_bottom_nav.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static int _indexOf(String location) {
    if (location.startsWith('/properties')) return 1;
    if (location.startsWith('/tenants'))    return 2;
    if (location.startsWith('/profile'))    return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    return Scaffold(
      body: child,
      bottomNavigationBar: BBBottomNav(
        current: _indexOf(location),
        onTap: (i) {
          switch (i) {
            case 0: context.go('/home');        break;
            case 1: context.go('/properties');  break;
            case 2: context.go('/tenants');      break;
            case 3: context.go('/profile');      break;
          }
        },
      ),
    );
  }
}

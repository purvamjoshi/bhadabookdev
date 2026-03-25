import 'package:flutter/material.dart';
import 'package:bhadabook/presentation/core/widgets/bb_bottom_nav.dart';
import 'package:bhadabook/presentation/home/home_screen.dart';
import 'package:bhadabook/presentation/property/properties_list_screen.dart';
import 'package:bhadabook/presentation/tenant/tenants_list_screen.dart';
import 'package:bhadabook/presentation/profile/profile_screen.dart';

class MainShell extends StatefulWidget {
  final int initialTab;
  const MainShell({super.key, this.initialTab = 0});
  @override State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _tab;

  @override
  void initState() {
    super.initState();
    _tab = widget.initialTab;
  }

  static const _screens = [HomeScreen(), PropertiesListScreen(), TenantsListScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: IndexedStack(index: _tab, children: _screens),
    bottomNavigationBar: BBBottomNav(
      current: _tab,
      onTap: (i) => setState(() => _tab = i),
    ),
  );
}

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class BBBottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;
  const BBBottomNav({super.key, required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      color: AppColors.white,
      border: Border(top: BorderSide(color: AppColors.border)),
      boxShadow: [BoxShadow(color: Color(0x10000000), blurRadius: 16, offset: Offset(0, -4))],
    ),
    child: SafeArea(top: false, child: SizedBox(height: 60, child: Row(children: [
      _Item(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home', active: current == 0, onTap: () => onTap(0)),
      _Item(icon: Icons.apartment_outlined, activeIcon: Icons.apartment_rounded, label: 'Properties', active: current == 1, onTap: () => onTap(1)),
      _Item(icon: Icons.people_outline_rounded, activeIcon: Icons.people_rounded, label: 'Tenants', active: current == 2, onTap: () => onTap(2)),
      _Item(icon: Icons.person_outline_rounded, activeIcon: Icons.person_rounded, label: 'Profile', active: current == 3, onTap: () => onTap(3)),
    ]))),
  );
}

class _Item extends StatelessWidget {
  final IconData icon, activeIcon; final String label; final bool active; final VoidCallback onTap;
  const _Item({required this.icon, required this.activeIcon, required this.label, required this.active, required this.onTap});
  @override
  Widget build(BuildContext context) => Expanded(child: InkWell(onTap: onTap, child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(active ? activeIcon : icon, color: active ? AppColors.primary : AppColors.grey400, size: 22),
    const SizedBox(height: 2),
    Text(label, style: TextStyle(fontFamily: 'Poppins', fontSize: 10, fontWeight: active ? FontWeight.w600 : FontWeight.w400, color: active ? AppColors.primary : AppColors.grey400)),
  ])));
}

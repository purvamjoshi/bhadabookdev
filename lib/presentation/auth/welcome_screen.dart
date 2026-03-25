import 'package:flutter/material.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/domain/core/constants/app_spacing.dart';
import 'package:bhadabook/domain/core/config/injection.dart';
import 'package:bhadabook/domain/core/services/navigation_services/navigation_service.dart';
import 'package:bhadabook/domain/core/services/navigation_services/routers/route_name.dart';
import 'package:bhadabook/presentation/core/widgets/bb_button.dart';
import 'package:bhadabook/presentation/auth/splash_screen.dart' show _GridPainter;

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        // Light gradient background
        Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: AppColors.gradientLight))),
        // Subtle grid
        Positioned.fill(child: Opacity(opacity: 0.10, child: CustomPaint(painter: _GridPainter()))),
        // City illustration placeholder
        Positioned(top: 40, left: 0, right: 0, bottom: 340,
          child: Center(child: Stack(alignment: Alignment.bottomCenter, children: [
            // Buildings
            Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
              _Building(w: 45, h: 160, color: AppColors.primary.withOpacity(0.35)),
              const SizedBox(width: 4),
              _Building(w: 55, h: 220, color: AppColors.primary.withOpacity(0.50)),
              const SizedBox(width: 4),
              _Building(w: 40, h: 140, color: AppColors.primary.withOpacity(0.30)),
              const SizedBox(width: 6),
              _Building(w: 70, h: 260, color: AppColors.primary.withOpacity(0.60)),
              const SizedBox(width: 4),
              _Building(w: 50, h: 190, color: AppColors.primary.withOpacity(0.45)),
              const SizedBox(width: 4),
              _Building(w: 38, h: 120, color: AppColors.primary.withOpacity(0.28)),
              const SizedBox(width: 4),
              _Building(w: 60, h: 200, color: AppColors.primary.withOpacity(0.48)),
            ]),
          ])),
        ),
        // Bottom card
        Align(alignment: Alignment.bottomCenter, child: Container(
          decoration: const BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
          padding: const EdgeInsets.fromLTRB(S.page, 24, S.page, 0),
          child: SafeArea(top: false, child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Row(children: [
              Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.primarySurface, borderRadius: BorderRadius.circular(6)), child: const Icon(Icons.menu_book_rounded, color: AppColors.primary, size: 16)),
              const SizedBox(width: 8),
              Text('BhadaBook', style: T.bodyMd.copyWith(fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 14),
            Text('Everything Your\nProperty Needs,\nIn One Place', style: T.h1.copyWith(fontSize: 26, height: 1.2)),
            const SizedBox(height: 10),
            Text('Track vacant units, manage tenant details, and stay on top of your properties with a simpler, smarter way to manage it all.', style: T.bodySm.copyWith(height: 1.6)),
            const SizedBox(height: 22),
            BBButton(label: 'GET STARTED', onPressed: () => navigator<NavigationService>().navigateTo(AppRoutes.phone)),
            const SizedBox(height: 18),
          ])),
        )),
      ]),
    );
  }
}

class _Building extends StatelessWidget {
  final double w, h; final Color color;
  const _Building({required this.w, required this.h, required this.color});
  @override
  Widget build(BuildContext context) => Container(
    width: w, height: h,
    decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(4))),
    child: Column(children: [
      const SizedBox(height: 8),
      ...List.generate(((h - 20) / 18).floor(), (_) => Padding(padding: const EdgeInsets.only(bottom: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: List.generate((w/10).floor().clamp(1, 4), (_) => Container(width: 6, height: 8, decoration: BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(1))))))),
    ]),
  );
}

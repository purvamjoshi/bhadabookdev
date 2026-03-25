import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bhadabook/domain/core/constants/app_colors.dart';
import 'package:bhadabook/domain/core/constants/app_text_styles.dart';
import 'package:bhadabook/presentation/auth/bloc/auth_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fade, _scale;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.light));
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000))..forward();
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _scale = Tween<double>(begin: 0.82, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    Future.delayed(const Duration(milliseconds: 2200), () { if (mounted) context.read<AuthBloc>().add(AuthCheckRequested()); });
  }

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) => Scaffold(body: Stack(children: [
    // Dark gradient background
    Container(decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: AppColors.gradientDark, stops: [0.0, 0.45, 1.0]))),
    // Block pattern
    Positioned.fill(child: Opacity(opacity: 0.07, child: CustomPaint(painter: _GridPainter()))),
    // Logo
    Center(child: FadeTransition(opacity: _fade, child: ScaleTransition(scale: _scale, child: const _Logo(light: true)))),
  ]));
}

class _Logo extends StatelessWidget {
  final bool light;
  const _Logo({this.light = true});
  @override
  Widget build(BuildContext context) {
    final c = light ? AppColors.white : AppColors.navy;
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Container(width: 40, height: 40, decoration: BoxDecoration(color: light ? AppColors.white.withOpacity(0.15) : AppColors.primarySurface, borderRadius: BorderRadius.circular(10)), child: Icon(Icons.menu_book_rounded, color: c, size: 24)),
      const SizedBox(width: 10),
      Text('BhadaBook', style: TextStyle(fontFamily: 'Poppins', fontSize: 28, fontWeight: FontWeight.w700, color: c, letterSpacing: -0.5)),
    ]);
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas c, Size s) {
    final p = Paint()..color = Colors.white..strokeWidth = 0.8;
    for (double x = 0; x < s.width; x += 28) c.drawLine(Offset(x, 0), Offset(x, s.height), p);
    for (double y = 0; y < s.height; y += 28) c.drawLine(Offset(0, y), Offset(s.width, y), p);
  }
  @override bool shouldRepaint(_) => false;
}

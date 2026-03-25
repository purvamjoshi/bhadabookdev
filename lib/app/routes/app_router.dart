import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/auth/presentation/screens/phone_input_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step1_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step2_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_step3_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/property/presentation/screens/properties_list_screen.dart';
import '../../features/property/presentation/screens/property_detail_screen.dart';
import '../../features/property/presentation/screens/add_property_screen.dart';
import '../../features/property/presentation/screens/edit_property_screen.dart';
import '../../features/tenant/presentation/screens/tenants_list_screen.dart';
import '../../features/tenant/presentation/screens/tenant_detail_screen.dart';
import '../../features/tenant/presentation/screens/add_tenant_screen.dart';
import '../../features/agreement/presentation/screens/step1_tenant_details.dart';
import '../../features/agreement/presentation/screens/step2_rent_details.dart';
import '../../features/agreement/presentation/screens/step3_agreement_dates.dart';
import '../../features/agreement/presentation/screens/agreement_success_screen.dart';
import '../../features/payment/presentation/screens/mark_payment_screen.dart';
import '../../features/payment/presentation/screens/rent_receipt_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/account_screen.dart';
import '../../features/profile/presentation/screens/language_screen.dart';
import '../../features/profile/presentation/screens/notification_settings_screen.dart';
import '../../features/profile/presentation/screens/terms_screen.dart';
import '../../features/profile/presentation/screens/privacy_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/payment/domain/entities/payment.dart';
import '../shell/main_shell.dart';

GoRouter buildRouter(AuthBloc authBloc) {
  final notifier = _BlocNotifier(authBloc);
  return GoRouter(
  initialLocation: '/',
  refreshListenable: notifier,
  redirect: (ctx, state) {
    final authState = authBloc.state;
    final isAuth    = authState is AuthAuthenticated;
    final onboarded = isAuth ? authState.onboarded : false;
    final loc       = state.uri.toString();

    // Auth routes — don't redirect if already heading there
    final inAuthFlow = loc == '/' || loc.startsWith('/welcome') || loc.startsWith('/phone') || loc.startsWith('/otp');
    if (!isAuth && !inAuthFlow) return '/welcome';
    if (isAuth && !onboarded && !loc.startsWith('/onboarding')) return '/onboarding/step1';
    if (isAuth && onboarded && inAuthFlow) return '/home';
    return null;
  },
  routes: [
    // ── Auth ──────────────────────────────────────────────────────────────
    GoRoute(path: '/',        builder: (_, __) => const SplashScreen()),
    GoRoute(path: '/welcome', builder: (_, __) => const WelcomeScreen()),
    GoRoute(path: '/phone',   builder: (_, __) => const PhoneInputScreen()),
    GoRoute(path: '/otp',     builder: (_, s)  => OtpScreen(phone: s.extra as String? ?? '')),

    // ── Onboarding ────────────────────────────────────────────────────────
    GoRoute(path: '/onboarding/step1', builder: (_, __) => const OnboardingStep1Screen()),
    GoRoute(path: '/onboarding/step2', builder: (_, __) => const OnboardingStep2Screen()),
    GoRoute(path: '/onboarding/step3', builder: (_, __) => const OnboardingStep3Screen()),

    // ── Main Shell ────────────────────────────────────────────────────────
    ShellRoute(
      builder: (_, state, child) => MainShell(child: child),
      routes: [
        GoRoute(path: '/home',       builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/properties', builder: (_, __) => const PropertiesListScreen()),
        GoRoute(path: '/tenants',    builder: (_, __) => const TenantsListScreen()),
        GoRoute(path: '/profile',    builder: (_, __) => const ProfileScreen()),
      ],
    ),

    // ── Property detail / add / edit ──────────────────────────────────────
    GoRoute(path: '/properties/add',       builder: (_, __) => const AddPropertyScreen()),
    GoRoute(path: '/properties/:id',       builder: (_, s)  => PropertyDetailScreen(propertyId: s.pathParameters['id']!)),
    GoRoute(path: '/properties/:id/edit',  builder: (_, s)  => EditPropertyScreen(propertyId: s.pathParameters['id']!)),

    // ── Tenant detail / add ───────────────────────────────────────────────
    GoRoute(path: '/tenants/add',          builder: (_, s)  => AddTenantScreen(propertyId: s.extra as String?)),
    GoRoute(path: '/tenants/:id',          builder: (_, s)  => TenantDetailScreen(tenantId: s.pathParameters['id']!)),

    // ── Agreement flow ────────────────────────────────────────────────────
    GoRoute(path: '/agreement/step1',      builder: (_, s)  => AgreementStep1Screen(extra: (s.extra as Map<String, dynamic>?) ?? {})),
    GoRoute(path: '/agreement/step2',      builder: (_, s)  => AgreementStep2Screen(extra: (s.extra as Map<String, dynamic>?) ?? {})),
    GoRoute(path: '/agreement/step3',      builder: (_, s)  => AgreementStep3Screen(extra: (s.extra as Map<String, dynamic>?) ?? {})),
    GoRoute(path: '/agreement/success',    builder: (_, __) => const AgreementSuccessScreen()),

    // ── Payment ───────────────────────────────────────────────────────────
    GoRoute(path: '/mark-paid',            builder: (_, s)  => MarkPaymentScreen(payment: s.extra as Payment)),
    GoRoute(path: '/receipt',              builder: (_, s)  => RentReceiptScreen(payment: s.extra as Payment)),

    // ── Profile sub-screens ───────────────────────────────────────────────
    GoRoute(path: '/profile/account',                 builder: (_, __) => const AccountScreen()),
    GoRoute(path: '/profile/language',                builder: (_, __) => const LanguageScreen()),
    GoRoute(path: '/profile/notification-settings',   builder: (_, __) => const NotificationSettingsScreen()),
    GoRoute(path: '/profile/terms',                   builder: (_, __) => const TermsScreen()),
    GoRoute(path: '/profile/privacy',                 builder: (_, __) => const PrivacyScreen()),

    // ── Notifications ─────────────────────────────────────────────────────
    GoRoute(path: '/notifications',        builder: (_, __) => const NotificationsScreen()),
  ],
  );
}

class _BlocNotifier extends ChangeNotifier {
  _BlocNotifier(AuthBloc bloc) { bloc.stream.listen((_) => notifyListeners()); }
}

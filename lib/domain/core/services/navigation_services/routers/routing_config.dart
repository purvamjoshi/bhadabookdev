import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform, TargetPlatform;
import 'route_name.dart';
import 'package:bhadabook/presentation/auth/splash_screen.dart';
import 'package:bhadabook/presentation/auth/welcome_screen.dart';
import 'package:bhadabook/presentation/auth/phone_input_screen.dart';
import 'package:bhadabook/presentation/auth/otp_screen.dart';
import 'package:bhadabook/presentation/onboarding/onboarding_step1_screen.dart';
import 'package:bhadabook/presentation/onboarding/onboarding_step2_screen.dart';
import 'package:bhadabook/presentation/onboarding/onboarding_step3_screen.dart';
import 'package:bhadabook/presentation/shell/main_shell.dart';
import 'package:bhadabook/presentation/home/home_screen.dart';
import 'package:bhadabook/presentation/property/properties_list_screen.dart';
import 'package:bhadabook/presentation/property/property_detail_screen.dart';
import 'package:bhadabook/presentation/property/add_property_screen.dart';
import 'package:bhadabook/presentation/property/edit_property_screen.dart';
import 'package:bhadabook/presentation/tenant/tenants_list_screen.dart';
import 'package:bhadabook/presentation/tenant/tenant_detail_screen.dart';
import 'package:bhadabook/presentation/tenant/add_tenant_screen.dart';
import 'package:bhadabook/presentation/agreement/step1_tenant_details.dart';
import 'package:bhadabook/presentation/agreement/step2_rent_details.dart';
import 'package:bhadabook/presentation/agreement/step3_agreement_dates.dart';
import 'package:bhadabook/presentation/agreement/agreement_success_screen.dart';
import 'package:bhadabook/presentation/payment/mark_payment_screen.dart';
import 'package:bhadabook/presentation/payment/rent_receipt_screen.dart';
import 'package:bhadabook/presentation/profile/profile_screen.dart';
import 'package:bhadabook/presentation/profile/account_screen.dart';
import 'package:bhadabook/presentation/profile/language_screen.dart';
import 'package:bhadabook/presentation/profile/notification_settings_screen.dart';
import 'package:bhadabook/presentation/profile/terms_screen.dart';
import 'package:bhadabook/presentation/profile/privacy_screen.dart';
import 'package:bhadabook/presentation/notifications/notifications_screen.dart';
import 'package:bhadabook/domain/payment/models/payment_dto.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  final args = settings.arguments;
  Widget page;

  switch (settings.name) {
    case AppRoutes.splash:   page = const SplashScreen(); break;
    case AppRoutes.welcome:  page = const WelcomeScreen(); break;
    case AppRoutes.phone:    page = const PhoneInputScreen(); break;
    case AppRoutes.otp:      page = OtpScreen(phone: args as String? ?? ''); break;

    case AppRoutes.onboardStep1: page = const OnboardingStep1Screen(); break;
    case AppRoutes.onboardStep2: page = const OnboardingStep2Screen(); break;
    case AppRoutes.onboardStep3: page = const OnboardingStep3Screen(); break;

    case AppRoutes.home:
      page = const MainShell(initialTab: 0); break;
    case AppRoutes.properties:
      page = const MainShell(initialTab: 1); break;
    case AppRoutes.tenants:
      page = const MainShell(initialTab: 2); break;
    case AppRoutes.profile:
      page = const MainShell(initialTab: 3); break;

    case AppRoutes.addProperty:    page = const AddPropertyScreen(); break;
    case AppRoutes.propertyDetail: page = PropertyDetailScreen(propertyId: args as String); break;
    case AppRoutes.editProperty:   page = EditPropertyScreen(propertyId: args as String); break;

    case AppRoutes.addTenant:    page = AddTenantScreen(propertyId: args as String?); break;
    case AppRoutes.tenantDetail: page = TenantDetailScreen(tenantId: args as String); break;

    case AppRoutes.agreementStep1:   page = AgreementStep1Screen(extra: args as Map<String, dynamic>? ?? {}); break;
    case AppRoutes.agreementStep2:   page = AgreementStep2Screen(extra: args as Map<String, dynamic>? ?? {}); break;
    case AppRoutes.agreementStep3:   page = AgreementStep3Screen(extra: args as Map<String, dynamic>? ?? {}); break;
    case AppRoutes.agreementSuccess: page = const AgreementSuccessScreen(); break;

    case AppRoutes.markPaid: page = MarkPaymentScreen(payment: args as Payment); break;
    case AppRoutes.receipt:  page = RentReceiptScreen(payment: args as Payment); break;

    case AppRoutes.account:              page = const AccountScreen(); break;
    case AppRoutes.language:             page = const LanguageScreen(); break;
    case AppRoutes.notificationSettings: page = const NotificationSettingsScreen(); break;
    case AppRoutes.terms:                page = const TermsScreen(); break;
    case AppRoutes.privacy:              page = const PrivacyScreen(); break;
    case AppRoutes.notifications:        page = const NotificationsScreen(); break;

    default: page = const SplashScreen();
  }

  return _getPageRoute(page, settings);
}

Route<dynamic> _getPageRoute(Widget page, RouteSettings settings) {
  if (defaultTargetPlatform == TargetPlatform.iOS) {
    return CupertinoPageRoute(builder: (_) => page, settings: settings);
  }
  return MaterialPageRoute(builder: (_) => page, settings: settings);
}

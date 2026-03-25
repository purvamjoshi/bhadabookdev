class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash   = '/';
  static const String welcome  = '/welcome';
  static const String phone    = '/phone';
  static const String otp      = '/otp';

  // Onboarding
  static const String onboardStep1 = '/onboarding/step1';
  static const String onboardStep2 = '/onboarding/step2';
  static const String onboardStep3 = '/onboarding/step3';

  // Main tabs
  static const String home       = '/home';
  static const String properties = '/properties';
  static const String tenants    = '/tenants';
  static const String profile    = '/profile';

  // Property
  static const String addProperty    = '/properties/add';
  static const String propertyDetail = '/properties/detail';
  static const String editProperty   = '/properties/edit';

  // Tenant
  static const String addTenant    = '/tenants/add';
  static const String tenantDetail = '/tenants/detail';

  // Agreement
  static const String agreementStep1   = '/agreement/step1';
  static const String agreementStep2   = '/agreement/step2';
  static const String agreementStep3   = '/agreement/step3';
  static const String agreementSuccess = '/agreement/success';

  // Payment
  static const String markPaid = '/mark-paid';
  static const String receipt  = '/receipt';

  // Profile sub
  static const String account              = '/profile/account';
  static const String language             = '/profile/language';
  static const String notificationSettings = '/profile/notifications';
  static const String terms                = '/profile/terms';
  static const String privacy              = '/profile/privacy';

  // Notifications
  static const String notifications = '/notifications';
}

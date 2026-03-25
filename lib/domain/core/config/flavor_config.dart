enum Flavor { dev, staging, prod }

/// Pure data class — no static state. Pass via constructor through main.dart.
class FlavorConfig {
  final Flavor flavor;
  final String appName;
  final String bundleId;
  final bool showDebugBanner;

  const FlavorConfig({
    required this.flavor,
    required this.appName,
    required this.bundleId,
    this.showDebugBanner = false,
  });

  bool get isDev     => flavor == Flavor.dev;
  bool get isStaging => flavor == Flavor.staging;
  bool get isProd    => flavor == Flavor.prod;
}

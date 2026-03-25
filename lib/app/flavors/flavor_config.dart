enum Flavor { dev, staging, prod }

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

  static FlavorConfig _instance = const FlavorConfig(
    flavor: Flavor.dev,
    appName: 'BhadaBook Dev',
    bundleId: 'com.bhadabook.dev',
    showDebugBanner: true,
  );

  static FlavorConfig get instance => _instance;
  static void initialize(FlavorConfig config) => _instance = config;

  bool get isDev => flavor == Flavor.dev;
  bool get isProd => flavor == Flavor.prod;
}

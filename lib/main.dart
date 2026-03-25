import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app/app.dart';
import 'app/flavors/flavor_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  FlavorConfig.initialize(const FlavorConfig(
    flavor: Flavor.dev,
    appName: 'BhadaBook Dev',
    bundleId: 'com.bhadabook.dev',
    showDebugBanner: true,
  ));

  runApp(const BhadaBookApp());
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bhadabook/app.dart';
import 'package:bhadabook/domain/core/config/flavor_config.dart';
import 'package:bhadabook/domain/core/config/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  setupLocator();

  const flavor = FlavorConfig(
    flavor: Flavor.dev,
    appName: 'BhadaBook Dev',
    bundleId: 'com.bhadabook.dev',
    showDebugBanner: true,
  );

  runApp(const BhadaBookApp(flavor: flavor));
}

import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:pds_front/app/core/navigation/route_manager.dart';

void main() {
  usePathUrlStrategy();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     initialRoute: RouteManager.splash,
  //     onGenerateRoute: RouteManager.generateRoute,
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouteManager.router,
    );
  }
}

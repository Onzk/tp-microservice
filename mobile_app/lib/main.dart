import 'package:billing_app/properties.dart';
import 'package:billing_app/providers/bill_detail_provider.dart';
import 'package:billing_app/providers/bill_provider.dart';
import 'package:billing_app/providers/client_provider.dart';
import 'package:billing_app/providers/product_provider.dart';
import 'package:billing_app/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ClientProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => BillProvider()),
        ChangeNotifierProvider(create: (_) => BillDetailProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billing APP',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: generateMaterialColor(baseColor),
          useMaterial3: false,
          scaffoldBackgroundColor: Colors.white,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            elevation: 8,
            type: BottomNavigationBarType.shifting,
          )
          // inputDecorationTheme: InputDecorationTheme(
          //   border: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          // ),
          ),
      home: const SplashScreen(),
    );
  }
}

MaterialColor generateMaterialColor(Color color) {
  List strengths = <double>[.05];
  final swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

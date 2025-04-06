import 'dart:async';

import 'package:billing_app/properties.dart';
import 'package:billing_app/screens/base_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    if (!mounted) return;
    Timer(const Duration(seconds: 2), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const BaseScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Image.asset(
                'assets/logo.png',
                width: 175,
                color: baseColor,
              ),
              const Spacer(),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .75,
                child: const Text(
                  "BillApp",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: baseColor,
                    height: 2,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const LinearProgressIndicator(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                minHeight: 4,
                backgroundColor: Colors.transparent,
                color: baseColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

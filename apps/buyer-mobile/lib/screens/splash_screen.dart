import 'package:flutter/material.dart';

import '../widgets/brand_lockup.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Semantics(
                label: 'MateryalPH mark',
                image: true,
                child: Image.asset(
                  'assets/branding/materyalph-mark.png',
                  width: 80,
                  height: 80,
                  filterQuality: FilterQuality.medium,
                ),
              ),
              const SizedBox(height: 18),
              const BrandLockup(),
              const SizedBox(height: 32),
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

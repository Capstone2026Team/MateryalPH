import 'package:flutter/material.dart';

import '../design_system/theme.dart';
import '../widgets/brand_lockup.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
    required this.onGoogle,
  });

  final VoidCallback onLogin;
  final VoidCallback onRegister;
  final Future<void> Function() onGoogle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Positioned(
            right: -84,
            top: -118,
            child: _WelcomeOrb(size: 260, color: BuyerTheme.action),
          ),
          const Positioned(
            right: 52,
            top: -88,
            child: _WelcomeOrb(size: 210, color: BuyerTheme.brandSoft),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          24,
                          constraints.maxHeight < 600 ? 48 : 132,
                          24,
                          20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Center(child: BrandLockup()),
                            const SizedBox(height: 24),
                            const Spacer(flex: 2),
                            Text(
                              'Welcome to\nMateryalPH',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.displaySmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    height: 1.08,
                                  ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Create an account to discover suppliers, compare materials, and manage your construction purchases.',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: BuyerTheme.muted,
                                    height: 1.5,
                                  ),
                            ),
                            const Spacer(flex: 3),
                            const SizedBox(height: 32),
                            FilledButton(
                              onPressed: onRegister,
                              child: const Text('Create buyer account'),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              onPressed: onGoogle,
                              icon: const Text(
                                'G',
                                style: TextStyle(fontWeight: FontWeight.w800),
                              ),
                              label: const Text('Continue with Google'),
                            ),
                            const SizedBox(height: 16),
                            TextButton(
                              onPressed: onLogin,
                              child: const Text(
                                'Already have an account? Sign in',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeOrb extends StatelessWidget {
  const _WelcomeOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}

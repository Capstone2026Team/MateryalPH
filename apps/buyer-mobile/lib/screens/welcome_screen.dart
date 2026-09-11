import 'package:flutter/material.dart';

import '../design_system/theme.dart';
import '../widgets/brand_lockup.dart';

class WelcomeScreen extends StatefulWidget {
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
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _openingGoogle = false;

  Future<void> _google() async {
    setState(() => _openingGoogle = true);
    try {
      await widget.onGoogle();
    } finally {
      if (mounted) setState(() => _openingGoogle = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: LayoutBuilder(
            builder: (context, constraints) => SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: BrandLockup(compact: true),
                  ),
                  Image.asset(
                    'assets/onboarding/source-smart.png',
                    height: (constraints.maxHeight * .24).clamp(120.0, 200.0),
                    fit: BoxFit.contain,
                    excludeFromSemantics: true,
                    cacheWidth: 960,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to\nMateryalPH',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'A better start for your next build. Connect with construction-material suppliers and prepare your Buyer account.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: BuyerTheme.muted,
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: _openingGoogle ? null : widget.onRegister,
                    child: const Text('Create buyer account'),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: _openingGoogle ? null : _google,
                    child: Text(
                      _openingGoogle
                          ? 'Opening Google…'
                          : 'Continue with Google',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: _openingGoogle ? null : widget.onLogin,
                    child: const Text('Already have an account? Sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

import 'package:flutter/material.dart';

import '../design_system/theme.dart';
import '../widgets/brand_lockup.dart';
import '../widgets/auth_content.dart';

class BuyerHomeScreen extends StatefulWidget {
  const BuyerHomeScreen({super.key, required this.onSignOut});

  final Future<void> Function() onSignOut;

  @override
  State<BuyerHomeScreen> createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  bool _signingOut = false;
  String? _error;
  Future<void> _signOut() async {
    setState(() {
      _signingOut = true;
      _error = null;
    });
    try {
      await widget.onSignOut();
    } catch (_) {
      if (mounted) {
        setState(
          () => _error =
              'Sign-out could not finish. Check your connection and try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _signingOut = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const BrandLockup(compact: true),
        actions: [
          IconButton(
            onPressed: _signingOut ? null : _signOut,
            tooltip: 'Sign out',
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
          children: [
            Text(
              'Your Buyer workspace',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 24),
            if (_error != null) ...[
              AuthNotice(message: _error!, isError: true),
              const SizedBox(height: 16),
            ],
            if (_signingOut) const AuthNotice(message: 'Signing out securely…'),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    color: BuyerTheme.action,
                    size: 36,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Buyer account connected',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'You are securely signed in. Supplier discovery and project tools are not available in this workspace yet.',
                    style: TextStyle(color: BuyerTheme.muted, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

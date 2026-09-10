import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../auth/auth_repository.dart';

Future<String?> requestRiskProof(
  BuildContext context,
  AuthRepository repository,
  BuyerRiskChallenge challenge,
  String email,
) {
  return Navigator.of(context).push<String>(
    MaterialPageRoute(
      builder: (_) => RiskOtpScreen(
        repository: repository,
        challenge: challenge,
        email: email,
      ),
    ),
  );
}

class RiskOtpScreen extends StatefulWidget {
  const RiskOtpScreen({
    super.key,
    required this.repository,
    required this.challenge,
    required this.email,
  });
  final AuthRepository repository;
  final BuyerRiskChallenge challenge;
  final String email;
  @override
  State<RiskOtpScreen> createState() => _RiskOtpScreenState();
}

class _RiskOtpScreenState extends State<RiskOtpScreen> {
  final _code = TextEditingController();
  final _form = GlobalKey<FormState>();
  Timer? _timer;
  late int _resendIn;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _resendIn = widget.challenge.resendAfterSeconds;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted && _resendIn > 0) setState(() => _resendIn--);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    super.dispose();
  }

  Future<void> _verify() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final proof = await widget.repository.verifyRiskChallenge(
        widget.challenge,
        widget.email,
        _code.text,
      );
      if (mounted) Navigator.of(context).pop(proof);
    } on BuyerAuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.repository.resendRiskChallenge(
        widget.challenge,
        widget.email,
      );
      if (mounted) {
        setState(() => _resendIn = widget.challenge.resendAfterSeconds);
      }
    } on BuyerAuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Security check')),
    body: SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Form(
              key: _form,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    size: 40,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Confirm this request',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Enter the risk-verification code from your email. This security check is separate from account verification or a password-reset code.',
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _code,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'Risk-verification code',
                      counterText: '',
                    ),
                    validator: (value) =>
                        RegExp(r'^\d{6}$').hasMatch(value ?? '')
                        ? null
                        : 'Enter the six-digit code.',
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Semantics(
                        liveRegion: true,
                        child: Text(
                          _error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _busy ? null : _verify,
                    child: Text(_busy ? 'Verifying…' : 'Verify and continue'),
                  ),
                  TextButton(
                    onPressed: _busy || _resendIn > 0 ? null : _resend,
                    child: Text(
                      _resendIn > 0
                          ? 'Request another code in ${_resendIn}s'
                          : 'Request another code',
                    ),
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

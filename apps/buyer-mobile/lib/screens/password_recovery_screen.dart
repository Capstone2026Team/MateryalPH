import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../auth/auth_repository.dart';
import 'risk_otp_screen.dart';

class PasswordRecoveryScreen extends StatefulWidget {
  const PasswordRecoveryScreen({
    super.key,
    required this.authRepository,
    required this.onComplete,
    required this.onBack,
  });

  final AuthRepository authRepository;
  final VoidCallback onComplete;
  final VoidCallback onBack;

  @override
  State<PasswordRecoveryScreen> createState() => _PasswordRecoveryScreenState();
}

class _PasswordRecoveryScreenState extends State<PasswordRecoveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _code = TextEditingController();
  final _password = TextEditingController();
  bool _codeRequested = false;
  bool _submitting = false;
  bool _obscurePassword = true;
  String? _message;

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit({String? proof}) async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _message = null;
    });
    try {
      if (!_codeRequested) {
        await widget.authRepository.requestPasswordRecovery(
          _email.text,
          proof: proof,
        );
        if (mounted) {
          setState(() {
            _codeRequested = true;
            _message =
                'If that account exists, a six-digit reset code has been sent.';
          });
        }
      } else {
        await widget.authRepository.resetPassword(
          email: _email.text,
          code: _code.text,
          password: _password.text,
        );
        if (mounted) widget.onComplete();
      }
    } on BuyerRiskChallenge catch (challenge) {
      if (!mounted) return;
      final token = await requestRiskProof(
        context,
        widget.authRepository,
        challenge,
        _email.text,
      );
      if (mounted && token != null) await _submit(proof: token);
    } on StateError catch (error) {
      if (mounted) setState(() => _message = error.message);
    } on BuyerAuthException catch (error) {
      if (mounted) setState(() => _message = error.message);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: widget.onBack,
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Reset password'),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _codeRequested
                      ? 'Enter your reset code'
                      : 'Recover your account',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _codeRequested
                      ? 'Codes expire after 10 minutes and allow up to five attempts.'
                      : 'We will send instructions if the email belongs to a Buyer account.',
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _email,
                  enabled: !_codeRequested,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  decoration: const InputDecoration(labelText: 'Email address'),
                  validator: (value) {
                    final email = value?.trim() ?? '';
                    return email.contains('@') && email.contains('.')
                        ? null
                        : 'Enter a valid email address.';
                  },
                ),
                if (_codeRequested) ...[
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _code,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    maxLength: 6,
                    decoration: const InputDecoration(
                      labelText: 'Six-digit code',
                      counterText: '',
                    ),
                    validator: (value) =>
                        RegExp(r'^\d{6}$').hasMatch(value ?? '')
                        ? null
                        : 'Enter the six-digit code.',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _password,
                    obscureText: _obscurePassword,
                    autofillHints: const [AutofillHints.newPassword],
                    decoration: InputDecoration(
                      labelText: 'New password',
                      helperText:
                          'At least 12 characters with upper/lowercase and a number.',
                      suffixIcon: IconButton(
                        onPressed: () => setState(
                          () => _obscurePassword = !_obscurePassword,
                        ),
                        tooltip: _obscurePassword
                            ? 'Show password'
                            : 'Hide password',
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                    ),
                    validator: (value) {
                      final password = value ?? '';
                      if (password.length < 12 ||
                          !RegExp('[A-Z]').hasMatch(password) ||
                          !RegExp('[a-z]').hasMatch(password) ||
                          !RegExp(r'\d').hasMatch(password)) {
                        return 'Use 12+ characters, mixed case, and a number.';
                      }
                      return null;
                    },
                  ),
                ],
                if (_message != null) ...[
                  const SizedBox(height: 16),
                  Semantics(liveRegion: true, child: Text(_message!)),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submitting ? null : _submit,
                  child: Text(
                    _submitting
                        ? 'Please wait…'
                        : _codeRequested
                        ? 'Set new password'
                        : 'Send reset code',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

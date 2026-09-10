import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../auth/auth_repository.dart';
import '../design_system/theme.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({
    super.key,
    required this.email,
    required this.authRepository,
    required this.onVerified,
    required this.onBack,
  });

  final String email;
  final AuthRepository authRepository;
  final VoidCallback onVerified;
  final VoidCallback onBack;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final _formKey = GlobalKey<FormState>();
  final _code = TextEditingController();
  late DateTime _resendAt;
  Timer? _timer;
  bool _submitting = false;
  String? _message;
  bool _messageIsError = false;

  @override
  void initState() {
    super.initState();
    _startCooldown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _code.dispose();
    super.dispose();
  }

  int get _secondsRemaining {
    final seconds = _resendAt.difference(DateTime.now()).inSeconds;
    return seconds < 0 ? 0 : seconds;
  }

  void _startCooldown() {
    _resendAt = DateTime.now().add(const Duration(seconds: 60));
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {});
      if (_secondsRemaining == 0) _timer?.cancel();
    });
  }

  Future<void> _verify() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _submitting = true;
      _message = null;
    });
    try {
      await widget.authRepository.verifyEmail(
        email: widget.email,
        code: _code.text,
      );
      if (mounted) widget.onVerified();
    } on BuyerAuthException catch (error) {
      if (mounted) {
        setState(() {
          _message = error.message;
          _messageIsError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _resend() async {
    setState(() {
      _submitting = true;
      _message = null;
    });
    try {
      await widget.authRepository.resendVerification(widget.email);
      if (mounted) {
        _startCooldown();
        setState(() {
          _message = 'A new code was sent. It expires in 10 minutes.';
          _messageIsError = false;
        });
      }
    } on BuyerAuthException catch (error) {
      if (mounted) {
        setState(() {
          _message = error.message;
          _messageIsError = true;
        });
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  String get _resendTimePht {
    final pht = _resendAt.toUtc().add(const Duration(hours: 8));
    final hour = pht.hour == 0
        ? 12
        : pht.hour > 12
        ? pht.hour - 12
        : pht.hour;
    final minute = pht.minute.toString().padLeft(2, '0');
    return '$hour:$minute ${pht.hour >= 12 ? 'PM' : 'AM'} PHT';
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
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.mark_email_read_outlined,
                  size: 56,
                  color: BuyerTheme.action,
                ),
                const SizedBox(height: 24),
                Text(
                  'Verify your email',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Enter the six-digit code sent to ${widget.email}. The code expires in 10 minutes and allows up to five attempts.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: BuyerTheme.muted, height: 1.5),
                ),
                const SizedBox(height: 28),
                TextFormField(
                  controller: _code,
                  autofocus: true,
                  autofillHints: const [AutofillHints.oneTimeCode],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 6,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    letterSpacing: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Verification code',
                    counterText: '',
                  ),
                  validator: (value) => RegExp(r'^\d{6}$').hasMatch(value ?? '')
                      ? null
                      : 'Enter the six-digit code.',
                ),
                if (_message != null) ...[
                  const SizedBox(height: 16),
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      _message!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _messageIsError
                            ? Theme.of(context).colorScheme.error
                            : BuyerTheme.success,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _submitting ? null : _verify,
                  child: Text(_submitting ? 'Checking…' : 'Verify email'),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: _submitting || _secondsRemaining > 0
                      ? null
                      : _resend,
                  child: Text(
                    _secondsRemaining > 0
                        ? 'Resend in 00:${_secondsRemaining.toString().padLeft(2, '0')} · $_resendTimePht'
                        : 'Resend code',
                    textAlign: TextAlign.center,
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

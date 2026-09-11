import 'package:flutter/material.dart';

import '../widgets/auth_content.dart';
import '../widgets/phone_number_field.dart';

import '../auth/auth_repository.dart';
import '../design_system/theme.dart';
import 'risk_otp_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.authRepository,
    required this.onVerificationRequired,
    required this.onGoogleRegister,
    required this.onLogin,
    required this.onBack,
  });

  final AuthRepository authRepository;
  final ValueChanged<String> onVerificationRequired;
  final VoidCallback onGoogleRegister;
  final VoidCallback onLogin;
  final VoidCallback onBack;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  String _mobile = '';
  final _company = TextEditingController();
  final _password = TextEditingController();
  String _buyerType = 'INDIVIDUAL';
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _obscurePassword = true;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _company.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit({String? proof}) async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms || !_acceptedPrivacy) {
      setState(
        () => _error = 'Accept the Terms and Privacy Notice to continue.',
      );
      return;
    }

    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await widget.authRepository.register(
        fullName: _name.text,
        email: _email.text,
        mobileE164: _mobile,
        password: _password.text,
        buyerType: _buyerType,
        companyName: _buyerType == 'BUSINESS' ? _company.text : null,
        proof: proof,
      );
      if (mounted) widget.onVerificationRequired(_email.text.trim());
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
      if (mounted) setState(() => _error = error.message);
    } on BuyerAuthException catch (error) {
      if (mounted) setState(() => _error = error.message);
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
        title: const Text('Create buyer account'),
      ),
      body: SafeArea(
        top: false,
        child: AuthContent(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Form(
            key: _formKey,
            child: AutofillGroup(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Start sourcing with confidence',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your account, then verify your email. It only takes a few steps.',
                    style: TextStyle(color: BuyerTheme.muted),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: widget.onGoogleRegister,
                    icon: const Text(
                      'G',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    label: const Text('Sign up with Google'),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      children: [
                        Expanded(child: Divider()),
                        Flexible(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              'or use email',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Expanded(child: Divider()),
                      ],
                    ),
                  ),
                  TextFormField(
                    controller: _name,
                    autofillHints: const [AutofillHints.name],
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(labelText: 'Full name'),
                    validator: _required('Enter your full name.'),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _email,
                    autofillHints: const [AutofillHints.email],
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email address',
                    ),
                    validator: (value) {
                      final email = value?.trim() ?? '';
                      return email.contains('@') && email.contains('.')
                          ? null
                          : 'Enter a valid email address.';
                    },
                  ),
                  const SizedBox(height: 16),
                  PhoneNumberField(
                    enabled: !_submitting,
                    onChanged: (value) => _mobile = value,
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    initialValue: _buyerType,
                    decoration: const InputDecoration(labelText: 'Buyer type'),
                    items: const [
                      DropdownMenuItem(
                        value: 'INDIVIDUAL',
                        child: Text('Individual buyer'),
                      ),
                      DropdownMenuItem(
                        value: 'BUSINESS',
                        child: Text('Business buyer'),
                      ),
                    ],
                    onChanged: (value) =>
                        setState(() => _buyerType = value ?? 'INDIVIDUAL'),
                  ),
                  if (_buyerType == 'BUSINESS') ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _company,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'Company name',
                      ),
                      validator: _required('Enter your company name.'),
                    ),
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _password,
                    obscureText: _obscurePassword,
                    autofillHints: const [AutofillHints.newPassword],
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: 'Password',
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
                  const SizedBox(height: 16),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _acceptedTerms,
                    onChanged: (value) =>
                        setState(() => _acceptedTerms = value ?? false),
                    title: const Text('I accept the Terms of Service.'),
                  ),
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    value: _acceptedPrivacy,
                    onChanged: (value) =>
                        setState(() => _acceptedPrivacy = value ?? false),
                    title: const Text('I accept the Privacy Notice.'),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 8),
                    AuthNotice(message: _error!, isError: true),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: Text(
                      _submitting ? 'Creating account…' : 'Create account',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: widget.onLogin,
                    child: const Text('Already registered? Sign in'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  FormFieldValidator<String> _required(String message) {
    return (value) => (value?.trim().isEmpty ?? true) ? message : null;
  }
}

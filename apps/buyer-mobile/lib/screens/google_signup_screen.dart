import 'package:flutter/material.dart';

import '../widgets/auth_content.dart';
import '../widgets/phone_number_field.dart';

import '../design_system/theme.dart';

class GoogleSignupScreen extends StatefulWidget {
  const GoogleSignupScreen({
    super.key,
    required this.onStart,
    required this.onBack,
  });

  final Future<void> Function({
    required String mobileE164,
    required String buyerType,
    String? companyName,
  })
  onStart;
  final VoidCallback onBack;

  @override
  State<GoogleSignupScreen> createState() => _GoogleSignupScreenState();
}

class _GoogleSignupScreenState extends State<GoogleSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _mobile = '';
  final _company = TextEditingController();
  String _buyerType = 'INDIVIDUAL';
  bool _acceptedTerms = false;
  bool _acceptedPrivacy = false;
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _company.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
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
    await widget.onStart(
      mobileE164: _mobile,
      buyerType: _buyerType,
      companyName: _buyerType == 'BUSINESS' ? _company.text : null,
    );
    if (mounted) setState(() => _submitting = false);
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
        title: const Text('Sign up with Google'),
      ),
      body: SafeArea(
        top: false,
        child: AuthContent(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'A few details before Google',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Google provides your verified name and email. MateryalPH still needs your mobile number and Buyer type.',
                  style: TextStyle(color: BuyerTheme.muted, height: 1.5),
                ),
                const SizedBox(height: 24),
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
                    decoration: const InputDecoration(
                      labelText: 'Company name',
                    ),
                    validator: (value) => (value?.trim().isEmpty ?? true)
                        ? 'Enter your company name.'
                        : null,
                  ),
                ],
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
                  Semantics(
                    liveRegion: true,
                    child: Text(
                      _error!,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _submitting ? null : _submit,
                  icon: const Text(
                    'G',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                  label: Text(
                    _submitting ? 'Opening Google…' : 'Continue with Google',
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

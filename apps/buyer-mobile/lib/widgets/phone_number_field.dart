import 'package:flutter/material.dart';

import 'phone_countries.dart';

/// Reusable country selector and national number entry, emitting E.164.
class PhoneNumberField extends StatefulWidget {
  const PhoneNumberField({
    super.key,
    required this.onChanged,
    this.enabled = true,
  });

  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  State<PhoneNumberField> createState() => _PhoneNumberFieldState();
}

class _PhoneNumberFieldState extends State<PhoneNumberField> {
  final _controller = TextEditingController();
  String _region = 'PH';
  bool _invalidInput = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _code =>
      phoneCountries.firstWhere((c) => c.region == _region).callingCode;
  String get _national =>
      _region == 'PH' && RegExp(r'^09\d{9}$').hasMatch(_controller.text)
      ? _controller.text.substring(1)
      : _controller.text;
  String get _value =>
      _national.isEmpty || _invalidInput ? '' : '+$_code$_national';

  void _update(String raw) {
    _invalidInput =
        RegExp(r'[^0-9+\s().-]').hasMatch(raw) ||
        RegExp(r'.+\+').hasMatch(raw.trim());
    var digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (raw.trim().startsWith('+')) {
      final matches =
          phoneCountries.where((c) => digits.startsWith(c.callingCode)).toList()
            ..sort(
              (a, b) => b.callingCode.length.compareTo(a.callingCode.length),
            );
      if (matches.isNotEmpty) {
        final selected =
            matches.where((c) => c.region == _region).firstOrNull ??
            matches.where((c) => c.mainCountry).firstOrNull ??
            matches.first;
        _region = selected.region;
        digits = digits.substring(selected.callingCode.length);
      } else {
        _invalidInput = true;
      }
    }
    if (_invalidInput) digits = raw;
    if (digits != _controller.text) {
      _controller.value = TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }
    setState(() {});
    widget.onChanged(_value);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<String>(
          key: ValueKey(_region),
          initialValue: _region,
          isExpanded: true,
          menuMaxHeight: 360,
          decoration: const InputDecoration(
            labelText: 'Mobile number country code',
          ),
          items: phoneCountries
              .map(
                (c) => DropdownMenuItem(
                  value: c.region,
                  child: Text(
                    '+${c.callingCode} · ${c.name}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )
              .toList(),
          onChanged: widget.enabled
              ? (region) {
                  setState(() => _region = region!);
                  widget.onChanged(_value);
                }
              : null,
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _controller,
          enabled: widget.enabled,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.telephoneNumberNational],
          decoration: InputDecoration(
            labelText: 'Mobile number',
            hintText: _region == 'PH' ? '917 123 4567' : null,
            helperText: _region == 'PH'
                ? 'Enter your number without +63. A leading 0 is accepted.'
                : 'Enter your number without the country code.',
          ),
          onChanged: _update,
          validator: (_) => RegExp(r'^\+[1-9]\d{7,14}$').hasMatch(_value)
              ? null
              : 'Enter a valid mobile number for the selected country code.',
        ),
      ],
    );
  }
}

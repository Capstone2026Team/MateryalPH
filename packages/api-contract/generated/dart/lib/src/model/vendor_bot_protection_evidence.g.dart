// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_bot_protection_evidence.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VendorBotProtectionEvidence extends VendorBotProtectionEvidence {
  @override
  final String? recaptchaToken;
  @override
  final bool? requestEmailStepUp;

  factory _$VendorBotProtectionEvidence(
          [void Function(VendorBotProtectionEvidenceBuilder)? updates]) =>
      (VendorBotProtectionEvidenceBuilder()..update(updates))._build();

  _$VendorBotProtectionEvidence._(
      {this.recaptchaToken, this.requestEmailStepUp})
      : super._();
  @override
  VendorBotProtectionEvidence rebuild(
          void Function(VendorBotProtectionEvidenceBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VendorBotProtectionEvidenceBuilder toBuilder() =>
      VendorBotProtectionEvidenceBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VendorBotProtectionEvidence &&
        recaptchaToken == other.recaptchaToken &&
        requestEmailStepUp == other.requestEmailStepUp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recaptchaToken.hashCode);
    _$hash = $jc(_$hash, requestEmailStepUp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VendorBotProtectionEvidence')
          ..add('recaptchaToken', recaptchaToken)
          ..add('requestEmailStepUp', requestEmailStepUp))
        .toString();
  }
}

class VendorBotProtectionEvidenceBuilder
    implements
        Builder<VendorBotProtectionEvidence,
            VendorBotProtectionEvidenceBuilder> {
  _$VendorBotProtectionEvidence? _$v;

  String? _recaptchaToken;
  String? get recaptchaToken => _$this._recaptchaToken;
  set recaptchaToken(String? recaptchaToken) =>
      _$this._recaptchaToken = recaptchaToken;

  bool? _requestEmailStepUp;
  bool? get requestEmailStepUp => _$this._requestEmailStepUp;
  set requestEmailStepUp(bool? requestEmailStepUp) =>
      _$this._requestEmailStepUp = requestEmailStepUp;

  VendorBotProtectionEvidenceBuilder() {
    VendorBotProtectionEvidence._defaults(this);
  }

  VendorBotProtectionEvidenceBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recaptchaToken = $v.recaptchaToken;
      _requestEmailStepUp = $v.requestEmailStepUp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VendorBotProtectionEvidence other) {
    _$v = other as _$VendorBotProtectionEvidence;
  }

  @override
  void update(void Function(VendorBotProtectionEvidenceBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VendorBotProtectionEvidence build() => _build();

  _$VendorBotProtectionEvidence _build() {
    final _$result = _$v ??
        _$VendorBotProtectionEvidence._(
          recaptchaToken: recaptchaToken,
          requestEmailStepUp: requestEmailStepUp,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

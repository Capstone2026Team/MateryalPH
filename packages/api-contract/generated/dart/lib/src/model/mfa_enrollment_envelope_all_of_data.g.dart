// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_enrollment_envelope_all_of_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaEnrollmentEnvelopeAllOfData extends MfaEnrollmentEnvelopeAllOfData {
  @override
  final String secret;
  @override
  final String provisioningUri;

  factory _$MfaEnrollmentEnvelopeAllOfData(
          [void Function(MfaEnrollmentEnvelopeAllOfDataBuilder)? updates]) =>
      (MfaEnrollmentEnvelopeAllOfDataBuilder()..update(updates))._build();

  _$MfaEnrollmentEnvelopeAllOfData._(
      {required this.secret, required this.provisioningUri})
      : super._();
  @override
  MfaEnrollmentEnvelopeAllOfData rebuild(
          void Function(MfaEnrollmentEnvelopeAllOfDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaEnrollmentEnvelopeAllOfDataBuilder toBuilder() =>
      MfaEnrollmentEnvelopeAllOfDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaEnrollmentEnvelopeAllOfData &&
        secret == other.secret &&
        provisioningUri == other.provisioningUri;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, secret.hashCode);
    _$hash = $jc(_$hash, provisioningUri.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaEnrollmentEnvelopeAllOfData')
          ..add('secret', secret)
          ..add('provisioningUri', provisioningUri))
        .toString();
  }
}

class MfaEnrollmentEnvelopeAllOfDataBuilder
    implements
        Builder<MfaEnrollmentEnvelopeAllOfData,
            MfaEnrollmentEnvelopeAllOfDataBuilder> {
  _$MfaEnrollmentEnvelopeAllOfData? _$v;

  String? _secret;
  String? get secret => _$this._secret;
  set secret(String? secret) => _$this._secret = secret;

  String? _provisioningUri;
  String? get provisioningUri => _$this._provisioningUri;
  set provisioningUri(String? provisioningUri) =>
      _$this._provisioningUri = provisioningUri;

  MfaEnrollmentEnvelopeAllOfDataBuilder() {
    MfaEnrollmentEnvelopeAllOfData._defaults(this);
  }

  MfaEnrollmentEnvelopeAllOfDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _secret = $v.secret;
      _provisioningUri = $v.provisioningUri;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaEnrollmentEnvelopeAllOfData other) {
    _$v = other as _$MfaEnrollmentEnvelopeAllOfData;
  }

  @override
  void update(void Function(MfaEnrollmentEnvelopeAllOfDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaEnrollmentEnvelopeAllOfData build() => _build();

  _$MfaEnrollmentEnvelopeAllOfData _build() {
    final _$result = _$v ??
        _$MfaEnrollmentEnvelopeAllOfData._(
          secret: BuiltValueNullFieldError.checkNotNull(
              secret, r'MfaEnrollmentEnvelopeAllOfData', 'secret'),
          provisioningUri: BuiltValueNullFieldError.checkNotNull(
              provisioningUri,
              r'MfaEnrollmentEnvelopeAllOfData',
              'provisioningUri'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

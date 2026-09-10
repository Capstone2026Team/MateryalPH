// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_recovery_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaRecoveryRequest extends MfaRecoveryRequest {
  @override
  final String recoveryCode;

  factory _$MfaRecoveryRequest(
          [void Function(MfaRecoveryRequestBuilder)? updates]) =>
      (MfaRecoveryRequestBuilder()..update(updates))._build();

  _$MfaRecoveryRequest._({required this.recoveryCode}) : super._();
  @override
  MfaRecoveryRequest rebuild(
          void Function(MfaRecoveryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaRecoveryRequestBuilder toBuilder() =>
      MfaRecoveryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaRecoveryRequest && recoveryCode == other.recoveryCode;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, recoveryCode.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaRecoveryRequest')
          ..add('recoveryCode', recoveryCode))
        .toString();
  }
}

class MfaRecoveryRequestBuilder
    implements Builder<MfaRecoveryRequest, MfaRecoveryRequestBuilder> {
  _$MfaRecoveryRequest? _$v;

  String? _recoveryCode;
  String? get recoveryCode => _$this._recoveryCode;
  set recoveryCode(String? recoveryCode) => _$this._recoveryCode = recoveryCode;

  MfaRecoveryRequestBuilder() {
    MfaRecoveryRequest._defaults(this);
  }

  MfaRecoveryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _recoveryCode = $v.recoveryCode;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaRecoveryRequest other) {
    _$v = other as _$MfaRecoveryRequest;
  }

  @override
  void update(void Function(MfaRecoveryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaRecoveryRequest build() => _build();

  _$MfaRecoveryRequest _build() {
    final _$result = _$v ??
        _$MfaRecoveryRequest._(
          recoveryCode: BuiltValueNullFieldError.checkNotNull(
              recoveryCode, r'MfaRecoveryRequest', 'recoveryCode'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

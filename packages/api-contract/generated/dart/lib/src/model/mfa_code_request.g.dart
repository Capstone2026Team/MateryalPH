// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_code_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$MfaCodeRequest extends MfaCodeRequest {
  @override
  final String code;

  factory _$MfaCodeRequest([void Function(MfaCodeRequestBuilder)? updates]) =>
      (MfaCodeRequestBuilder()..update(updates))._build();

  _$MfaCodeRequest._({required this.code}) : super._();
  @override
  MfaCodeRequest rebuild(void Function(MfaCodeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaCodeRequestBuilder toBuilder() => MfaCodeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaCodeRequest && code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaCodeRequest')..add('code', code))
        .toString();
  }
}

class MfaCodeRequestBuilder
    implements Builder<MfaCodeRequest, MfaCodeRequestBuilder> {
  _$MfaCodeRequest? _$v;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  MfaCodeRequestBuilder() {
    MfaCodeRequest._defaults(this);
  }

  MfaCodeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaCodeRequest other) {
    _$v = other as _$MfaCodeRequest;
  }

  @override
  void update(void Function(MfaCodeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaCodeRequest build() => _build();

  _$MfaCodeRequest _build() {
    final _$result = _$v ??
        _$MfaCodeRequest._(
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'MfaCodeRequest', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

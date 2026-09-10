// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_email_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$VerifyEmailRequest extends VerifyEmailRequest {
  @override
  final String email;
  @override
  final String code;

  factory _$VerifyEmailRequest(
          [void Function(VerifyEmailRequestBuilder)? updates]) =>
      (VerifyEmailRequestBuilder()..update(updates))._build();

  _$VerifyEmailRequest._({required this.email, required this.code}) : super._();
  @override
  VerifyEmailRequest rebuild(
          void Function(VerifyEmailRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  VerifyEmailRequestBuilder toBuilder() =>
      VerifyEmailRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is VerifyEmailRequest &&
        email == other.email &&
        code == other.code;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'VerifyEmailRequest')
          ..add('email', email)
          ..add('code', code))
        .toString();
  }
}

class VerifyEmailRequestBuilder
    implements Builder<VerifyEmailRequest, VerifyEmailRequestBuilder> {
  _$VerifyEmailRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _code;
  String? get code => _$this._code;
  set code(String? code) => _$this._code = code;

  VerifyEmailRequestBuilder() {
    VerifyEmailRequest._defaults(this);
  }

  VerifyEmailRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _code = $v.code;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(VerifyEmailRequest other) {
    _$v = other as _$VerifyEmailRequest;
  }

  @override
  void update(void Function(VerifyEmailRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  VerifyEmailRequest build() => _build();

  _$VerifyEmailRequest _build() {
    final _$result = _$v ??
        _$VerifyEmailRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'VerifyEmailRequest', 'email'),
          code: BuiltValueNullFieldError.checkNotNull(
              code, r'VerifyEmailRequest', 'code'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

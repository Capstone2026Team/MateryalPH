// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_mobile_login_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerMobileLoginRequest extends BuyerMobileLoginRequest {
  @override
  final String email;
  @override
  final String password;
  @override
  final String? deviceId;
  @override
  final String? riskProofToken;

  factory _$BuyerMobileLoginRequest(
          [void Function(BuyerMobileLoginRequestBuilder)? updates]) =>
      (BuyerMobileLoginRequestBuilder()..update(updates))._build();

  _$BuyerMobileLoginRequest._(
      {required this.email,
      required this.password,
      this.deviceId,
      this.riskProofToken})
      : super._();
  @override
  BuyerMobileLoginRequest rebuild(
          void Function(BuyerMobileLoginRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerMobileLoginRequestBuilder toBuilder() =>
      BuyerMobileLoginRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerMobileLoginRequest &&
        email == other.email &&
        password == other.password &&
        deviceId == other.deviceId &&
        riskProofToken == other.riskProofToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jc(_$hash, riskProofToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerMobileLoginRequest')
          ..add('email', email)
          ..add('password', password)
          ..add('deviceId', deviceId)
          ..add('riskProofToken', riskProofToken))
        .toString();
  }
}

class BuyerMobileLoginRequestBuilder
    implements
        Builder<BuyerMobileLoginRequest, BuyerMobileLoginRequestBuilder> {
  _$BuyerMobileLoginRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  String? _riskProofToken;
  String? get riskProofToken => _$this._riskProofToken;
  set riskProofToken(String? riskProofToken) =>
      _$this._riskProofToken = riskProofToken;

  BuyerMobileLoginRequestBuilder() {
    BuyerMobileLoginRequest._defaults(this);
  }

  BuyerMobileLoginRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _password = $v.password;
      _deviceId = $v.deviceId;
      _riskProofToken = $v.riskProofToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerMobileLoginRequest other) {
    _$v = other as _$BuyerMobileLoginRequest;
  }

  @override
  void update(void Function(BuyerMobileLoginRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerMobileLoginRequest build() => _build();

  _$BuyerMobileLoginRequest _build() {
    final _$result = _$v ??
        _$BuyerMobileLoginRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'BuyerMobileLoginRequest', 'email'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'BuyerMobileLoginRequest', 'password'),
          deviceId: deviceId,
          riskProofToken: riskProofToken,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

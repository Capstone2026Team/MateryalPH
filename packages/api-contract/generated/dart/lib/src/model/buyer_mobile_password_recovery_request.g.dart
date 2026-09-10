// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_mobile_password_recovery_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerMobilePasswordRecoveryRequest
    extends BuyerMobilePasswordRecoveryRequest {
  @override
  final String email;
  @override
  final String? riskProofToken;

  factory _$BuyerMobilePasswordRecoveryRequest(
          [void Function(BuyerMobilePasswordRecoveryRequestBuilder)?
              updates]) =>
      (BuyerMobilePasswordRecoveryRequestBuilder()..update(updates))._build();

  _$BuyerMobilePasswordRecoveryRequest._(
      {required this.email, this.riskProofToken})
      : super._();
  @override
  BuyerMobilePasswordRecoveryRequest rebuild(
          void Function(BuyerMobilePasswordRecoveryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerMobilePasswordRecoveryRequestBuilder toBuilder() =>
      BuyerMobilePasswordRecoveryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerMobilePasswordRecoveryRequest &&
        email == other.email &&
        riskProofToken == other.riskProofToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, riskProofToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerMobilePasswordRecoveryRequest')
          ..add('email', email)
          ..add('riskProofToken', riskProofToken))
        .toString();
  }
}

class BuyerMobilePasswordRecoveryRequestBuilder
    implements
        Builder<BuyerMobilePasswordRecoveryRequest,
            BuyerMobilePasswordRecoveryRequestBuilder> {
  _$BuyerMobilePasswordRecoveryRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _riskProofToken;
  String? get riskProofToken => _$this._riskProofToken;
  set riskProofToken(String? riskProofToken) =>
      _$this._riskProofToken = riskProofToken;

  BuyerMobilePasswordRecoveryRequestBuilder() {
    BuyerMobilePasswordRecoveryRequest._defaults(this);
  }

  BuyerMobilePasswordRecoveryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _riskProofToken = $v.riskProofToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerMobilePasswordRecoveryRequest other) {
    _$v = other as _$BuyerMobilePasswordRecoveryRequest;
  }

  @override
  void update(
      void Function(BuyerMobilePasswordRecoveryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerMobilePasswordRecoveryRequest build() => _build();

  _$BuyerMobilePasswordRecoveryRequest _build() {
    final _$result = _$v ??
        _$BuyerMobilePasswordRecoveryRequest._(
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'BuyerMobilePasswordRecoveryRequest', 'email'),
          riskProofToken: riskProofToken,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

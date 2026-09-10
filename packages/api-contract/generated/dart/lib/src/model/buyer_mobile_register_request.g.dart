// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_mobile_register_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerMobileRegisterRequestTermsAcceptedEnum
    _$buyerMobileRegisterRequestTermsAcceptedEnum_true_ =
    const BuyerMobileRegisterRequestTermsAcceptedEnum._('true_');

BuyerMobileRegisterRequestTermsAcceptedEnum
    _$buyerMobileRegisterRequestTermsAcceptedEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$buyerMobileRegisterRequestTermsAcceptedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerMobileRegisterRequestTermsAcceptedEnum>
    _$buyerMobileRegisterRequestTermsAcceptedEnumValues = BuiltSet<
        BuyerMobileRegisterRequestTermsAcceptedEnum>(const <BuyerMobileRegisterRequestTermsAcceptedEnum>[
  _$buyerMobileRegisterRequestTermsAcceptedEnum_true_,
]);

const BuyerMobileRegisterRequestPrivacyAcceptedEnum
    _$buyerMobileRegisterRequestPrivacyAcceptedEnum_true_ =
    const BuyerMobileRegisterRequestPrivacyAcceptedEnum._('true_');

BuyerMobileRegisterRequestPrivacyAcceptedEnum
    _$buyerMobileRegisterRequestPrivacyAcceptedEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$buyerMobileRegisterRequestPrivacyAcceptedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerMobileRegisterRequestPrivacyAcceptedEnum>
    _$buyerMobileRegisterRequestPrivacyAcceptedEnumValues = BuiltSet<
        BuyerMobileRegisterRequestPrivacyAcceptedEnum>(const <BuyerMobileRegisterRequestPrivacyAcceptedEnum>[
  _$buyerMobileRegisterRequestPrivacyAcceptedEnum_true_,
]);

Serializer<BuyerMobileRegisterRequestTermsAcceptedEnum>
    _$buyerMobileRegisterRequestTermsAcceptedEnumSerializer =
    _$BuyerMobileRegisterRequestTermsAcceptedEnumSerializer();
Serializer<BuyerMobileRegisterRequestPrivacyAcceptedEnum>
    _$buyerMobileRegisterRequestPrivacyAcceptedEnumSerializer =
    _$BuyerMobileRegisterRequestPrivacyAcceptedEnumSerializer();

class _$BuyerMobileRegisterRequestTermsAcceptedEnumSerializer
    implements
        PrimitiveSerializer<BuyerMobileRegisterRequestTermsAcceptedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerMobileRegisterRequestTermsAcceptedEnum
  ];
  @override
  final String wireName = 'BuyerMobileRegisterRequestTermsAcceptedEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerMobileRegisterRequestTermsAcceptedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerMobileRegisterRequestTermsAcceptedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerMobileRegisterRequestTermsAcceptedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerMobileRegisterRequestPrivacyAcceptedEnumSerializer
    implements
        PrimitiveSerializer<BuyerMobileRegisterRequestPrivacyAcceptedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerMobileRegisterRequestPrivacyAcceptedEnum
  ];
  @override
  final String wireName = 'BuyerMobileRegisterRequestPrivacyAcceptedEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerMobileRegisterRequestPrivacyAcceptedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerMobileRegisterRequestPrivacyAcceptedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerMobileRegisterRequestPrivacyAcceptedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerMobileRegisterRequest extends BuyerMobileRegisterRequest {
  @override
  final String fullName;
  @override
  final String email;
  @override
  final String mobileE164;
  @override
  final String password;
  @override
  final String passwordConfirmation;
  @override
  final String buyerType;
  @override
  final String? companyName;
  @override
  final BuyerMobileRegisterRequestTermsAcceptedEnum termsAccepted;
  @override
  final BuyerMobileRegisterRequestPrivacyAcceptedEnum privacyAccepted;
  @override
  final String? riskProofToken;

  factory _$BuyerMobileRegisterRequest(
          [void Function(BuyerMobileRegisterRequestBuilder)? updates]) =>
      (BuyerMobileRegisterRequestBuilder()..update(updates))._build();

  _$BuyerMobileRegisterRequest._(
      {required this.fullName,
      required this.email,
      required this.mobileE164,
      required this.password,
      required this.passwordConfirmation,
      required this.buyerType,
      this.companyName,
      required this.termsAccepted,
      required this.privacyAccepted,
      this.riskProofToken})
      : super._();
  @override
  BuyerMobileRegisterRequest rebuild(
          void Function(BuyerMobileRegisterRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerMobileRegisterRequestBuilder toBuilder() =>
      BuyerMobileRegisterRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerMobileRegisterRequest &&
        fullName == other.fullName &&
        email == other.email &&
        mobileE164 == other.mobileE164 &&
        password == other.password &&
        passwordConfirmation == other.passwordConfirmation &&
        buyerType == other.buyerType &&
        companyName == other.companyName &&
        termsAccepted == other.termsAccepted &&
        privacyAccepted == other.privacyAccepted &&
        riskProofToken == other.riskProofToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, mobileE164.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, passwordConfirmation.hashCode);
    _$hash = $jc(_$hash, buyerType.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, termsAccepted.hashCode);
    _$hash = $jc(_$hash, privacyAccepted.hashCode);
    _$hash = $jc(_$hash, riskProofToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerMobileRegisterRequest')
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('mobileE164', mobileE164)
          ..add('password', password)
          ..add('passwordConfirmation', passwordConfirmation)
          ..add('buyerType', buyerType)
          ..add('companyName', companyName)
          ..add('termsAccepted', termsAccepted)
          ..add('privacyAccepted', privacyAccepted)
          ..add('riskProofToken', riskProofToken))
        .toString();
  }
}

class BuyerMobileRegisterRequestBuilder
    implements
        Builder<BuyerMobileRegisterRequest, BuyerMobileRegisterRequestBuilder> {
  _$BuyerMobileRegisterRequest? _$v;

  String? _fullName;
  String? get fullName => _$this._fullName;
  set fullName(String? fullName) => _$this._fullName = fullName;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _mobileE164;
  String? get mobileE164 => _$this._mobileE164;
  set mobileE164(String? mobileE164) => _$this._mobileE164 = mobileE164;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  String? _passwordConfirmation;
  String? get passwordConfirmation => _$this._passwordConfirmation;
  set passwordConfirmation(String? passwordConfirmation) =>
      _$this._passwordConfirmation = passwordConfirmation;

  String? _buyerType;
  String? get buyerType => _$this._buyerType;
  set buyerType(String? buyerType) => _$this._buyerType = buyerType;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  BuyerMobileRegisterRequestTermsAcceptedEnum? _termsAccepted;
  BuyerMobileRegisterRequestTermsAcceptedEnum? get termsAccepted =>
      _$this._termsAccepted;
  set termsAccepted(
          BuyerMobileRegisterRequestTermsAcceptedEnum? termsAccepted) =>
      _$this._termsAccepted = termsAccepted;

  BuyerMobileRegisterRequestPrivacyAcceptedEnum? _privacyAccepted;
  BuyerMobileRegisterRequestPrivacyAcceptedEnum? get privacyAccepted =>
      _$this._privacyAccepted;
  set privacyAccepted(
          BuyerMobileRegisterRequestPrivacyAcceptedEnum? privacyAccepted) =>
      _$this._privacyAccepted = privacyAccepted;

  String? _riskProofToken;
  String? get riskProofToken => _$this._riskProofToken;
  set riskProofToken(String? riskProofToken) =>
      _$this._riskProofToken = riskProofToken;

  BuyerMobileRegisterRequestBuilder() {
    BuyerMobileRegisterRequest._defaults(this);
  }

  BuyerMobileRegisterRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _email = $v.email;
      _mobileE164 = $v.mobileE164;
      _password = $v.password;
      _passwordConfirmation = $v.passwordConfirmation;
      _buyerType = $v.buyerType;
      _companyName = $v.companyName;
      _termsAccepted = $v.termsAccepted;
      _privacyAccepted = $v.privacyAccepted;
      _riskProofToken = $v.riskProofToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerMobileRegisterRequest other) {
    _$v = other as _$BuyerMobileRegisterRequest;
  }

  @override
  void update(void Function(BuyerMobileRegisterRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerMobileRegisterRequest build() => _build();

  _$BuyerMobileRegisterRequest _build() {
    final _$result = _$v ??
        _$BuyerMobileRegisterRequest._(
          fullName: BuiltValueNullFieldError.checkNotNull(
              fullName, r'BuyerMobileRegisterRequest', 'fullName'),
          email: BuiltValueNullFieldError.checkNotNull(
              email, r'BuyerMobileRegisterRequest', 'email'),
          mobileE164: BuiltValueNullFieldError.checkNotNull(
              mobileE164, r'BuyerMobileRegisterRequest', 'mobileE164'),
          password: BuiltValueNullFieldError.checkNotNull(
              password, r'BuyerMobileRegisterRequest', 'password'),
          passwordConfirmation: BuiltValueNullFieldError.checkNotNull(
              passwordConfirmation,
              r'BuyerMobileRegisterRequest',
              'passwordConfirmation'),
          buyerType: BuiltValueNullFieldError.checkNotNull(
              buyerType, r'BuyerMobileRegisterRequest', 'buyerType'),
          companyName: companyName,
          termsAccepted: BuiltValueNullFieldError.checkNotNull(
              termsAccepted, r'BuyerMobileRegisterRequest', 'termsAccepted'),
          privacyAccepted: BuiltValueNullFieldError.checkNotNull(
              privacyAccepted,
              r'BuyerMobileRegisterRequest',
              'privacyAccepted'),
          riskProofToken: riskProofToken,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

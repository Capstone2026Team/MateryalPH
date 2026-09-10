// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const RegisterRequestTermsAcceptedEnum
    _$registerRequestTermsAcceptedEnum_true_ =
    const RegisterRequestTermsAcceptedEnum._('true_');

RegisterRequestTermsAcceptedEnum _$registerRequestTermsAcceptedEnumValueOf(
    String name) {
  switch (name) {
    case 'true_':
      return _$registerRequestTermsAcceptedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RegisterRequestTermsAcceptedEnum>
    _$registerRequestTermsAcceptedEnumValues = BuiltSet<
        RegisterRequestTermsAcceptedEnum>(const <RegisterRequestTermsAcceptedEnum>[
  _$registerRequestTermsAcceptedEnum_true_,
]);

const RegisterRequestPrivacyAcceptedEnum
    _$registerRequestPrivacyAcceptedEnum_true_ =
    const RegisterRequestPrivacyAcceptedEnum._('true_');

RegisterRequestPrivacyAcceptedEnum _$registerRequestPrivacyAcceptedEnumValueOf(
    String name) {
  switch (name) {
    case 'true_':
      return _$registerRequestPrivacyAcceptedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<RegisterRequestPrivacyAcceptedEnum>
    _$registerRequestPrivacyAcceptedEnumValues = BuiltSet<
        RegisterRequestPrivacyAcceptedEnum>(const <RegisterRequestPrivacyAcceptedEnum>[
  _$registerRequestPrivacyAcceptedEnum_true_,
]);

Serializer<RegisterRequestTermsAcceptedEnum>
    _$registerRequestTermsAcceptedEnumSerializer =
    _$RegisterRequestTermsAcceptedEnumSerializer();
Serializer<RegisterRequestPrivacyAcceptedEnum>
    _$registerRequestPrivacyAcceptedEnumSerializer =
    _$RegisterRequestPrivacyAcceptedEnumSerializer();

class _$RegisterRequestTermsAcceptedEnumSerializer
    implements PrimitiveSerializer<RegisterRequestTermsAcceptedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[RegisterRequestTermsAcceptedEnum];
  @override
  final String wireName = 'RegisterRequestTermsAcceptedEnum';

  @override
  Object serialize(
          Serializers serializers, RegisterRequestTermsAcceptedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegisterRequestTermsAcceptedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegisterRequestTermsAcceptedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegisterRequestPrivacyAcceptedEnumSerializer
    implements PrimitiveSerializer<RegisterRequestPrivacyAcceptedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[RegisterRequestPrivacyAcceptedEnum];
  @override
  final String wireName = 'RegisterRequestPrivacyAcceptedEnum';

  @override
  Object serialize(
          Serializers serializers, RegisterRequestPrivacyAcceptedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  RegisterRequestPrivacyAcceptedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      RegisterRequestPrivacyAcceptedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$RegisterRequest extends RegisterRequest {
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
  final String businessName;
  @override
  final RegisterRequestTermsAcceptedEnum termsAccepted;
  @override
  final RegisterRequestPrivacyAcceptedEnum privacyAccepted;
  @override
  final VendorBotProtectionEvidence? botProtection;

  factory _$RegisterRequest([void Function(RegisterRequestBuilder)? updates]) =>
      (RegisterRequestBuilder()..update(updates))._build();

  _$RegisterRequest._(
      {required this.fullName,
      required this.email,
      required this.mobileE164,
      required this.password,
      required this.passwordConfirmation,
      required this.businessName,
      required this.termsAccepted,
      required this.privacyAccepted,
      this.botProtection})
      : super._();
  @override
  RegisterRequest rebuild(void Function(RegisterRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  RegisterRequestBuilder toBuilder() => RegisterRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is RegisterRequest &&
        fullName == other.fullName &&
        email == other.email &&
        mobileE164 == other.mobileE164 &&
        password == other.password &&
        passwordConfirmation == other.passwordConfirmation &&
        businessName == other.businessName &&
        termsAccepted == other.termsAccepted &&
        privacyAccepted == other.privacyAccepted &&
        botProtection == other.botProtection;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, fullName.hashCode);
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, mobileE164.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, passwordConfirmation.hashCode);
    _$hash = $jc(_$hash, businessName.hashCode);
    _$hash = $jc(_$hash, termsAccepted.hashCode);
    _$hash = $jc(_$hash, privacyAccepted.hashCode);
    _$hash = $jc(_$hash, botProtection.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'RegisterRequest')
          ..add('fullName', fullName)
          ..add('email', email)
          ..add('mobileE164', mobileE164)
          ..add('password', password)
          ..add('passwordConfirmation', passwordConfirmation)
          ..add('businessName', businessName)
          ..add('termsAccepted', termsAccepted)
          ..add('privacyAccepted', privacyAccepted)
          ..add('botProtection', botProtection))
        .toString();
  }
}

class RegisterRequestBuilder
    implements Builder<RegisterRequest, RegisterRequestBuilder> {
  _$RegisterRequest? _$v;

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

  String? _businessName;
  String? get businessName => _$this._businessName;
  set businessName(String? businessName) => _$this._businessName = businessName;

  RegisterRequestTermsAcceptedEnum? _termsAccepted;
  RegisterRequestTermsAcceptedEnum? get termsAccepted => _$this._termsAccepted;
  set termsAccepted(RegisterRequestTermsAcceptedEnum? termsAccepted) =>
      _$this._termsAccepted = termsAccepted;

  RegisterRequestPrivacyAcceptedEnum? _privacyAccepted;
  RegisterRequestPrivacyAcceptedEnum? get privacyAccepted =>
      _$this._privacyAccepted;
  set privacyAccepted(RegisterRequestPrivacyAcceptedEnum? privacyAccepted) =>
      _$this._privacyAccepted = privacyAccepted;

  VendorBotProtectionEvidenceBuilder? _botProtection;
  VendorBotProtectionEvidenceBuilder get botProtection =>
      _$this._botProtection ??= VendorBotProtectionEvidenceBuilder();
  set botProtection(VendorBotProtectionEvidenceBuilder? botProtection) =>
      _$this._botProtection = botProtection;

  RegisterRequestBuilder() {
    RegisterRequest._defaults(this);
  }

  RegisterRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _fullName = $v.fullName;
      _email = $v.email;
      _mobileE164 = $v.mobileE164;
      _password = $v.password;
      _passwordConfirmation = $v.passwordConfirmation;
      _businessName = $v.businessName;
      _termsAccepted = $v.termsAccepted;
      _privacyAccepted = $v.privacyAccepted;
      _botProtection = $v.botProtection?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(RegisterRequest other) {
    _$v = other as _$RegisterRequest;
  }

  @override
  void update(void Function(RegisterRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  RegisterRequest build() => _build();

  _$RegisterRequest _build() {
    _$RegisterRequest _$result;
    try {
      _$result = _$v ??
          _$RegisterRequest._(
            fullName: BuiltValueNullFieldError.checkNotNull(
                fullName, r'RegisterRequest', 'fullName'),
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'RegisterRequest', 'email'),
            mobileE164: BuiltValueNullFieldError.checkNotNull(
                mobileE164, r'RegisterRequest', 'mobileE164'),
            password: BuiltValueNullFieldError.checkNotNull(
                password, r'RegisterRequest', 'password'),
            passwordConfirmation: BuiltValueNullFieldError.checkNotNull(
                passwordConfirmation,
                r'RegisterRequest',
                'passwordConfirmation'),
            businessName: BuiltValueNullFieldError.checkNotNull(
                businessName, r'RegisterRequest', 'businessName'),
            termsAccepted: BuiltValueNullFieldError.checkNotNull(
                termsAccepted, r'RegisterRequest', 'termsAccepted'),
            privacyAccepted: BuiltValueNullFieldError.checkNotNull(
                privacyAccepted, r'RegisterRequest', 'privacyAccepted'),
            botProtection: _botProtection?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'botProtection';
        _botProtection?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'RegisterRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

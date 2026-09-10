// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const LoginRequestPortalEnum _$loginRequestPortalEnum_VENDOR =
    const LoginRequestPortalEnum._('VENDOR');
const LoginRequestPortalEnum _$loginRequestPortalEnum_ADMIN =
    const LoginRequestPortalEnum._('ADMIN');

LoginRequestPortalEnum _$loginRequestPortalEnumValueOf(String name) {
  switch (name) {
    case 'VENDOR':
      return _$loginRequestPortalEnum_VENDOR;
    case 'ADMIN':
      return _$loginRequestPortalEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<LoginRequestPortalEnum> _$loginRequestPortalEnumValues =
    BuiltSet<LoginRequestPortalEnum>(const <LoginRequestPortalEnum>[
  _$loginRequestPortalEnum_VENDOR,
  _$loginRequestPortalEnum_ADMIN,
]);

Serializer<LoginRequestPortalEnum> _$loginRequestPortalEnumSerializer =
    _$LoginRequestPortalEnumSerializer();

class _$LoginRequestPortalEnumSerializer
    implements PrimitiveSerializer<LoginRequestPortalEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };

  @override
  final Iterable<Type> types = const <Type>[LoginRequestPortalEnum];
  @override
  final String wireName = 'LoginRequestPortalEnum';

  @override
  Object serialize(Serializers serializers, LoginRequestPortalEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  LoginRequestPortalEnum deserialize(Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      LoginRequestPortalEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$LoginRequest extends LoginRequest {
  @override
  final String email;
  @override
  final String password;
  @override
  final LoginRequestPortalEnum portal;
  @override
  final VendorBotProtectionEvidence? botProtection;

  factory _$LoginRequest([void Function(LoginRequestBuilder)? updates]) =>
      (LoginRequestBuilder()..update(updates))._build();

  _$LoginRequest._(
      {required this.email,
      required this.password,
      required this.portal,
      this.botProtection})
      : super._();
  @override
  LoginRequest rebuild(void Function(LoginRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  LoginRequestBuilder toBuilder() => LoginRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is LoginRequest &&
        email == other.email &&
        password == other.password &&
        portal == other.portal &&
        botProtection == other.botProtection;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, password.hashCode);
    _$hash = $jc(_$hash, portal.hashCode);
    _$hash = $jc(_$hash, botProtection.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'LoginRequest')
          ..add('email', email)
          ..add('password', password)
          ..add('portal', portal)
          ..add('botProtection', botProtection))
        .toString();
  }
}

class LoginRequestBuilder
    implements Builder<LoginRequest, LoginRequestBuilder> {
  _$LoginRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  String? _password;
  String? get password => _$this._password;
  set password(String? password) => _$this._password = password;

  LoginRequestPortalEnum? _portal;
  LoginRequestPortalEnum? get portal => _$this._portal;
  set portal(LoginRequestPortalEnum? portal) => _$this._portal = portal;

  VendorBotProtectionEvidenceBuilder? _botProtection;
  VendorBotProtectionEvidenceBuilder get botProtection =>
      _$this._botProtection ??= VendorBotProtectionEvidenceBuilder();
  set botProtection(VendorBotProtectionEvidenceBuilder? botProtection) =>
      _$this._botProtection = botProtection;

  LoginRequestBuilder() {
    LoginRequest._defaults(this);
  }

  LoginRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _password = $v.password;
      _portal = $v.portal;
      _botProtection = $v.botProtection?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(LoginRequest other) {
    _$v = other as _$LoginRequest;
  }

  @override
  void update(void Function(LoginRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  LoginRequest build() => _build();

  _$LoginRequest _build() {
    _$LoginRequest _$result;
    try {
      _$result = _$v ??
          _$LoginRequest._(
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'LoginRequest', 'email'),
            password: BuiltValueNullFieldError.checkNotNull(
                password, r'LoginRequest', 'password'),
            portal: BuiltValueNullFieldError.checkNotNull(
                portal, r'LoginRequest', 'portal'),
            botProtection: _botProtection?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'botProtection';
        _botProtection?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'LoginRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

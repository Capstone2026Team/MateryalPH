// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_recovery_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const PasswordRecoveryRequestPortalEnum
    _$passwordRecoveryRequestPortalEnum_VENDOR =
    const PasswordRecoveryRequestPortalEnum._('VENDOR');
const PasswordRecoveryRequestPortalEnum
    _$passwordRecoveryRequestPortalEnum_ADMIN =
    const PasswordRecoveryRequestPortalEnum._('ADMIN');

PasswordRecoveryRequestPortalEnum _$passwordRecoveryRequestPortalEnumValueOf(
    String name) {
  switch (name) {
    case 'VENDOR':
      return _$passwordRecoveryRequestPortalEnum_VENDOR;
    case 'ADMIN':
      return _$passwordRecoveryRequestPortalEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<PasswordRecoveryRequestPortalEnum>
    _$passwordRecoveryRequestPortalEnumValues = BuiltSet<
        PasswordRecoveryRequestPortalEnum>(const <PasswordRecoveryRequestPortalEnum>[
  _$passwordRecoveryRequestPortalEnum_VENDOR,
  _$passwordRecoveryRequestPortalEnum_ADMIN,
]);

Serializer<PasswordRecoveryRequestPortalEnum>
    _$passwordRecoveryRequestPortalEnumSerializer =
    _$PasswordRecoveryRequestPortalEnumSerializer();

class _$PasswordRecoveryRequestPortalEnumSerializer
    implements PrimitiveSerializer<PasswordRecoveryRequestPortalEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };

  @override
  final Iterable<Type> types = const <Type>[PasswordRecoveryRequestPortalEnum];
  @override
  final String wireName = 'PasswordRecoveryRequestPortalEnum';

  @override
  Object serialize(
          Serializers serializers, PasswordRecoveryRequestPortalEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  PasswordRecoveryRequestPortalEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      PasswordRecoveryRequestPortalEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$PasswordRecoveryRequest extends PasswordRecoveryRequest {
  @override
  final String email;
  @override
  final PasswordRecoveryRequestPortalEnum portal;
  @override
  final VendorBotProtectionEvidence? botProtection;

  factory _$PasswordRecoveryRequest(
          [void Function(PasswordRecoveryRequestBuilder)? updates]) =>
      (PasswordRecoveryRequestBuilder()..update(updates))._build();

  _$PasswordRecoveryRequest._(
      {required this.email, required this.portal, this.botProtection})
      : super._();
  @override
  PasswordRecoveryRequest rebuild(
          void Function(PasswordRecoveryRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  PasswordRecoveryRequestBuilder toBuilder() =>
      PasswordRecoveryRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is PasswordRecoveryRequest &&
        email == other.email &&
        portal == other.portal &&
        botProtection == other.botProtection;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, email.hashCode);
    _$hash = $jc(_$hash, portal.hashCode);
    _$hash = $jc(_$hash, botProtection.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'PasswordRecoveryRequest')
          ..add('email', email)
          ..add('portal', portal)
          ..add('botProtection', botProtection))
        .toString();
  }
}

class PasswordRecoveryRequestBuilder
    implements
        Builder<PasswordRecoveryRequest, PasswordRecoveryRequestBuilder> {
  _$PasswordRecoveryRequest? _$v;

  String? _email;
  String? get email => _$this._email;
  set email(String? email) => _$this._email = email;

  PasswordRecoveryRequestPortalEnum? _portal;
  PasswordRecoveryRequestPortalEnum? get portal => _$this._portal;
  set portal(PasswordRecoveryRequestPortalEnum? portal) =>
      _$this._portal = portal;

  VendorBotProtectionEvidenceBuilder? _botProtection;
  VendorBotProtectionEvidenceBuilder get botProtection =>
      _$this._botProtection ??= VendorBotProtectionEvidenceBuilder();
  set botProtection(VendorBotProtectionEvidenceBuilder? botProtection) =>
      _$this._botProtection = botProtection;

  PasswordRecoveryRequestBuilder() {
    PasswordRecoveryRequest._defaults(this);
  }

  PasswordRecoveryRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _email = $v.email;
      _portal = $v.portal;
      _botProtection = $v.botProtection?.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(PasswordRecoveryRequest other) {
    _$v = other as _$PasswordRecoveryRequest;
  }

  @override
  void update(void Function(PasswordRecoveryRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  PasswordRecoveryRequest build() => _build();

  _$PasswordRecoveryRequest _build() {
    _$PasswordRecoveryRequest _$result;
    try {
      _$result = _$v ??
          _$PasswordRecoveryRequest._(
            email: BuiltValueNullFieldError.checkNotNull(
                email, r'PasswordRecoveryRequest', 'email'),
            portal: BuiltValueNullFieldError.checkNotNull(
                portal, r'PasswordRecoveryRequest', 'portal'),
            botProtection: _botProtection?.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'botProtection';
        _botProtection?.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'PasswordRecoveryRequest', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

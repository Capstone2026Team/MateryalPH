// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_oidc_start_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const GoogleOidcStartRequestPortalEnum
    _$googleOidcStartRequestPortalEnum_VENDOR =
    const GoogleOidcStartRequestPortalEnum._('VENDOR');
const GoogleOidcStartRequestPortalEnum
    _$googleOidcStartRequestPortalEnum_ADMIN =
    const GoogleOidcStartRequestPortalEnum._('ADMIN');

GoogleOidcStartRequestPortalEnum _$googleOidcStartRequestPortalEnumValueOf(
    String name) {
  switch (name) {
    case 'VENDOR':
      return _$googleOidcStartRequestPortalEnum_VENDOR;
    case 'ADMIN':
      return _$googleOidcStartRequestPortalEnum_ADMIN;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GoogleOidcStartRequestPortalEnum>
    _$googleOidcStartRequestPortalEnumValues = BuiltSet<
        GoogleOidcStartRequestPortalEnum>(const <GoogleOidcStartRequestPortalEnum>[
  _$googleOidcStartRequestPortalEnum_VENDOR,
  _$googleOidcStartRequestPortalEnum_ADMIN,
]);

const GoogleOidcStartRequestModeEnum _$googleOidcStartRequestModeEnum_SIGN_IN =
    const GoogleOidcStartRequestModeEnum._('SIGN_IN');
const GoogleOidcStartRequestModeEnum _$googleOidcStartRequestModeEnum_SIGN_UP =
    const GoogleOidcStartRequestModeEnum._('SIGN_UP');

GoogleOidcStartRequestModeEnum _$googleOidcStartRequestModeEnumValueOf(
    String name) {
  switch (name) {
    case 'SIGN_IN':
      return _$googleOidcStartRequestModeEnum_SIGN_IN;
    case 'SIGN_UP':
      return _$googleOidcStartRequestModeEnum_SIGN_UP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<GoogleOidcStartRequestModeEnum>
    _$googleOidcStartRequestModeEnumValues = BuiltSet<
        GoogleOidcStartRequestModeEnum>(const <GoogleOidcStartRequestModeEnum>[
  _$googleOidcStartRequestModeEnum_SIGN_IN,
  _$googleOidcStartRequestModeEnum_SIGN_UP,
]);

Serializer<GoogleOidcStartRequestPortalEnum>
    _$googleOidcStartRequestPortalEnumSerializer =
    _$GoogleOidcStartRequestPortalEnumSerializer();
Serializer<GoogleOidcStartRequestModeEnum>
    _$googleOidcStartRequestModeEnumSerializer =
    _$GoogleOidcStartRequestModeEnumSerializer();

class _$GoogleOidcStartRequestPortalEnumSerializer
    implements PrimitiveSerializer<GoogleOidcStartRequestPortalEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'VENDOR': 'VENDOR',
    'ADMIN': 'ADMIN',
  };

  @override
  final Iterable<Type> types = const <Type>[GoogleOidcStartRequestPortalEnum];
  @override
  final String wireName = 'GoogleOidcStartRequestPortalEnum';

  @override
  Object serialize(
          Serializers serializers, GoogleOidcStartRequestPortalEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GoogleOidcStartRequestPortalEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GoogleOidcStartRequestPortalEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GoogleOidcStartRequestModeEnumSerializer
    implements PrimitiveSerializer<GoogleOidcStartRequestModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SIGN_IN': 'SIGN_IN',
    'SIGN_UP': 'SIGN_UP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SIGN_IN': 'SIGN_IN',
    'SIGN_UP': 'SIGN_UP',
  };

  @override
  final Iterable<Type> types = const <Type>[GoogleOidcStartRequestModeEnum];
  @override
  final String wireName = 'GoogleOidcStartRequestModeEnum';

  @override
  Object serialize(
          Serializers serializers, GoogleOidcStartRequestModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  GoogleOidcStartRequestModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      GoogleOidcStartRequestModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$GoogleOidcStartRequest extends GoogleOidcStartRequest {
  @override
  final GoogleOidcStartRequestPortalEnum portal;
  @override
  final GoogleOidcStartRequestModeEnum mode;
  @override
  final String? mobileE164;
  @override
  final String? businessName;
  @override
  final bool? termsAccepted;
  @override
  final bool? privacyAccepted;

  factory _$GoogleOidcStartRequest(
          [void Function(GoogleOidcStartRequestBuilder)? updates]) =>
      (GoogleOidcStartRequestBuilder()..update(updates))._build();

  _$GoogleOidcStartRequest._(
      {required this.portal,
      required this.mode,
      this.mobileE164,
      this.businessName,
      this.termsAccepted,
      this.privacyAccepted})
      : super._();
  @override
  GoogleOidcStartRequest rebuild(
          void Function(GoogleOidcStartRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoogleOidcStartRequestBuilder toBuilder() =>
      GoogleOidcStartRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoogleOidcStartRequest &&
        portal == other.portal &&
        mode == other.mode &&
        mobileE164 == other.mobileE164 &&
        businessName == other.businessName &&
        termsAccepted == other.termsAccepted &&
        privacyAccepted == other.privacyAccepted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, portal.hashCode);
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, mobileE164.hashCode);
    _$hash = $jc(_$hash, businessName.hashCode);
    _$hash = $jc(_$hash, termsAccepted.hashCode);
    _$hash = $jc(_$hash, privacyAccepted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoogleOidcStartRequest')
          ..add('portal', portal)
          ..add('mode', mode)
          ..add('mobileE164', mobileE164)
          ..add('businessName', businessName)
          ..add('termsAccepted', termsAccepted)
          ..add('privacyAccepted', privacyAccepted))
        .toString();
  }
}

class GoogleOidcStartRequestBuilder
    implements Builder<GoogleOidcStartRequest, GoogleOidcStartRequestBuilder> {
  _$GoogleOidcStartRequest? _$v;

  GoogleOidcStartRequestPortalEnum? _portal;
  GoogleOidcStartRequestPortalEnum? get portal => _$this._portal;
  set portal(GoogleOidcStartRequestPortalEnum? portal) =>
      _$this._portal = portal;

  GoogleOidcStartRequestModeEnum? _mode;
  GoogleOidcStartRequestModeEnum? get mode => _$this._mode;
  set mode(GoogleOidcStartRequestModeEnum? mode) => _$this._mode = mode;

  String? _mobileE164;
  String? get mobileE164 => _$this._mobileE164;
  set mobileE164(String? mobileE164) => _$this._mobileE164 = mobileE164;

  String? _businessName;
  String? get businessName => _$this._businessName;
  set businessName(String? businessName) => _$this._businessName = businessName;

  bool? _termsAccepted;
  bool? get termsAccepted => _$this._termsAccepted;
  set termsAccepted(bool? termsAccepted) =>
      _$this._termsAccepted = termsAccepted;

  bool? _privacyAccepted;
  bool? get privacyAccepted => _$this._privacyAccepted;
  set privacyAccepted(bool? privacyAccepted) =>
      _$this._privacyAccepted = privacyAccepted;

  GoogleOidcStartRequestBuilder() {
    GoogleOidcStartRequest._defaults(this);
  }

  GoogleOidcStartRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _portal = $v.portal;
      _mode = $v.mode;
      _mobileE164 = $v.mobileE164;
      _businessName = $v.businessName;
      _termsAccepted = $v.termsAccepted;
      _privacyAccepted = $v.privacyAccepted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoogleOidcStartRequest other) {
    _$v = other as _$GoogleOidcStartRequest;
  }

  @override
  void update(void Function(GoogleOidcStartRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoogleOidcStartRequest build() => _build();

  _$GoogleOidcStartRequest _build() {
    final _$result = _$v ??
        _$GoogleOidcStartRequest._(
          portal: BuiltValueNullFieldError.checkNotNull(
              portal, r'GoogleOidcStartRequest', 'portal'),
          mode: BuiltValueNullFieldError.checkNotNull(
              mode, r'GoogleOidcStartRequest', 'mode'),
          mobileE164: mobileE164,
          businessName: businessName,
          termsAccepted: termsAccepted,
          privacyAccepted: privacyAccepted,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

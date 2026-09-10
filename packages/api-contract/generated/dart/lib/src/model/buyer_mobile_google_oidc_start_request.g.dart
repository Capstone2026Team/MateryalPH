// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_mobile_google_oidc_start_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BuyerMobileGoogleOidcStartRequestModeEnum
    _$buyerMobileGoogleOidcStartRequestModeEnum_SIGN_IN =
    const BuyerMobileGoogleOidcStartRequestModeEnum._('SIGN_IN');
const BuyerMobileGoogleOidcStartRequestModeEnum
    _$buyerMobileGoogleOidcStartRequestModeEnum_SIGN_UP =
    const BuyerMobileGoogleOidcStartRequestModeEnum._('SIGN_UP');

BuyerMobileGoogleOidcStartRequestModeEnum
    _$buyerMobileGoogleOidcStartRequestModeEnumValueOf(String name) {
  switch (name) {
    case 'SIGN_IN':
      return _$buyerMobileGoogleOidcStartRequestModeEnum_SIGN_IN;
    case 'SIGN_UP':
      return _$buyerMobileGoogleOidcStartRequestModeEnum_SIGN_UP;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BuyerMobileGoogleOidcStartRequestModeEnum>
    _$buyerMobileGoogleOidcStartRequestModeEnumValues = BuiltSet<
        BuyerMobileGoogleOidcStartRequestModeEnum>(const <BuyerMobileGoogleOidcStartRequestModeEnum>[
  _$buyerMobileGoogleOidcStartRequestModeEnum_SIGN_IN,
  _$buyerMobileGoogleOidcStartRequestModeEnum_SIGN_UP,
]);

Serializer<BuyerMobileGoogleOidcStartRequestModeEnum>
    _$buyerMobileGoogleOidcStartRequestModeEnumSerializer =
    _$BuyerMobileGoogleOidcStartRequestModeEnumSerializer();

class _$BuyerMobileGoogleOidcStartRequestModeEnumSerializer
    implements PrimitiveSerializer<BuyerMobileGoogleOidcStartRequestModeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'SIGN_IN': 'SIGN_IN',
    'SIGN_UP': 'SIGN_UP',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'SIGN_IN': 'SIGN_IN',
    'SIGN_UP': 'SIGN_UP',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BuyerMobileGoogleOidcStartRequestModeEnum
  ];
  @override
  final String wireName = 'BuyerMobileGoogleOidcStartRequestModeEnum';

  @override
  Object serialize(Serializers serializers,
          BuyerMobileGoogleOidcStartRequestModeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BuyerMobileGoogleOidcStartRequestModeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BuyerMobileGoogleOidcStartRequestModeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BuyerMobileGoogleOidcStartRequest
    extends BuyerMobileGoogleOidcStartRequest {
  @override
  final BuyerMobileGoogleOidcStartRequestModeEnum mode;
  @override
  final String? mobileE164;
  @override
  final String? buyerType;
  @override
  final String? companyName;
  @override
  final bool? termsAccepted;
  @override
  final bool? privacyAccepted;

  factory _$BuyerMobileGoogleOidcStartRequest(
          [void Function(BuyerMobileGoogleOidcStartRequestBuilder)? updates]) =>
      (BuyerMobileGoogleOidcStartRequestBuilder()..update(updates))._build();

  _$BuyerMobileGoogleOidcStartRequest._(
      {required this.mode,
      this.mobileE164,
      this.buyerType,
      this.companyName,
      this.termsAccepted,
      this.privacyAccepted})
      : super._();
  @override
  BuyerMobileGoogleOidcStartRequest rebuild(
          void Function(BuyerMobileGoogleOidcStartRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerMobileGoogleOidcStartRequestBuilder toBuilder() =>
      BuyerMobileGoogleOidcStartRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerMobileGoogleOidcStartRequest &&
        mode == other.mode &&
        mobileE164 == other.mobileE164 &&
        buyerType == other.buyerType &&
        companyName == other.companyName &&
        termsAccepted == other.termsAccepted &&
        privacyAccepted == other.privacyAccepted;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mode.hashCode);
    _$hash = $jc(_$hash, mobileE164.hashCode);
    _$hash = $jc(_$hash, buyerType.hashCode);
    _$hash = $jc(_$hash, companyName.hashCode);
    _$hash = $jc(_$hash, termsAccepted.hashCode);
    _$hash = $jc(_$hash, privacyAccepted.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerMobileGoogleOidcStartRequest')
          ..add('mode', mode)
          ..add('mobileE164', mobileE164)
          ..add('buyerType', buyerType)
          ..add('companyName', companyName)
          ..add('termsAccepted', termsAccepted)
          ..add('privacyAccepted', privacyAccepted))
        .toString();
  }
}

class BuyerMobileGoogleOidcStartRequestBuilder
    implements
        Builder<BuyerMobileGoogleOidcStartRequest,
            BuyerMobileGoogleOidcStartRequestBuilder> {
  _$BuyerMobileGoogleOidcStartRequest? _$v;

  BuyerMobileGoogleOidcStartRequestModeEnum? _mode;
  BuyerMobileGoogleOidcStartRequestModeEnum? get mode => _$this._mode;
  set mode(BuyerMobileGoogleOidcStartRequestModeEnum? mode) =>
      _$this._mode = mode;

  String? _mobileE164;
  String? get mobileE164 => _$this._mobileE164;
  set mobileE164(String? mobileE164) => _$this._mobileE164 = mobileE164;

  String? _buyerType;
  String? get buyerType => _$this._buyerType;
  set buyerType(String? buyerType) => _$this._buyerType = buyerType;

  String? _companyName;
  String? get companyName => _$this._companyName;
  set companyName(String? companyName) => _$this._companyName = companyName;

  bool? _termsAccepted;
  bool? get termsAccepted => _$this._termsAccepted;
  set termsAccepted(bool? termsAccepted) =>
      _$this._termsAccepted = termsAccepted;

  bool? _privacyAccepted;
  bool? get privacyAccepted => _$this._privacyAccepted;
  set privacyAccepted(bool? privacyAccepted) =>
      _$this._privacyAccepted = privacyAccepted;

  BuyerMobileGoogleOidcStartRequestBuilder() {
    BuyerMobileGoogleOidcStartRequest._defaults(this);
  }

  BuyerMobileGoogleOidcStartRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mode = $v.mode;
      _mobileE164 = $v.mobileE164;
      _buyerType = $v.buyerType;
      _companyName = $v.companyName;
      _termsAccepted = $v.termsAccepted;
      _privacyAccepted = $v.privacyAccepted;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerMobileGoogleOidcStartRequest other) {
    _$v = other as _$BuyerMobileGoogleOidcStartRequest;
  }

  @override
  void update(
      void Function(BuyerMobileGoogleOidcStartRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerMobileGoogleOidcStartRequest build() => _build();

  _$BuyerMobileGoogleOidcStartRequest _build() {
    final _$result = _$v ??
        _$BuyerMobileGoogleOidcStartRequest._(
          mode: BuiltValueNullFieldError.checkNotNull(
              mode, r'BuyerMobileGoogleOidcStartRequest', 'mode'),
          mobileE164: mobileE164,
          buyerType: buyerType,
          companyName: companyName,
          termsAccepted: termsAccepted,
          privacyAccepted: privacyAccepted,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'google_mobile_exchange_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$GoogleMobileExchangeRequest extends GoogleMobileExchangeRequest {
  @override
  final String exchangeCode;
  @override
  final String? deviceId;

  factory _$GoogleMobileExchangeRequest(
          [void Function(GoogleMobileExchangeRequestBuilder)? updates]) =>
      (GoogleMobileExchangeRequestBuilder()..update(updates))._build();

  _$GoogleMobileExchangeRequest._({required this.exchangeCode, this.deviceId})
      : super._();
  @override
  GoogleMobileExchangeRequest rebuild(
          void Function(GoogleMobileExchangeRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  GoogleMobileExchangeRequestBuilder toBuilder() =>
      GoogleMobileExchangeRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is GoogleMobileExchangeRequest &&
        exchangeCode == other.exchangeCode &&
        deviceId == other.deviceId;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, exchangeCode.hashCode);
    _$hash = $jc(_$hash, deviceId.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'GoogleMobileExchangeRequest')
          ..add('exchangeCode', exchangeCode)
          ..add('deviceId', deviceId))
        .toString();
  }
}

class GoogleMobileExchangeRequestBuilder
    implements
        Builder<GoogleMobileExchangeRequest,
            GoogleMobileExchangeRequestBuilder> {
  _$GoogleMobileExchangeRequest? _$v;

  String? _exchangeCode;
  String? get exchangeCode => _$this._exchangeCode;
  set exchangeCode(String? exchangeCode) => _$this._exchangeCode = exchangeCode;

  String? _deviceId;
  String? get deviceId => _$this._deviceId;
  set deviceId(String? deviceId) => _$this._deviceId = deviceId;

  GoogleMobileExchangeRequestBuilder() {
    GoogleMobileExchangeRequest._defaults(this);
  }

  GoogleMobileExchangeRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _exchangeCode = $v.exchangeCode;
      _deviceId = $v.deviceId;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(GoogleMobileExchangeRequest other) {
    _$v = other as _$GoogleMobileExchangeRequest;
  }

  @override
  void update(void Function(GoogleMobileExchangeRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  GoogleMobileExchangeRequest build() => _build();

  _$GoogleMobileExchangeRequest _build() {
    final _$result = _$v ??
        _$GoogleMobileExchangeRequest._(
          exchangeCode: BuiltValueNullFieldError.checkNotNull(
              exchangeCode, r'GoogleMobileExchangeRequest', 'exchangeCode'),
          deviceId: deviceId,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

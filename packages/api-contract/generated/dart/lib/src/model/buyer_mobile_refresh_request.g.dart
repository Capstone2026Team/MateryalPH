// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'buyer_mobile_refresh_request.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BuyerMobileRefreshRequest extends BuyerMobileRefreshRequest {
  @override
  final String refreshToken;

  factory _$BuyerMobileRefreshRequest(
          [void Function(BuyerMobileRefreshRequestBuilder)? updates]) =>
      (BuyerMobileRefreshRequestBuilder()..update(updates))._build();

  _$BuyerMobileRefreshRequest._({required this.refreshToken}) : super._();
  @override
  BuyerMobileRefreshRequest rebuild(
          void Function(BuyerMobileRefreshRequestBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BuyerMobileRefreshRequestBuilder toBuilder() =>
      BuyerMobileRefreshRequestBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BuyerMobileRefreshRequest &&
        refreshToken == other.refreshToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, refreshToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BuyerMobileRefreshRequest')
          ..add('refreshToken', refreshToken))
        .toString();
  }
}

class BuyerMobileRefreshRequestBuilder
    implements
        Builder<BuyerMobileRefreshRequest, BuyerMobileRefreshRequestBuilder> {
  _$BuyerMobileRefreshRequest? _$v;

  String? _refreshToken;
  String? get refreshToken => _$this._refreshToken;
  set refreshToken(String? refreshToken) => _$this._refreshToken = refreshToken;

  BuyerMobileRefreshRequestBuilder() {
    BuyerMobileRefreshRequest._defaults(this);
  }

  BuyerMobileRefreshRequestBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _refreshToken = $v.refreshToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BuyerMobileRefreshRequest other) {
    _$v = other as _$BuyerMobileRefreshRequest;
  }

  @override
  void update(void Function(BuyerMobileRefreshRequestBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BuyerMobileRefreshRequest build() => _build();

  _$BuyerMobileRefreshRequest _build() {
    final _$result = _$v ??
        _$BuyerMobileRefreshRequest._(
          refreshToken: BuiltValueNullFieldError.checkNotNull(
              refreshToken, r'BuyerMobileRefreshRequest', 'refreshToken'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

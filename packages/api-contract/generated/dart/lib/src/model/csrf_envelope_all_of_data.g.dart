// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csrf_envelope_all_of_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CsrfEnvelopeAllOfData extends CsrfEnvelopeAllOfData {
  @override
  final String csrfToken;

  factory _$CsrfEnvelopeAllOfData(
          [void Function(CsrfEnvelopeAllOfDataBuilder)? updates]) =>
      (CsrfEnvelopeAllOfDataBuilder()..update(updates))._build();

  _$CsrfEnvelopeAllOfData._({required this.csrfToken}) : super._();
  @override
  CsrfEnvelopeAllOfData rebuild(
          void Function(CsrfEnvelopeAllOfDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CsrfEnvelopeAllOfDataBuilder toBuilder() =>
      CsrfEnvelopeAllOfDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CsrfEnvelopeAllOfData && csrfToken == other.csrfToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, csrfToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CsrfEnvelopeAllOfData')
          ..add('csrfToken', csrfToken))
        .toString();
  }
}

class CsrfEnvelopeAllOfDataBuilder
    implements Builder<CsrfEnvelopeAllOfData, CsrfEnvelopeAllOfDataBuilder> {
  _$CsrfEnvelopeAllOfData? _$v;

  String? _csrfToken;
  String? get csrfToken => _$this._csrfToken;
  set csrfToken(String? csrfToken) => _$this._csrfToken = csrfToken;

  CsrfEnvelopeAllOfDataBuilder() {
    CsrfEnvelopeAllOfData._defaults(this);
  }

  CsrfEnvelopeAllOfDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _csrfToken = $v.csrfToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(CsrfEnvelopeAllOfData other) {
    _$v = other as _$CsrfEnvelopeAllOfData;
  }

  @override
  void update(void Function(CsrfEnvelopeAllOfDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CsrfEnvelopeAllOfData build() => _build();

  _$CsrfEnvelopeAllOfData _build() {
    final _$result = _$v ??
        _$CsrfEnvelopeAllOfData._(
          csrfToken: BuiltValueNullFieldError.checkNotNull(
              csrfToken, r'CsrfEnvelopeAllOfData', 'csrfToken'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

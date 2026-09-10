// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'csrf_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$CsrfEnvelope extends CsrfEnvelope {
  @override
  final BuiltMap<String, JsonObject?> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<JsonObject?> errors;

  factory _$CsrfEnvelope([void Function(CsrfEnvelopeBuilder)? updates]) =>
      (CsrfEnvelopeBuilder()..update(updates))._build();

  _$CsrfEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  CsrfEnvelope rebuild(void Function(CsrfEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  CsrfEnvelopeBuilder toBuilder() => CsrfEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CsrfEnvelope &&
        data == other.data &&
        meta == other.meta &&
        errors == other.errors;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, data.hashCode);
    _$hash = $jc(_$hash, meta.hashCode);
    _$hash = $jc(_$hash, errors.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'CsrfEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class CsrfEnvelopeBuilder
    implements
        Builder<CsrfEnvelope, CsrfEnvelopeBuilder>,
        SuccessEnvelopeBuilder {
  _$CsrfEnvelope? _$v;

  MapBuilder<String, JsonObject?>? _data;
  MapBuilder<String, JsonObject?> get data =>
      _$this._data ??= MapBuilder<String, JsonObject?>();
  set data(covariant MapBuilder<String, JsonObject?>? data) =>
      _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(covariant MapBuilder<String, JsonObject?>? meta) =>
      _$this._meta = meta;

  ListBuilder<JsonObject?>? _errors;
  ListBuilder<JsonObject?> get errors =>
      _$this._errors ??= ListBuilder<JsonObject?>();
  set errors(covariant ListBuilder<JsonObject?>? errors) =>
      _$this._errors = errors;

  CsrfEnvelopeBuilder() {
    CsrfEnvelope._defaults(this);
  }

  CsrfEnvelopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data.toBuilder();
      _meta = $v.meta.toBuilder();
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(covariant CsrfEnvelope other) {
    _$v = other as _$CsrfEnvelope;
  }

  @override
  void update(void Function(CsrfEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  CsrfEnvelope build() => _build();

  _$CsrfEnvelope _build() {
    _$CsrfEnvelope _$result;
    try {
      _$result = _$v ??
          _$CsrfEnvelope._(
            data: data.build(),
            meta: meta.build(),
            errors: errors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'data';
        data.build();
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'CsrfEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

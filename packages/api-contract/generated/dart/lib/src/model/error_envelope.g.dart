// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'error_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$ErrorEnvelope extends ErrorEnvelope {
  @override
  final JsonObject? data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<ApiError> errors;

  factory _$ErrorEnvelope([void Function(ErrorEnvelopeBuilder)? updates]) =>
      (ErrorEnvelopeBuilder()..update(updates))._build();

  _$ErrorEnvelope._({this.data, required this.meta, required this.errors})
      : super._();
  @override
  ErrorEnvelope rebuild(void Function(ErrorEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  ErrorEnvelopeBuilder toBuilder() => ErrorEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ErrorEnvelope &&
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
    return (newBuiltValueToStringHelper(r'ErrorEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class ErrorEnvelopeBuilder
    implements Builder<ErrorEnvelope, ErrorEnvelopeBuilder> {
  _$ErrorEnvelope? _$v;

  JsonObject? _data;
  JsonObject? get data => _$this._data;
  set data(JsonObject? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<ApiError>? _errors;
  ListBuilder<ApiError> get errors =>
      _$this._errors ??= ListBuilder<ApiError>();
  set errors(ListBuilder<ApiError>? errors) => _$this._errors = errors;

  ErrorEnvelopeBuilder() {
    ErrorEnvelope._defaults(this);
  }

  ErrorEnvelopeBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _data = $v.data;
      _meta = $v.meta.toBuilder();
      _errors = $v.errors.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(ErrorEnvelope other) {
    _$v = other as _$ErrorEnvelope;
  }

  @override
  void update(void Function(ErrorEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  ErrorEnvelope build() => _build();

  _$ErrorEnvelope _build() {
    _$ErrorEnvelope _$result;
    try {
      _$result = _$v ??
          _$ErrorEnvelope._(
            data: data,
            meta: meta.build(),
            errors: errors.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'meta';
        meta.build();
        _$failedField = 'errors';
        errors.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'ErrorEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

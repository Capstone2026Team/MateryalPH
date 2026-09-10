// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$AuthEnvelope extends AuthEnvelope {
  @override
  final BuiltMap<String, JsonObject?> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<JsonObject?> errors;

  factory _$AuthEnvelope([void Function(AuthEnvelopeBuilder)? updates]) =>
      (AuthEnvelopeBuilder()..update(updates))._build();

  _$AuthEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  AuthEnvelope rebuild(void Function(AuthEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  AuthEnvelopeBuilder toBuilder() => AuthEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AuthEnvelope &&
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
    return (newBuiltValueToStringHelper(r'AuthEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class AuthEnvelopeBuilder
    implements
        Builder<AuthEnvelope, AuthEnvelopeBuilder>,
        SuccessEnvelopeBuilder {
  _$AuthEnvelope? _$v;

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

  AuthEnvelopeBuilder() {
    AuthEnvelope._defaults(this);
  }

  AuthEnvelopeBuilder get _$this {
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
  void replace(covariant AuthEnvelope other) {
    _$v = other as _$AuthEnvelope;
  }

  @override
  void update(void Function(AuthEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  AuthEnvelope build() => _build();

  _$AuthEnvelope _build() {
    _$AuthEnvelope _$result;
    try {
      _$result = _$v ??
          _$AuthEnvelope._(
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
            r'AuthEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

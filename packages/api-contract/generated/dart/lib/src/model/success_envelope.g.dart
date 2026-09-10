// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'success_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

abstract class SuccessEnvelopeBuilder {
  void replace(SuccessEnvelope other);
  void update(void Function(SuccessEnvelopeBuilder) updates);
  MapBuilder<String, JsonObject?> get data;
  set data(MapBuilder<String, JsonObject?>? data);

  MapBuilder<String, JsonObject?> get meta;
  set meta(MapBuilder<String, JsonObject?>? meta);

  ListBuilder<JsonObject?> get errors;
  set errors(ListBuilder<JsonObject?>? errors);
}

class _$$SuccessEnvelope extends $SuccessEnvelope {
  @override
  final BuiltMap<String, JsonObject?> data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<JsonObject?> errors;

  factory _$$SuccessEnvelope(
          [void Function($SuccessEnvelopeBuilder)? updates]) =>
      ($SuccessEnvelopeBuilder()..update(updates))._build();

  _$$SuccessEnvelope._(
      {required this.data, required this.meta, required this.errors})
      : super._();
  @override
  $SuccessEnvelope rebuild(void Function($SuccessEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  $SuccessEnvelopeBuilder toBuilder() =>
      $SuccessEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is $SuccessEnvelope &&
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
    return (newBuiltValueToStringHelper(r'$SuccessEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class $SuccessEnvelopeBuilder
    implements
        Builder<$SuccessEnvelope, $SuccessEnvelopeBuilder>,
        SuccessEnvelopeBuilder {
  _$$SuccessEnvelope? _$v;

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

  $SuccessEnvelopeBuilder() {
    $SuccessEnvelope._defaults(this);
  }

  $SuccessEnvelopeBuilder get _$this {
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
  void replace(covariant $SuccessEnvelope other) {
    _$v = other as _$$SuccessEnvelope;
  }

  @override
  void update(void Function($SuccessEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  $SuccessEnvelope build() => _build();

  _$$SuccessEnvelope _build() {
    _$$SuccessEnvelope _$result;
    try {
      _$result = _$v ??
          _$$SuccessEnvelope._(
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
            r'$SuccessEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

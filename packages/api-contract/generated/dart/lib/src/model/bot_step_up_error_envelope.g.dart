// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot_step_up_error_envelope.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$BotStepUpErrorEnvelope extends BotStepUpErrorEnvelope {
  @override
  final JsonObject? data;
  @override
  final BuiltMap<String, JsonObject?> meta;
  @override
  final BuiltList<BotStepUpErrorEnvelopeAllOfErrors> errors;

  factory _$BotStepUpErrorEnvelope(
          [void Function(BotStepUpErrorEnvelopeBuilder)? updates]) =>
      (BotStepUpErrorEnvelopeBuilder()..update(updates))._build();

  _$BotStepUpErrorEnvelope._(
      {this.data, required this.meta, required this.errors})
      : super._();
  @override
  BotStepUpErrorEnvelope rebuild(
          void Function(BotStepUpErrorEnvelopeBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BotStepUpErrorEnvelopeBuilder toBuilder() =>
      BotStepUpErrorEnvelopeBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BotStepUpErrorEnvelope &&
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
    return (newBuiltValueToStringHelper(r'BotStepUpErrorEnvelope')
          ..add('data', data)
          ..add('meta', meta)
          ..add('errors', errors))
        .toString();
  }
}

class BotStepUpErrorEnvelopeBuilder
    implements Builder<BotStepUpErrorEnvelope, BotStepUpErrorEnvelopeBuilder> {
  _$BotStepUpErrorEnvelope? _$v;

  JsonObject? _data;
  JsonObject? get data => _$this._data;
  set data(JsonObject? data) => _$this._data = data;

  MapBuilder<String, JsonObject?>? _meta;
  MapBuilder<String, JsonObject?> get meta =>
      _$this._meta ??= MapBuilder<String, JsonObject?>();
  set meta(MapBuilder<String, JsonObject?>? meta) => _$this._meta = meta;

  ListBuilder<BotStepUpErrorEnvelopeAllOfErrors>? _errors;
  ListBuilder<BotStepUpErrorEnvelopeAllOfErrors> get errors =>
      _$this._errors ??= ListBuilder<BotStepUpErrorEnvelopeAllOfErrors>();
  set errors(ListBuilder<BotStepUpErrorEnvelopeAllOfErrors>? errors) =>
      _$this._errors = errors;

  BotStepUpErrorEnvelopeBuilder() {
    BotStepUpErrorEnvelope._defaults(this);
  }

  BotStepUpErrorEnvelopeBuilder get _$this {
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
  void replace(BotStepUpErrorEnvelope other) {
    _$v = other as _$BotStepUpErrorEnvelope;
  }

  @override
  void update(void Function(BotStepUpErrorEnvelopeBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BotStepUpErrorEnvelope build() => _build();

  _$BotStepUpErrorEnvelope _build() {
    _$BotStepUpErrorEnvelope _$result;
    try {
      _$result = _$v ??
          _$BotStepUpErrorEnvelope._(
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
            r'BotStepUpErrorEnvelope', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

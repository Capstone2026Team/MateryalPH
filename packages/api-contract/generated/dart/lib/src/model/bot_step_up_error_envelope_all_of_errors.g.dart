// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot_step_up_error_envelope_all_of_errors.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BotStepUpErrorEnvelopeAllOfErrorsCodeEnum
    _$botStepUpErrorEnvelopeAllOfErrorsCodeEnum_BOT_STEP_UP_REQUIRED =
    const BotStepUpErrorEnvelopeAllOfErrorsCodeEnum._('BOT_STEP_UP_REQUIRED');

BotStepUpErrorEnvelopeAllOfErrorsCodeEnum
    _$botStepUpErrorEnvelopeAllOfErrorsCodeEnumValueOf(String name) {
  switch (name) {
    case 'BOT_STEP_UP_REQUIRED':
      return _$botStepUpErrorEnvelopeAllOfErrorsCodeEnum_BOT_STEP_UP_REQUIRED;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BotStepUpErrorEnvelopeAllOfErrorsCodeEnum>
    _$botStepUpErrorEnvelopeAllOfErrorsCodeEnumValues = BuiltSet<
        BotStepUpErrorEnvelopeAllOfErrorsCodeEnum>(const <BotStepUpErrorEnvelopeAllOfErrorsCodeEnum>[
  _$botStepUpErrorEnvelopeAllOfErrorsCodeEnum_BOT_STEP_UP_REQUIRED,
]);

Serializer<BotStepUpErrorEnvelopeAllOfErrorsCodeEnum>
    _$botStepUpErrorEnvelopeAllOfErrorsCodeEnumSerializer =
    _$BotStepUpErrorEnvelopeAllOfErrorsCodeEnumSerializer();

class _$BotStepUpErrorEnvelopeAllOfErrorsCodeEnumSerializer
    implements PrimitiveSerializer<BotStepUpErrorEnvelopeAllOfErrorsCodeEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'BOT_STEP_UP_REQUIRED': 'BOT_STEP_UP_REQUIRED',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'BOT_STEP_UP_REQUIRED': 'BOT_STEP_UP_REQUIRED',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BotStepUpErrorEnvelopeAllOfErrorsCodeEnum
  ];
  @override
  final String wireName = 'BotStepUpErrorEnvelopeAllOfErrorsCodeEnum';

  @override
  Object serialize(Serializers serializers,
          BotStepUpErrorEnvelopeAllOfErrorsCodeEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BotStepUpErrorEnvelopeAllOfErrorsCodeEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BotStepUpErrorEnvelopeAllOfErrorsCodeEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BotStepUpErrorEnvelopeAllOfErrors
    extends BotStepUpErrorEnvelopeAllOfErrors {
  @override
  final BotStepUpErrorEnvelopeAllOfErrorsCodeEnum code;
  @override
  final String message;
  @override
  final BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails details;

  factory _$BotStepUpErrorEnvelopeAllOfErrors(
          [void Function(BotStepUpErrorEnvelopeAllOfErrorsBuilder)? updates]) =>
      (BotStepUpErrorEnvelopeAllOfErrorsBuilder()..update(updates))._build();

  _$BotStepUpErrorEnvelopeAllOfErrors._(
      {required this.code, required this.message, required this.details})
      : super._();
  @override
  BotStepUpErrorEnvelopeAllOfErrors rebuild(
          void Function(BotStepUpErrorEnvelopeAllOfErrorsBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BotStepUpErrorEnvelopeAllOfErrorsBuilder toBuilder() =>
      BotStepUpErrorEnvelopeAllOfErrorsBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BotStepUpErrorEnvelopeAllOfErrors &&
        code == other.code &&
        message == other.message &&
        details == other.details;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, code.hashCode);
    _$hash = $jc(_$hash, message.hashCode);
    _$hash = $jc(_$hash, details.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BotStepUpErrorEnvelopeAllOfErrors')
          ..add('code', code)
          ..add('message', message)
          ..add('details', details))
        .toString();
  }
}

class BotStepUpErrorEnvelopeAllOfErrorsBuilder
    implements
        Builder<BotStepUpErrorEnvelopeAllOfErrors,
            BotStepUpErrorEnvelopeAllOfErrorsBuilder> {
  _$BotStepUpErrorEnvelopeAllOfErrors? _$v;

  BotStepUpErrorEnvelopeAllOfErrorsCodeEnum? _code;
  BotStepUpErrorEnvelopeAllOfErrorsCodeEnum? get code => _$this._code;
  set code(BotStepUpErrorEnvelopeAllOfErrorsCodeEnum? code) =>
      _$this._code = code;

  String? _message;
  String? get message => _$this._message;
  set message(String? message) => _$this._message = message;

  BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder? _details;
  BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder get details =>
      _$this._details ??=
          BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder();
  set details(BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder? details) =>
      _$this._details = details;

  BotStepUpErrorEnvelopeAllOfErrorsBuilder() {
    BotStepUpErrorEnvelopeAllOfErrors._defaults(this);
  }

  BotStepUpErrorEnvelopeAllOfErrorsBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _code = $v.code;
      _message = $v.message;
      _details = $v.details.toBuilder();
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BotStepUpErrorEnvelopeAllOfErrors other) {
    _$v = other as _$BotStepUpErrorEnvelopeAllOfErrors;
  }

  @override
  void update(
      void Function(BotStepUpErrorEnvelopeAllOfErrorsBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BotStepUpErrorEnvelopeAllOfErrors build() => _build();

  _$BotStepUpErrorEnvelopeAllOfErrors _build() {
    _$BotStepUpErrorEnvelopeAllOfErrors _$result;
    try {
      _$result = _$v ??
          _$BotStepUpErrorEnvelopeAllOfErrors._(
            code: BuiltValueNullFieldError.checkNotNull(
                code, r'BotStepUpErrorEnvelopeAllOfErrors', 'code'),
            message: BuiltValueNullFieldError.checkNotNull(
                message, r'BotStepUpErrorEnvelopeAllOfErrors', 'message'),
            details: details.build(),
          );
    } catch (_) {
      late String _$failedField;
      try {
        _$failedField = 'details';
        details.build();
      } catch (e) {
        throw BuiltValueNestedFieldError(
            r'BotStepUpErrorEnvelopeAllOfErrors', _$failedField, e.toString());
      }
      rethrow;
    }
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

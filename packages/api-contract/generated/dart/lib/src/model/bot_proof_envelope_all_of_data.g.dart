// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bot_proof_envelope_all_of_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const BotProofEnvelopeAllOfDataVerifiedEnum
    _$botProofEnvelopeAllOfDataVerifiedEnum_true_ =
    const BotProofEnvelopeAllOfDataVerifiedEnum._('true_');

BotProofEnvelopeAllOfDataVerifiedEnum
    _$botProofEnvelopeAllOfDataVerifiedEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$botProofEnvelopeAllOfDataVerifiedEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<BotProofEnvelopeAllOfDataVerifiedEnum>
    _$botProofEnvelopeAllOfDataVerifiedEnumValues = BuiltSet<
        BotProofEnvelopeAllOfDataVerifiedEnum>(const <BotProofEnvelopeAllOfDataVerifiedEnum>[
  _$botProofEnvelopeAllOfDataVerifiedEnum_true_,
]);

Serializer<BotProofEnvelopeAllOfDataVerifiedEnum>
    _$botProofEnvelopeAllOfDataVerifiedEnumSerializer =
    _$BotProofEnvelopeAllOfDataVerifiedEnumSerializer();

class _$BotProofEnvelopeAllOfDataVerifiedEnumSerializer
    implements PrimitiveSerializer<BotProofEnvelopeAllOfDataVerifiedEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    BotProofEnvelopeAllOfDataVerifiedEnum
  ];
  @override
  final String wireName = 'BotProofEnvelopeAllOfDataVerifiedEnum';

  @override
  Object serialize(
          Serializers serializers, BotProofEnvelopeAllOfDataVerifiedEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  BotProofEnvelopeAllOfDataVerifiedEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      BotProofEnvelopeAllOfDataVerifiedEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$BotProofEnvelopeAllOfData extends BotProofEnvelopeAllOfData {
  @override
  final BotProofEnvelopeAllOfDataVerifiedEnum verified;
  @override
  final int expiresIn;
  @override
  final String? stepUpToken;

  factory _$BotProofEnvelopeAllOfData(
          [void Function(BotProofEnvelopeAllOfDataBuilder)? updates]) =>
      (BotProofEnvelopeAllOfDataBuilder()..update(updates))._build();

  _$BotProofEnvelopeAllOfData._(
      {required this.verified, required this.expiresIn, this.stepUpToken})
      : super._();
  @override
  BotProofEnvelopeAllOfData rebuild(
          void Function(BotProofEnvelopeAllOfDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  BotProofEnvelopeAllOfDataBuilder toBuilder() =>
      BotProofEnvelopeAllOfDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is BotProofEnvelopeAllOfData &&
        verified == other.verified &&
        expiresIn == other.expiresIn &&
        stepUpToken == other.stepUpToken;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, verified.hashCode);
    _$hash = $jc(_$hash, expiresIn.hashCode);
    _$hash = $jc(_$hash, stepUpToken.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'BotProofEnvelopeAllOfData')
          ..add('verified', verified)
          ..add('expiresIn', expiresIn)
          ..add('stepUpToken', stepUpToken))
        .toString();
  }
}

class BotProofEnvelopeAllOfDataBuilder
    implements
        Builder<BotProofEnvelopeAllOfData, BotProofEnvelopeAllOfDataBuilder> {
  _$BotProofEnvelopeAllOfData? _$v;

  BotProofEnvelopeAllOfDataVerifiedEnum? _verified;
  BotProofEnvelopeAllOfDataVerifiedEnum? get verified => _$this._verified;
  set verified(BotProofEnvelopeAllOfDataVerifiedEnum? verified) =>
      _$this._verified = verified;

  int? _expiresIn;
  int? get expiresIn => _$this._expiresIn;
  set expiresIn(int? expiresIn) => _$this._expiresIn = expiresIn;

  String? _stepUpToken;
  String? get stepUpToken => _$this._stepUpToken;
  set stepUpToken(String? stepUpToken) => _$this._stepUpToken = stepUpToken;

  BotProofEnvelopeAllOfDataBuilder() {
    BotProofEnvelopeAllOfData._defaults(this);
  }

  BotProofEnvelopeAllOfDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _verified = $v.verified;
      _expiresIn = $v.expiresIn;
      _stepUpToken = $v.stepUpToken;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(BotProofEnvelopeAllOfData other) {
    _$v = other as _$BotProofEnvelopeAllOfData;
  }

  @override
  void update(void Function(BotProofEnvelopeAllOfDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  BotProofEnvelopeAllOfData build() => _build();

  _$BotProofEnvelopeAllOfData _build() {
    final _$result = _$v ??
        _$BotProofEnvelopeAllOfData._(
          verified: BuiltValueNullFieldError.checkNotNull(
              verified, r'BotProofEnvelopeAllOfData', 'verified'),
          expiresIn: BuiltValueNullFieldError.checkNotNull(
              expiresIn, r'BotProofEnvelopeAllOfData', 'expiresIn'),
          stepUpToken: stepUpToken,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

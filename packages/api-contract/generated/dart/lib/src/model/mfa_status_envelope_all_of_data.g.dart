// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mfa_status_envelope_all_of_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MfaStatusEnvelopeAllOfDataMfaRequiredEnum
    _$mfaStatusEnvelopeAllOfDataMfaRequiredEnum_true_ =
    const MfaStatusEnvelopeAllOfDataMfaRequiredEnum._('true_');

MfaStatusEnvelopeAllOfDataMfaRequiredEnum
    _$mfaStatusEnvelopeAllOfDataMfaRequiredEnumValueOf(String name) {
  switch (name) {
    case 'true_':
      return _$mfaStatusEnvelopeAllOfDataMfaRequiredEnum_true_;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MfaStatusEnvelopeAllOfDataMfaRequiredEnum>
    _$mfaStatusEnvelopeAllOfDataMfaRequiredEnumValues = BuiltSet<
        MfaStatusEnvelopeAllOfDataMfaRequiredEnum>(const <MfaStatusEnvelopeAllOfDataMfaRequiredEnum>[
  _$mfaStatusEnvelopeAllOfDataMfaRequiredEnum_true_,
]);

Serializer<MfaStatusEnvelopeAllOfDataMfaRequiredEnum>
    _$mfaStatusEnvelopeAllOfDataMfaRequiredEnumSerializer =
    _$MfaStatusEnvelopeAllOfDataMfaRequiredEnumSerializer();

class _$MfaStatusEnvelopeAllOfDataMfaRequiredEnumSerializer
    implements PrimitiveSerializer<MfaStatusEnvelopeAllOfDataMfaRequiredEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'true_': 'true',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'true': 'true_',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MfaStatusEnvelopeAllOfDataMfaRequiredEnum
  ];
  @override
  final String wireName = 'MfaStatusEnvelopeAllOfDataMfaRequiredEnum';

  @override
  Object serialize(Serializers serializers,
          MfaStatusEnvelopeAllOfDataMfaRequiredEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MfaStatusEnvelopeAllOfDataMfaRequiredEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MfaStatusEnvelopeAllOfDataMfaRequiredEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MfaStatusEnvelopeAllOfData extends MfaStatusEnvelopeAllOfData {
  @override
  final MfaStatusEnvelopeAllOfDataMfaRequiredEnum mfaRequired;
  @override
  final bool mfaEnrollmentRequired;

  factory _$MfaStatusEnvelopeAllOfData(
          [void Function(MfaStatusEnvelopeAllOfDataBuilder)? updates]) =>
      (MfaStatusEnvelopeAllOfDataBuilder()..update(updates))._build();

  _$MfaStatusEnvelopeAllOfData._(
      {required this.mfaRequired, required this.mfaEnrollmentRequired})
      : super._();
  @override
  MfaStatusEnvelopeAllOfData rebuild(
          void Function(MfaStatusEnvelopeAllOfDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MfaStatusEnvelopeAllOfDataBuilder toBuilder() =>
      MfaStatusEnvelopeAllOfDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MfaStatusEnvelopeAllOfData &&
        mfaRequired == other.mfaRequired &&
        mfaEnrollmentRequired == other.mfaEnrollmentRequired;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, mfaRequired.hashCode);
    _$hash = $jc(_$hash, mfaEnrollmentRequired.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MfaStatusEnvelopeAllOfData')
          ..add('mfaRequired', mfaRequired)
          ..add('mfaEnrollmentRequired', mfaEnrollmentRequired))
        .toString();
  }
}

class MfaStatusEnvelopeAllOfDataBuilder
    implements
        Builder<MfaStatusEnvelopeAllOfData, MfaStatusEnvelopeAllOfDataBuilder> {
  _$MfaStatusEnvelopeAllOfData? _$v;

  MfaStatusEnvelopeAllOfDataMfaRequiredEnum? _mfaRequired;
  MfaStatusEnvelopeAllOfDataMfaRequiredEnum? get mfaRequired =>
      _$this._mfaRequired;
  set mfaRequired(MfaStatusEnvelopeAllOfDataMfaRequiredEnum? mfaRequired) =>
      _$this._mfaRequired = mfaRequired;

  bool? _mfaEnrollmentRequired;
  bool? get mfaEnrollmentRequired => _$this._mfaEnrollmentRequired;
  set mfaEnrollmentRequired(bool? mfaEnrollmentRequired) =>
      _$this._mfaEnrollmentRequired = mfaEnrollmentRequired;

  MfaStatusEnvelopeAllOfDataBuilder() {
    MfaStatusEnvelopeAllOfData._defaults(this);
  }

  MfaStatusEnvelopeAllOfDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _mfaRequired = $v.mfaRequired;
      _mfaEnrollmentRequired = $v.mfaEnrollmentRequired;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MfaStatusEnvelopeAllOfData other) {
    _$v = other as _$MfaStatusEnvelopeAllOfData;
  }

  @override
  void update(void Function(MfaStatusEnvelopeAllOfDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MfaStatusEnvelopeAllOfData build() => _build();

  _$MfaStatusEnvelopeAllOfData _build() {
    final _$result = _$v ??
        _$MfaStatusEnvelopeAllOfData._(
          mfaRequired: BuiltValueNullFieldError.checkNotNull(
              mfaRequired, r'MfaStatusEnvelopeAllOfData', 'mfaRequired'),
          mfaEnrollmentRequired: BuiltValueNullFieldError.checkNotNull(
              mfaEnrollmentRequired,
              r'MfaStatusEnvelopeAllOfData',
              'mfaEnrollmentRequired'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

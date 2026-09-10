// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fee_assessment.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FeeAssessmentCommissionBasisPointsEnum
    _$feeAssessmentCommissionBasisPointsEnum_number200 =
    const FeeAssessmentCommissionBasisPointsEnum._('number200');

FeeAssessmentCommissionBasisPointsEnum
    _$feeAssessmentCommissionBasisPointsEnumValueOf(String name) {
  switch (name) {
    case 'number200':
      return _$feeAssessmentCommissionBasisPointsEnum_number200;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FeeAssessmentCommissionBasisPointsEnum>
    _$feeAssessmentCommissionBasisPointsEnumValues = BuiltSet<
        FeeAssessmentCommissionBasisPointsEnum>(const <FeeAssessmentCommissionBasisPointsEnum>[
  _$feeAssessmentCommissionBasisPointsEnum_number200,
]);

Serializer<FeeAssessmentCommissionBasisPointsEnum>
    _$feeAssessmentCommissionBasisPointsEnumSerializer =
    _$FeeAssessmentCommissionBasisPointsEnumSerializer();

class _$FeeAssessmentCommissionBasisPointsEnumSerializer
    implements PrimitiveSerializer<FeeAssessmentCommissionBasisPointsEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'number200': 200,
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    200: 'number200',
  };

  @override
  final Iterable<Type> types = const <Type>[
    FeeAssessmentCommissionBasisPointsEnum
  ];
  @override
  final String wireName = 'FeeAssessmentCommissionBasisPointsEnum';

  @override
  Object serialize(Serializers serializers,
          FeeAssessmentCommissionBasisPointsEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FeeAssessmentCommissionBasisPointsEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FeeAssessmentCommissionBasisPointsEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FeeAssessment extends FeeAssessment {
  @override
  final String id;
  @override
  final String orderId;
  @override
  final int commissionBasisCentavos;
  @override
  final FeeAssessmentCommissionBasisPointsEnum commissionBasisPoints;
  @override
  final int earnedCentavos;
  @override
  final String state;

  factory _$FeeAssessment([void Function(FeeAssessmentBuilder)? updates]) =>
      (FeeAssessmentBuilder()..update(updates))._build();

  _$FeeAssessment._(
      {required this.id,
      required this.orderId,
      required this.commissionBasisCentavos,
      required this.commissionBasisPoints,
      required this.earnedCentavos,
      required this.state})
      : super._();
  @override
  FeeAssessment rebuild(void Function(FeeAssessmentBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FeeAssessmentBuilder toBuilder() => FeeAssessmentBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FeeAssessment &&
        id == other.id &&
        orderId == other.orderId &&
        commissionBasisCentavos == other.commissionBasisCentavos &&
        commissionBasisPoints == other.commissionBasisPoints &&
        earnedCentavos == other.earnedCentavos &&
        state == other.state;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, commissionBasisCentavos.hashCode);
    _$hash = $jc(_$hash, commissionBasisPoints.hashCode);
    _$hash = $jc(_$hash, earnedCentavos.hashCode);
    _$hash = $jc(_$hash, state.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FeeAssessment')
          ..add('id', id)
          ..add('orderId', orderId)
          ..add('commissionBasisCentavos', commissionBasisCentavos)
          ..add('commissionBasisPoints', commissionBasisPoints)
          ..add('earnedCentavos', earnedCentavos)
          ..add('state', state))
        .toString();
  }
}

class FeeAssessmentBuilder
    implements Builder<FeeAssessment, FeeAssessmentBuilder> {
  _$FeeAssessment? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  int? _commissionBasisCentavos;
  int? get commissionBasisCentavos => _$this._commissionBasisCentavos;
  set commissionBasisCentavos(int? commissionBasisCentavos) =>
      _$this._commissionBasisCentavos = commissionBasisCentavos;

  FeeAssessmentCommissionBasisPointsEnum? _commissionBasisPoints;
  FeeAssessmentCommissionBasisPointsEnum? get commissionBasisPoints =>
      _$this._commissionBasisPoints;
  set commissionBasisPoints(
          FeeAssessmentCommissionBasisPointsEnum? commissionBasisPoints) =>
      _$this._commissionBasisPoints = commissionBasisPoints;

  int? _earnedCentavos;
  int? get earnedCentavos => _$this._earnedCentavos;
  set earnedCentavos(int? earnedCentavos) =>
      _$this._earnedCentavos = earnedCentavos;

  String? _state;
  String? get state => _$this._state;
  set state(String? state) => _$this._state = state;

  FeeAssessmentBuilder() {
    FeeAssessment._defaults(this);
  }

  FeeAssessmentBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orderId = $v.orderId;
      _commissionBasisCentavos = $v.commissionBasisCentavos;
      _commissionBasisPoints = $v.commissionBasisPoints;
      _earnedCentavos = $v.earnedCentavos;
      _state = $v.state;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FeeAssessment other) {
    _$v = other as _$FeeAssessment;
  }

  @override
  void update(void Function(FeeAssessmentBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FeeAssessment build() => _build();

  _$FeeAssessment _build() {
    final _$result = _$v ??
        _$FeeAssessment._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'FeeAssessment', 'id'),
          orderId: BuiltValueNullFieldError.checkNotNull(
              orderId, r'FeeAssessment', 'orderId'),
          commissionBasisCentavos: BuiltValueNullFieldError.checkNotNull(
              commissionBasisCentavos,
              r'FeeAssessment',
              'commissionBasisCentavos'),
          commissionBasisPoints: BuiltValueNullFieldError.checkNotNull(
              commissionBasisPoints, r'FeeAssessment', 'commissionBasisPoints'),
          earnedCentavos: BuiltValueNullFieldError.checkNotNull(
              earnedCentavos, r'FeeAssessment', 'earnedCentavos'),
          state: BuiltValueNullFieldError.checkNotNull(
              state, r'FeeAssessment', 'state'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

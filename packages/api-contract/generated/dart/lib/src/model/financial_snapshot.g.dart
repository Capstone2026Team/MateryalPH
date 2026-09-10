// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_snapshot.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const FinancialSnapshotEnvironmentEnum _$financialSnapshotEnvironmentEnum_TEST =
    const FinancialSnapshotEnvironmentEnum._('TEST');
const FinancialSnapshotEnvironmentEnum _$financialSnapshotEnvironmentEnum_DEMO =
    const FinancialSnapshotEnvironmentEnum._('DEMO');
const FinancialSnapshotEnvironmentEnum _$financialSnapshotEnvironmentEnum_LIVE =
    const FinancialSnapshotEnvironmentEnum._('LIVE');

FinancialSnapshotEnvironmentEnum _$financialSnapshotEnvironmentEnumValueOf(
    String name) {
  switch (name) {
    case 'TEST':
      return _$financialSnapshotEnvironmentEnum_TEST;
    case 'DEMO':
      return _$financialSnapshotEnvironmentEnum_DEMO;
    case 'LIVE':
      return _$financialSnapshotEnvironmentEnum_LIVE;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<FinancialSnapshotEnvironmentEnum>
    _$financialSnapshotEnvironmentEnumValues = BuiltSet<
        FinancialSnapshotEnvironmentEnum>(const <FinancialSnapshotEnvironmentEnum>[
  _$financialSnapshotEnvironmentEnum_TEST,
  _$financialSnapshotEnvironmentEnum_DEMO,
  _$financialSnapshotEnvironmentEnum_LIVE,
]);

Serializer<FinancialSnapshotEnvironmentEnum>
    _$financialSnapshotEnvironmentEnumSerializer =
    _$FinancialSnapshotEnvironmentEnumSerializer();

class _$FinancialSnapshotEnvironmentEnumSerializer
    implements PrimitiveSerializer<FinancialSnapshotEnvironmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST': 'TEST',
    'DEMO': 'DEMO',
    'LIVE': 'LIVE',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST': 'TEST',
    'DEMO': 'DEMO',
    'LIVE': 'LIVE',
  };

  @override
  final Iterable<Type> types = const <Type>[FinancialSnapshotEnvironmentEnum];
  @override
  final String wireName = 'FinancialSnapshotEnvironmentEnum';

  @override
  Object serialize(
          Serializers serializers, FinancialSnapshotEnvironmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  FinancialSnapshotEnvironmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      FinancialSnapshotEnvironmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$FinancialSnapshot extends FinancialSnapshot {
  @override
  final String id;
  @override
  final String orderId;
  @override
  final FinancialSnapshotEnvironmentEnum environment;
  @override
  final int materialsGrossCentavos;
  @override
  final int vendorDiscountCentavos;
  @override
  final int materialsVatCentavos;
  @override
  final int deliveryCentavos;
  @override
  final int processingFeeCentavos;
  @override
  final int nrpcCentavos;
  @override
  final int buyerTotalCentavos;
  @override
  final String calculationHash;

  factory _$FinancialSnapshot(
          [void Function(FinancialSnapshotBuilder)? updates]) =>
      (FinancialSnapshotBuilder()..update(updates))._build();

  _$FinancialSnapshot._(
      {required this.id,
      required this.orderId,
      required this.environment,
      required this.materialsGrossCentavos,
      required this.vendorDiscountCentavos,
      required this.materialsVatCentavos,
      required this.deliveryCentavos,
      required this.processingFeeCentavos,
      required this.nrpcCentavos,
      required this.buyerTotalCentavos,
      required this.calculationHash})
      : super._();
  @override
  FinancialSnapshot rebuild(void Function(FinancialSnapshotBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  FinancialSnapshotBuilder toBuilder() =>
      FinancialSnapshotBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is FinancialSnapshot &&
        id == other.id &&
        orderId == other.orderId &&
        environment == other.environment &&
        materialsGrossCentavos == other.materialsGrossCentavos &&
        vendorDiscountCentavos == other.vendorDiscountCentavos &&
        materialsVatCentavos == other.materialsVatCentavos &&
        deliveryCentavos == other.deliveryCentavos &&
        processingFeeCentavos == other.processingFeeCentavos &&
        nrpcCentavos == other.nrpcCentavos &&
        buyerTotalCentavos == other.buyerTotalCentavos &&
        calculationHash == other.calculationHash;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, orderId.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, materialsGrossCentavos.hashCode);
    _$hash = $jc(_$hash, vendorDiscountCentavos.hashCode);
    _$hash = $jc(_$hash, materialsVatCentavos.hashCode);
    _$hash = $jc(_$hash, deliveryCentavos.hashCode);
    _$hash = $jc(_$hash, processingFeeCentavos.hashCode);
    _$hash = $jc(_$hash, nrpcCentavos.hashCode);
    _$hash = $jc(_$hash, buyerTotalCentavos.hashCode);
    _$hash = $jc(_$hash, calculationHash.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'FinancialSnapshot')
          ..add('id', id)
          ..add('orderId', orderId)
          ..add('environment', environment)
          ..add('materialsGrossCentavos', materialsGrossCentavos)
          ..add('vendorDiscountCentavos', vendorDiscountCentavos)
          ..add('materialsVatCentavos', materialsVatCentavos)
          ..add('deliveryCentavos', deliveryCentavos)
          ..add('processingFeeCentavos', processingFeeCentavos)
          ..add('nrpcCentavos', nrpcCentavos)
          ..add('buyerTotalCentavos', buyerTotalCentavos)
          ..add('calculationHash', calculationHash))
        .toString();
  }
}

class FinancialSnapshotBuilder
    implements Builder<FinancialSnapshot, FinancialSnapshotBuilder> {
  _$FinancialSnapshot? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _orderId;
  String? get orderId => _$this._orderId;
  set orderId(String? orderId) => _$this._orderId = orderId;

  FinancialSnapshotEnvironmentEnum? _environment;
  FinancialSnapshotEnvironmentEnum? get environment => _$this._environment;
  set environment(FinancialSnapshotEnvironmentEnum? environment) =>
      _$this._environment = environment;

  int? _materialsGrossCentavos;
  int? get materialsGrossCentavos => _$this._materialsGrossCentavos;
  set materialsGrossCentavos(int? materialsGrossCentavos) =>
      _$this._materialsGrossCentavos = materialsGrossCentavos;

  int? _vendorDiscountCentavos;
  int? get vendorDiscountCentavos => _$this._vendorDiscountCentavos;
  set vendorDiscountCentavos(int? vendorDiscountCentavos) =>
      _$this._vendorDiscountCentavos = vendorDiscountCentavos;

  int? _materialsVatCentavos;
  int? get materialsVatCentavos => _$this._materialsVatCentavos;
  set materialsVatCentavos(int? materialsVatCentavos) =>
      _$this._materialsVatCentavos = materialsVatCentavos;

  int? _deliveryCentavos;
  int? get deliveryCentavos => _$this._deliveryCentavos;
  set deliveryCentavos(int? deliveryCentavos) =>
      _$this._deliveryCentavos = deliveryCentavos;

  int? _processingFeeCentavos;
  int? get processingFeeCentavos => _$this._processingFeeCentavos;
  set processingFeeCentavos(int? processingFeeCentavos) =>
      _$this._processingFeeCentavos = processingFeeCentavos;

  int? _nrpcCentavos;
  int? get nrpcCentavos => _$this._nrpcCentavos;
  set nrpcCentavos(int? nrpcCentavos) => _$this._nrpcCentavos = nrpcCentavos;

  int? _buyerTotalCentavos;
  int? get buyerTotalCentavos => _$this._buyerTotalCentavos;
  set buyerTotalCentavos(int? buyerTotalCentavos) =>
      _$this._buyerTotalCentavos = buyerTotalCentavos;

  String? _calculationHash;
  String? get calculationHash => _$this._calculationHash;
  set calculationHash(String? calculationHash) =>
      _$this._calculationHash = calculationHash;

  FinancialSnapshotBuilder() {
    FinancialSnapshot._defaults(this);
  }

  FinancialSnapshotBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _orderId = $v.orderId;
      _environment = $v.environment;
      _materialsGrossCentavos = $v.materialsGrossCentavos;
      _vendorDiscountCentavos = $v.vendorDiscountCentavos;
      _materialsVatCentavos = $v.materialsVatCentavos;
      _deliveryCentavos = $v.deliveryCentavos;
      _processingFeeCentavos = $v.processingFeeCentavos;
      _nrpcCentavos = $v.nrpcCentavos;
      _buyerTotalCentavos = $v.buyerTotalCentavos;
      _calculationHash = $v.calculationHash;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(FinancialSnapshot other) {
    _$v = other as _$FinancialSnapshot;
  }

  @override
  void update(void Function(FinancialSnapshotBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  FinancialSnapshot build() => _build();

  _$FinancialSnapshot _build() {
    final _$result = _$v ??
        _$FinancialSnapshot._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'FinancialSnapshot', 'id'),
          orderId: BuiltValueNullFieldError.checkNotNull(
              orderId, r'FinancialSnapshot', 'orderId'),
          environment: BuiltValueNullFieldError.checkNotNull(
              environment, r'FinancialSnapshot', 'environment'),
          materialsGrossCentavos: BuiltValueNullFieldError.checkNotNull(
              materialsGrossCentavos,
              r'FinancialSnapshot',
              'materialsGrossCentavos'),
          vendorDiscountCentavos: BuiltValueNullFieldError.checkNotNull(
              vendorDiscountCentavos,
              r'FinancialSnapshot',
              'vendorDiscountCentavos'),
          materialsVatCentavos: BuiltValueNullFieldError.checkNotNull(
              materialsVatCentavos,
              r'FinancialSnapshot',
              'materialsVatCentavos'),
          deliveryCentavos: BuiltValueNullFieldError.checkNotNull(
              deliveryCentavos, r'FinancialSnapshot', 'deliveryCentavos'),
          processingFeeCentavos: BuiltValueNullFieldError.checkNotNull(
              processingFeeCentavos,
              r'FinancialSnapshot',
              'processingFeeCentavos'),
          nrpcCentavos: BuiltValueNullFieldError.checkNotNull(
              nrpcCentavos, r'FinancialSnapshot', 'nrpcCentavos'),
          buyerTotalCentavos: BuiltValueNullFieldError.checkNotNull(
              buyerTotalCentavos, r'FinancialSnapshot', 'buyerTotalCentavos'),
          calculationHash: BuiltValueNullFieldError.checkNotNull(
              calculationHash, r'FinancialSnapshot', 'calculationHash'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'material_price_observation.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const MaterialPriceObservationEnvironmentEnum
    _$materialPriceObservationEnvironmentEnum_TEST =
    const MaterialPriceObservationEnvironmentEnum._('TEST');
const MaterialPriceObservationEnvironmentEnum
    _$materialPriceObservationEnvironmentEnum_DEMO =
    const MaterialPriceObservationEnvironmentEnum._('DEMO');

MaterialPriceObservationEnvironmentEnum
    _$materialPriceObservationEnvironmentEnumValueOf(String name) {
  switch (name) {
    case 'TEST':
      return _$materialPriceObservationEnvironmentEnum_TEST;
    case 'DEMO':
      return _$materialPriceObservationEnvironmentEnum_DEMO;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<MaterialPriceObservationEnvironmentEnum>
    _$materialPriceObservationEnvironmentEnumValues = BuiltSet<
        MaterialPriceObservationEnvironmentEnum>(const <MaterialPriceObservationEnvironmentEnum>[
  _$materialPriceObservationEnvironmentEnum_TEST,
  _$materialPriceObservationEnvironmentEnum_DEMO,
]);

Serializer<MaterialPriceObservationEnvironmentEnum>
    _$materialPriceObservationEnvironmentEnumSerializer =
    _$MaterialPriceObservationEnvironmentEnumSerializer();

class _$MaterialPriceObservationEnvironmentEnumSerializer
    implements PrimitiveSerializer<MaterialPriceObservationEnvironmentEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'TEST': 'TEST',
    'DEMO': 'DEMO',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'TEST': 'TEST',
    'DEMO': 'DEMO',
  };

  @override
  final Iterable<Type> types = const <Type>[
    MaterialPriceObservationEnvironmentEnum
  ];
  @override
  final String wireName = 'MaterialPriceObservationEnvironmentEnum';

  @override
  Object serialize(Serializers serializers,
          MaterialPriceObservationEnvironmentEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  MaterialPriceObservationEnvironmentEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      MaterialPriceObservationEnvironmentEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$MaterialPriceObservation extends MaterialPriceObservation {
  @override
  final String id;
  @override
  final String runId;
  @override
  final MaterialPriceObservationEnvironmentEnum environment;
  @override
  final String datasetId;
  @override
  final String vendorId;
  @override
  final String listingVariantId;
  @override
  final String comparableGroupVersionId;
  @override
  final DateTime observedAt;
  @override
  final Date localSnapshotDate;
  @override
  final int ordinaryPayableCentavos;
  @override
  final String normalizedPhpPrice;
  @override
  final String eligibilityVersion;

  factory _$MaterialPriceObservation(
          [void Function(MaterialPriceObservationBuilder)? updates]) =>
      (MaterialPriceObservationBuilder()..update(updates))._build();

  _$MaterialPriceObservation._(
      {required this.id,
      required this.runId,
      required this.environment,
      required this.datasetId,
      required this.vendorId,
      required this.listingVariantId,
      required this.comparableGroupVersionId,
      required this.observedAt,
      required this.localSnapshotDate,
      required this.ordinaryPayableCentavos,
      required this.normalizedPhpPrice,
      required this.eligibilityVersion})
      : super._();
  @override
  MaterialPriceObservation rebuild(
          void Function(MaterialPriceObservationBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  MaterialPriceObservationBuilder toBuilder() =>
      MaterialPriceObservationBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MaterialPriceObservation &&
        id == other.id &&
        runId == other.runId &&
        environment == other.environment &&
        datasetId == other.datasetId &&
        vendorId == other.vendorId &&
        listingVariantId == other.listingVariantId &&
        comparableGroupVersionId == other.comparableGroupVersionId &&
        observedAt == other.observedAt &&
        localSnapshotDate == other.localSnapshotDate &&
        ordinaryPayableCentavos == other.ordinaryPayableCentavos &&
        normalizedPhpPrice == other.normalizedPhpPrice &&
        eligibilityVersion == other.eligibilityVersion;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, runId.hashCode);
    _$hash = $jc(_$hash, environment.hashCode);
    _$hash = $jc(_$hash, datasetId.hashCode);
    _$hash = $jc(_$hash, vendorId.hashCode);
    _$hash = $jc(_$hash, listingVariantId.hashCode);
    _$hash = $jc(_$hash, comparableGroupVersionId.hashCode);
    _$hash = $jc(_$hash, observedAt.hashCode);
    _$hash = $jc(_$hash, localSnapshotDate.hashCode);
    _$hash = $jc(_$hash, ordinaryPayableCentavos.hashCode);
    _$hash = $jc(_$hash, normalizedPhpPrice.hashCode);
    _$hash = $jc(_$hash, eligibilityVersion.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'MaterialPriceObservation')
          ..add('id', id)
          ..add('runId', runId)
          ..add('environment', environment)
          ..add('datasetId', datasetId)
          ..add('vendorId', vendorId)
          ..add('listingVariantId', listingVariantId)
          ..add('comparableGroupVersionId', comparableGroupVersionId)
          ..add('observedAt', observedAt)
          ..add('localSnapshotDate', localSnapshotDate)
          ..add('ordinaryPayableCentavos', ordinaryPayableCentavos)
          ..add('normalizedPhpPrice', normalizedPhpPrice)
          ..add('eligibilityVersion', eligibilityVersion))
        .toString();
  }
}

class MaterialPriceObservationBuilder
    implements
        Builder<MaterialPriceObservation, MaterialPriceObservationBuilder> {
  _$MaterialPriceObservation? _$v;

  String? _id;
  String? get id => _$this._id;
  set id(String? id) => _$this._id = id;

  String? _runId;
  String? get runId => _$this._runId;
  set runId(String? runId) => _$this._runId = runId;

  MaterialPriceObservationEnvironmentEnum? _environment;
  MaterialPriceObservationEnvironmentEnum? get environment =>
      _$this._environment;
  set environment(MaterialPriceObservationEnvironmentEnum? environment) =>
      _$this._environment = environment;

  String? _datasetId;
  String? get datasetId => _$this._datasetId;
  set datasetId(String? datasetId) => _$this._datasetId = datasetId;

  String? _vendorId;
  String? get vendorId => _$this._vendorId;
  set vendorId(String? vendorId) => _$this._vendorId = vendorId;

  String? _listingVariantId;
  String? get listingVariantId => _$this._listingVariantId;
  set listingVariantId(String? listingVariantId) =>
      _$this._listingVariantId = listingVariantId;

  String? _comparableGroupVersionId;
  String? get comparableGroupVersionId => _$this._comparableGroupVersionId;
  set comparableGroupVersionId(String? comparableGroupVersionId) =>
      _$this._comparableGroupVersionId = comparableGroupVersionId;

  DateTime? _observedAt;
  DateTime? get observedAt => _$this._observedAt;
  set observedAt(DateTime? observedAt) => _$this._observedAt = observedAt;

  Date? _localSnapshotDate;
  Date? get localSnapshotDate => _$this._localSnapshotDate;
  set localSnapshotDate(Date? localSnapshotDate) =>
      _$this._localSnapshotDate = localSnapshotDate;

  int? _ordinaryPayableCentavos;
  int? get ordinaryPayableCentavos => _$this._ordinaryPayableCentavos;
  set ordinaryPayableCentavos(int? ordinaryPayableCentavos) =>
      _$this._ordinaryPayableCentavos = ordinaryPayableCentavos;

  String? _normalizedPhpPrice;
  String? get normalizedPhpPrice => _$this._normalizedPhpPrice;
  set normalizedPhpPrice(String? normalizedPhpPrice) =>
      _$this._normalizedPhpPrice = normalizedPhpPrice;

  String? _eligibilityVersion;
  String? get eligibilityVersion => _$this._eligibilityVersion;
  set eligibilityVersion(String? eligibilityVersion) =>
      _$this._eligibilityVersion = eligibilityVersion;

  MaterialPriceObservationBuilder() {
    MaterialPriceObservation._defaults(this);
  }

  MaterialPriceObservationBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _runId = $v.runId;
      _environment = $v.environment;
      _datasetId = $v.datasetId;
      _vendorId = $v.vendorId;
      _listingVariantId = $v.listingVariantId;
      _comparableGroupVersionId = $v.comparableGroupVersionId;
      _observedAt = $v.observedAt;
      _localSnapshotDate = $v.localSnapshotDate;
      _ordinaryPayableCentavos = $v.ordinaryPayableCentavos;
      _normalizedPhpPrice = $v.normalizedPhpPrice;
      _eligibilityVersion = $v.eligibilityVersion;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(MaterialPriceObservation other) {
    _$v = other as _$MaterialPriceObservation;
  }

  @override
  void update(void Function(MaterialPriceObservationBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  MaterialPriceObservation build() => _build();

  _$MaterialPriceObservation _build() {
    final _$result = _$v ??
        _$MaterialPriceObservation._(
          id: BuiltValueNullFieldError.checkNotNull(
              id, r'MaterialPriceObservation', 'id'),
          runId: BuiltValueNullFieldError.checkNotNull(
              runId, r'MaterialPriceObservation', 'runId'),
          environment: BuiltValueNullFieldError.checkNotNull(
              environment, r'MaterialPriceObservation', 'environment'),
          datasetId: BuiltValueNullFieldError.checkNotNull(
              datasetId, r'MaterialPriceObservation', 'datasetId'),
          vendorId: BuiltValueNullFieldError.checkNotNull(
              vendorId, r'MaterialPriceObservation', 'vendorId'),
          listingVariantId: BuiltValueNullFieldError.checkNotNull(
              listingVariantId,
              r'MaterialPriceObservation',
              'listingVariantId'),
          comparableGroupVersionId: BuiltValueNullFieldError.checkNotNull(
              comparableGroupVersionId,
              r'MaterialPriceObservation',
              'comparableGroupVersionId'),
          observedAt: BuiltValueNullFieldError.checkNotNull(
              observedAt, r'MaterialPriceObservation', 'observedAt'),
          localSnapshotDate: BuiltValueNullFieldError.checkNotNull(
              localSnapshotDate,
              r'MaterialPriceObservation',
              'localSnapshotDate'),
          ordinaryPayableCentavos: BuiltValueNullFieldError.checkNotNull(
              ordinaryPayableCentavos,
              r'MaterialPriceObservation',
              'ordinaryPayableCentavos'),
          normalizedPhpPrice: BuiltValueNullFieldError.checkNotNull(
              normalizedPhpPrice,
              r'MaterialPriceObservation',
              'normalizedPhpPrice'),
          eligibilityVersion: BuiltValueNullFieldError.checkNotNull(
              eligibilityVersion,
              r'MaterialPriceObservation',
              'eligibilityVersion'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_envelope_all_of_data.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

const HealthEnvelopeAllOfDataStatusEnum _$healthEnvelopeAllOfDataStatusEnum_ok =
    const HealthEnvelopeAllOfDataStatusEnum._('ok');

HealthEnvelopeAllOfDataStatusEnum _$healthEnvelopeAllOfDataStatusEnumValueOf(
    String name) {
  switch (name) {
    case 'ok':
      return _$healthEnvelopeAllOfDataStatusEnum_ok;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<HealthEnvelopeAllOfDataStatusEnum>
    _$healthEnvelopeAllOfDataStatusEnumValues = BuiltSet<
        HealthEnvelopeAllOfDataStatusEnum>(const <HealthEnvelopeAllOfDataStatusEnum>[
  _$healthEnvelopeAllOfDataStatusEnum_ok,
]);

const HealthEnvelopeAllOfDataServiceEnum
    _$healthEnvelopeAllOfDataServiceEnum_materyalphApi =
    const HealthEnvelopeAllOfDataServiceEnum._('materyalphApi');

HealthEnvelopeAllOfDataServiceEnum _$healthEnvelopeAllOfDataServiceEnumValueOf(
    String name) {
  switch (name) {
    case 'materyalphApi':
      return _$healthEnvelopeAllOfDataServiceEnum_materyalphApi;
    default:
      throw ArgumentError(name);
  }
}

final BuiltSet<HealthEnvelopeAllOfDataServiceEnum>
    _$healthEnvelopeAllOfDataServiceEnumValues = BuiltSet<
        HealthEnvelopeAllOfDataServiceEnum>(const <HealthEnvelopeAllOfDataServiceEnum>[
  _$healthEnvelopeAllOfDataServiceEnum_materyalphApi,
]);

Serializer<HealthEnvelopeAllOfDataStatusEnum>
    _$healthEnvelopeAllOfDataStatusEnumSerializer =
    _$HealthEnvelopeAllOfDataStatusEnumSerializer();
Serializer<HealthEnvelopeAllOfDataServiceEnum>
    _$healthEnvelopeAllOfDataServiceEnumSerializer =
    _$HealthEnvelopeAllOfDataServiceEnumSerializer();

class _$HealthEnvelopeAllOfDataStatusEnumSerializer
    implements PrimitiveSerializer<HealthEnvelopeAllOfDataStatusEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'ok': 'ok',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'ok': 'ok',
  };

  @override
  final Iterable<Type> types = const <Type>[HealthEnvelopeAllOfDataStatusEnum];
  @override
  final String wireName = 'HealthEnvelopeAllOfDataStatusEnum';

  @override
  Object serialize(
          Serializers serializers, HealthEnvelopeAllOfDataStatusEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  HealthEnvelopeAllOfDataStatusEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      HealthEnvelopeAllOfDataStatusEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$HealthEnvelopeAllOfDataServiceEnumSerializer
    implements PrimitiveSerializer<HealthEnvelopeAllOfDataServiceEnum> {
  static const Map<String, Object> _toWire = const <String, Object>{
    'materyalphApi': 'materyalph-api',
  };
  static const Map<Object, String> _fromWire = const <Object, String>{
    'materyalph-api': 'materyalphApi',
  };

  @override
  final Iterable<Type> types = const <Type>[HealthEnvelopeAllOfDataServiceEnum];
  @override
  final String wireName = 'HealthEnvelopeAllOfDataServiceEnum';

  @override
  Object serialize(
          Serializers serializers, HealthEnvelopeAllOfDataServiceEnum object,
          {FullType specifiedType = FullType.unspecified}) =>
      _toWire[object.name] ?? object.name;

  @override
  HealthEnvelopeAllOfDataServiceEnum deserialize(
          Serializers serializers, Object serialized,
          {FullType specifiedType = FullType.unspecified}) =>
      HealthEnvelopeAllOfDataServiceEnum.valueOf(
          _fromWire[serialized] ?? (serialized is String ? serialized : ''));
}

class _$HealthEnvelopeAllOfData extends HealthEnvelopeAllOfData {
  @override
  final HealthEnvelopeAllOfDataStatusEnum status;
  @override
  final HealthEnvelopeAllOfDataServiceEnum service;
  @override
  final DateTime timestamp;

  factory _$HealthEnvelopeAllOfData(
          [void Function(HealthEnvelopeAllOfDataBuilder)? updates]) =>
      (HealthEnvelopeAllOfDataBuilder()..update(updates))._build();

  _$HealthEnvelopeAllOfData._(
      {required this.status, required this.service, required this.timestamp})
      : super._();
  @override
  HealthEnvelopeAllOfData rebuild(
          void Function(HealthEnvelopeAllOfDataBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  HealthEnvelopeAllOfDataBuilder toBuilder() =>
      HealthEnvelopeAllOfDataBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is HealthEnvelopeAllOfData &&
        status == other.status &&
        service == other.service &&
        timestamp == other.timestamp;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, status.hashCode);
    _$hash = $jc(_$hash, service.hashCode);
    _$hash = $jc(_$hash, timestamp.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'HealthEnvelopeAllOfData')
          ..add('status', status)
          ..add('service', service)
          ..add('timestamp', timestamp))
        .toString();
  }
}

class HealthEnvelopeAllOfDataBuilder
    implements
        Builder<HealthEnvelopeAllOfData, HealthEnvelopeAllOfDataBuilder> {
  _$HealthEnvelopeAllOfData? _$v;

  HealthEnvelopeAllOfDataStatusEnum? _status;
  HealthEnvelopeAllOfDataStatusEnum? get status => _$this._status;
  set status(HealthEnvelopeAllOfDataStatusEnum? status) =>
      _$this._status = status;

  HealthEnvelopeAllOfDataServiceEnum? _service;
  HealthEnvelopeAllOfDataServiceEnum? get service => _$this._service;
  set service(HealthEnvelopeAllOfDataServiceEnum? service) =>
      _$this._service = service;

  DateTime? _timestamp;
  DateTime? get timestamp => _$this._timestamp;
  set timestamp(DateTime? timestamp) => _$this._timestamp = timestamp;

  HealthEnvelopeAllOfDataBuilder() {
    HealthEnvelopeAllOfData._defaults(this);
  }

  HealthEnvelopeAllOfDataBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _status = $v.status;
      _service = $v.service;
      _timestamp = $v.timestamp;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(HealthEnvelopeAllOfData other) {
    _$v = other as _$HealthEnvelopeAllOfData;
  }

  @override
  void update(void Function(HealthEnvelopeAllOfDataBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  HealthEnvelopeAllOfData build() => _build();

  _$HealthEnvelopeAllOfData _build() {
    final _$result = _$v ??
        _$HealthEnvelopeAllOfData._(
          status: BuiltValueNullFieldError.checkNotNull(
              status, r'HealthEnvelopeAllOfData', 'status'),
          service: BuiltValueNullFieldError.checkNotNull(
              service, r'HealthEnvelopeAllOfData', 'service'),
          timestamp: BuiltValueNullFieldError.checkNotNull(
              timestamp, r'HealthEnvelopeAllOfData', 'timestamp'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint

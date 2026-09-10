//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'health_envelope_all_of_data.g.dart';

/// HealthEnvelopeAllOfData
///
/// Properties:
/// * [status] 
/// * [service] 
/// * [timestamp] 
@BuiltValue()
abstract class HealthEnvelopeAllOfData implements Built<HealthEnvelopeAllOfData, HealthEnvelopeAllOfDataBuilder> {
  @BuiltValueField(wireName: r'status')
  HealthEnvelopeAllOfDataStatusEnum get status;
  // enum statusEnum {  ok,  };

  @BuiltValueField(wireName: r'service')
  HealthEnvelopeAllOfDataServiceEnum get service;
  // enum serviceEnum {  materyalph-api,  };

  @BuiltValueField(wireName: r'timestamp')
  DateTime get timestamp;

  HealthEnvelopeAllOfData._();

  factory HealthEnvelopeAllOfData([void updates(HealthEnvelopeAllOfDataBuilder b)]) = _$HealthEnvelopeAllOfData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(HealthEnvelopeAllOfDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<HealthEnvelopeAllOfData> get serializer => _$HealthEnvelopeAllOfDataSerializer();
}

class _$HealthEnvelopeAllOfDataSerializer implements PrimitiveSerializer<HealthEnvelopeAllOfData> {
  @override
  final Iterable<Type> types = const [HealthEnvelopeAllOfData, _$HealthEnvelopeAllOfData];

  @override
  final String wireName = r'HealthEnvelopeAllOfData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    HealthEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'status';
    yield serializers.serialize(
      object.status,
      specifiedType: const FullType(HealthEnvelopeAllOfDataStatusEnum),
    );
    yield r'service';
    yield serializers.serialize(
      object.service,
      specifiedType: const FullType(HealthEnvelopeAllOfDataServiceEnum),
    );
    yield r'timestamp';
    yield serializers.serialize(
      object.timestamp,
      specifiedType: const FullType(DateTime),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    HealthEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required HealthEnvelopeAllOfDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'status':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(HealthEnvelopeAllOfDataStatusEnum),
          ) as HealthEnvelopeAllOfDataStatusEnum;
          result.status = valueDes;
          break;
        case r'service':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(HealthEnvelopeAllOfDataServiceEnum),
          ) as HealthEnvelopeAllOfDataServiceEnum;
          result.service = valueDes;
          break;
        case r'timestamp':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.timestamp = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  HealthEnvelopeAllOfData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = HealthEnvelopeAllOfDataBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}


class HealthEnvelopeAllOfDataStatusEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'ok')
  static const HealthEnvelopeAllOfDataStatusEnum ok = _$healthEnvelopeAllOfDataStatusEnum_ok;

  static Serializer<HealthEnvelopeAllOfDataStatusEnum> get serializer => _$healthEnvelopeAllOfDataStatusEnumSerializer;

  const HealthEnvelopeAllOfDataStatusEnum._(String name): super(name);

  static BuiltSet<HealthEnvelopeAllOfDataStatusEnum> get values => _$healthEnvelopeAllOfDataStatusEnumValues;
  static HealthEnvelopeAllOfDataStatusEnum valueOf(String name) => _$healthEnvelopeAllOfDataStatusEnumValueOf(name);
}

class HealthEnvelopeAllOfDataServiceEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'materyalph-api')
  static const HealthEnvelopeAllOfDataServiceEnum materyalphApi = _$healthEnvelopeAllOfDataServiceEnum_materyalphApi;

  static Serializer<HealthEnvelopeAllOfDataServiceEnum> get serializer => _$healthEnvelopeAllOfDataServiceEnumSerializer;

  const HealthEnvelopeAllOfDataServiceEnum._(String name): super(name);

  static BuiltSet<HealthEnvelopeAllOfDataServiceEnum> get values => _$healthEnvelopeAllOfDataServiceEnumValues;
  static HealthEnvelopeAllOfDataServiceEnum valueOf(String name) => _$healthEnvelopeAllOfDataServiceEnumValueOf(name);
}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/date.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'material_price_observation.g.dart';

/// Public Tier 2 ordinary listing observation; never transaction-price evidence.
///
/// Properties:
/// * [id] 
/// * [runId] 
/// * [environment] 
/// * [datasetId] 
/// * [vendorId] 
/// * [listingVariantId] 
/// * [comparableGroupVersionId] 
/// * [observedAt] 
/// * [localSnapshotDate] 
/// * [ordinaryPayableCentavos] 
/// * [normalizedPhpPrice] 
/// * [eligibilityVersion] 
@BuiltValue()
abstract class MaterialPriceObservation implements Built<MaterialPriceObservation, MaterialPriceObservationBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'run_id')
  String get runId;

  @BuiltValueField(wireName: r'environment')
  MaterialPriceObservationEnvironmentEnum get environment;
  // enum environmentEnum {  TEST,  DEMO,  };

  @BuiltValueField(wireName: r'dataset_id')
  String get datasetId;

  @BuiltValueField(wireName: r'vendor_id')
  String get vendorId;

  @BuiltValueField(wireName: r'listing_variant_id')
  String get listingVariantId;

  @BuiltValueField(wireName: r'comparable_group_version_id')
  String get comparableGroupVersionId;

  @BuiltValueField(wireName: r'observed_at')
  DateTime get observedAt;

  @BuiltValueField(wireName: r'local_snapshot_date')
  Date get localSnapshotDate;

  @BuiltValueField(wireName: r'ordinary_payable_centavos')
  int get ordinaryPayableCentavos;

  @BuiltValueField(wireName: r'normalized_php_price')
  String get normalizedPhpPrice;

  @BuiltValueField(wireName: r'eligibility_version')
  String get eligibilityVersion;

  MaterialPriceObservation._();

  factory MaterialPriceObservation([void updates(MaterialPriceObservationBuilder b)]) = _$MaterialPriceObservation;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MaterialPriceObservationBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MaterialPriceObservation> get serializer => _$MaterialPriceObservationSerializer();
}

class _$MaterialPriceObservationSerializer implements PrimitiveSerializer<MaterialPriceObservation> {
  @override
  final Iterable<Type> types = const [MaterialPriceObservation, _$MaterialPriceObservation];

  @override
  final String wireName = r'MaterialPriceObservation';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MaterialPriceObservation object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'run_id';
    yield serializers.serialize(
      object.runId,
      specifiedType: const FullType(String),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(MaterialPriceObservationEnvironmentEnum),
    );
    yield r'dataset_id';
    yield serializers.serialize(
      object.datasetId,
      specifiedType: const FullType(String),
    );
    yield r'vendor_id';
    yield serializers.serialize(
      object.vendorId,
      specifiedType: const FullType(String),
    );
    yield r'listing_variant_id';
    yield serializers.serialize(
      object.listingVariantId,
      specifiedType: const FullType(String),
    );
    yield r'comparable_group_version_id';
    yield serializers.serialize(
      object.comparableGroupVersionId,
      specifiedType: const FullType(String),
    );
    yield r'observed_at';
    yield serializers.serialize(
      object.observedAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'local_snapshot_date';
    yield serializers.serialize(
      object.localSnapshotDate,
      specifiedType: const FullType(Date),
    );
    yield r'ordinary_payable_centavos';
    yield serializers.serialize(
      object.ordinaryPayableCentavos,
      specifiedType: const FullType(int),
    );
    yield r'normalized_php_price';
    yield serializers.serialize(
      object.normalizedPhpPrice,
      specifiedType: const FullType(String),
    );
    yield r'eligibility_version';
    yield serializers.serialize(
      object.eligibilityVersion,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MaterialPriceObservation object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MaterialPriceObservationBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'run_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.runId = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MaterialPriceObservationEnvironmentEnum),
          ) as MaterialPriceObservationEnvironmentEnum;
          result.environment = valueDes;
          break;
        case r'dataset_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.datasetId = valueDes;
          break;
        case r'vendor_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.vendorId = valueDes;
          break;
        case r'listing_variant_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.listingVariantId = valueDes;
          break;
        case r'comparable_group_version_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.comparableGroupVersionId = valueDes;
          break;
        case r'observed_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.observedAt = valueDes;
          break;
        case r'local_snapshot_date':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(Date),
          ) as Date;
          result.localSnapshotDate = valueDes;
          break;
        case r'ordinary_payable_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.ordinaryPayableCentavos = valueDes;
          break;
        case r'normalized_php_price':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.normalizedPhpPrice = valueDes;
          break;
        case r'eligibility_version':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.eligibilityVersion = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MaterialPriceObservation deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MaterialPriceObservationBuilder();
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


class MaterialPriceObservationEnvironmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const MaterialPriceObservationEnvironmentEnum TEST = _$materialPriceObservationEnvironmentEnum_TEST;
  @BuiltValueEnumConst(wireName: r'DEMO')
  static const MaterialPriceObservationEnvironmentEnum DEMO = _$materialPriceObservationEnvironmentEnum_DEMO;

  static Serializer<MaterialPriceObservationEnvironmentEnum> get serializer => _$materialPriceObservationEnvironmentEnumSerializer;

  const MaterialPriceObservationEnvironmentEnum._(String name): super(name);

  static BuiltSet<MaterialPriceObservationEnvironmentEnum> get values => _$materialPriceObservationEnvironmentEnumValues;
  static MaterialPriceObservationEnvironmentEnum valueOf(String name) => _$materialPriceObservationEnvironmentEnumValueOf(name);
}


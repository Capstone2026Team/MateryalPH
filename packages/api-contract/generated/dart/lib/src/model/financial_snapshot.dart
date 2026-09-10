//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'financial_snapshot.g.dart';

/// Immutable FIN money snapshot; every amount is integer centavos.
///
/// Properties:
/// * [id] 
/// * [orderId] 
/// * [environment] 
/// * [materialsGrossCentavos] 
/// * [vendorDiscountCentavos] 
/// * [materialsVatCentavos] 
/// * [deliveryCentavos] 
/// * [processingFeeCentavos] 
/// * [nrpcCentavos] 
/// * [buyerTotalCentavos] 
/// * [calculationHash] 
@BuiltValue()
abstract class FinancialSnapshot implements Built<FinancialSnapshot, FinancialSnapshotBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'order_id')
  String get orderId;

  @BuiltValueField(wireName: r'environment')
  FinancialSnapshotEnvironmentEnum get environment;
  // enum environmentEnum {  TEST,  DEMO,  LIVE,  };

  @BuiltValueField(wireName: r'materials_gross_centavos')
  int get materialsGrossCentavos;

  @BuiltValueField(wireName: r'vendor_discount_centavos')
  int get vendorDiscountCentavos;

  @BuiltValueField(wireName: r'materials_vat_centavos')
  int get materialsVatCentavos;

  @BuiltValueField(wireName: r'delivery_centavos')
  int get deliveryCentavos;

  @BuiltValueField(wireName: r'processing_fee_centavos')
  int get processingFeeCentavos;

  @BuiltValueField(wireName: r'nrpc_centavos')
  int get nrpcCentavos;

  @BuiltValueField(wireName: r'buyer_total_centavos')
  int get buyerTotalCentavos;

  @BuiltValueField(wireName: r'calculation_hash')
  String get calculationHash;

  FinancialSnapshot._();

  factory FinancialSnapshot([void updates(FinancialSnapshotBuilder b)]) = _$FinancialSnapshot;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FinancialSnapshotBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FinancialSnapshot> get serializer => _$FinancialSnapshotSerializer();
}

class _$FinancialSnapshotSerializer implements PrimitiveSerializer<FinancialSnapshot> {
  @override
  final Iterable<Type> types = const [FinancialSnapshot, _$FinancialSnapshot];

  @override
  final String wireName = r'FinancialSnapshot';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FinancialSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'order_id';
    yield serializers.serialize(
      object.orderId,
      specifiedType: const FullType(String),
    );
    yield r'environment';
    yield serializers.serialize(
      object.environment,
      specifiedType: const FullType(FinancialSnapshotEnvironmentEnum),
    );
    yield r'materials_gross_centavos';
    yield serializers.serialize(
      object.materialsGrossCentavos,
      specifiedType: const FullType(int),
    );
    yield r'vendor_discount_centavos';
    yield serializers.serialize(
      object.vendorDiscountCentavos,
      specifiedType: const FullType(int),
    );
    yield r'materials_vat_centavos';
    yield serializers.serialize(
      object.materialsVatCentavos,
      specifiedType: const FullType(int),
    );
    yield r'delivery_centavos';
    yield serializers.serialize(
      object.deliveryCentavos,
      specifiedType: const FullType(int),
    );
    yield r'processing_fee_centavos';
    yield serializers.serialize(
      object.processingFeeCentavos,
      specifiedType: const FullType(int),
    );
    yield r'nrpc_centavos';
    yield serializers.serialize(
      object.nrpcCentavos,
      specifiedType: const FullType(int),
    );
    yield r'buyer_total_centavos';
    yield serializers.serialize(
      object.buyerTotalCentavos,
      specifiedType: const FullType(int),
    );
    yield r'calculation_hash';
    yield serializers.serialize(
      object.calculationHash,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FinancialSnapshot object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FinancialSnapshotBuilder result,
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
        case r'order_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.orderId = valueDes;
          break;
        case r'environment':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FinancialSnapshotEnvironmentEnum),
          ) as FinancialSnapshotEnvironmentEnum;
          result.environment = valueDes;
          break;
        case r'materials_gross_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsGrossCentavos = valueDes;
          break;
        case r'vendor_discount_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.vendorDiscountCentavos = valueDes;
          break;
        case r'materials_vat_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.materialsVatCentavos = valueDes;
          break;
        case r'delivery_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.deliveryCentavos = valueDes;
          break;
        case r'processing_fee_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.processingFeeCentavos = valueDes;
          break;
        case r'nrpc_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.nrpcCentavos = valueDes;
          break;
        case r'buyer_total_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.buyerTotalCentavos = valueDes;
          break;
        case r'calculation_hash':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.calculationHash = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FinancialSnapshot deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FinancialSnapshotBuilder();
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


class FinancialSnapshotEnvironmentEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'TEST')
  static const FinancialSnapshotEnvironmentEnum TEST = _$financialSnapshotEnvironmentEnum_TEST;
  @BuiltValueEnumConst(wireName: r'DEMO')
  static const FinancialSnapshotEnvironmentEnum DEMO = _$financialSnapshotEnvironmentEnum_DEMO;
  @BuiltValueEnumConst(wireName: r'LIVE')
  static const FinancialSnapshotEnvironmentEnum LIVE = _$financialSnapshotEnvironmentEnum_LIVE;

  static Serializer<FinancialSnapshotEnvironmentEnum> get serializer => _$financialSnapshotEnvironmentEnumSerializer;

  const FinancialSnapshotEnvironmentEnum._(String name): super(name);

  static BuiltSet<FinancialSnapshotEnvironmentEnum> get values => _$financialSnapshotEnvironmentEnumValues;
  static FinancialSnapshotEnvironmentEnum valueOf(String name) => _$financialSnapshotEnvironmentEnumValueOf(name);
}


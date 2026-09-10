//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'fee_assessment.g.dart';

/// Vendor commission liability, separate from buyer processing fees and monthly settlement.
///
/// Properties:
/// * [id] 
/// * [orderId] 
/// * [commissionBasisCentavos] 
/// * [commissionBasisPoints] 
/// * [earnedCentavos] 
/// * [state] 
@BuiltValue()
abstract class FeeAssessment implements Built<FeeAssessment, FeeAssessmentBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'order_id')
  String get orderId;

  @BuiltValueField(wireName: r'commission_basis_centavos')
  int get commissionBasisCentavos;

  @BuiltValueField(wireName: r'commission_basis_points')
  FeeAssessmentCommissionBasisPointsEnum get commissionBasisPoints;
  // enum commissionBasisPointsEnum {  200,  };

  @BuiltValueField(wireName: r'earned_centavos')
  int get earnedCentavos;

  @BuiltValueField(wireName: r'state')
  String get state;

  FeeAssessment._();

  factory FeeAssessment([void updates(FeeAssessmentBuilder b)]) = _$FeeAssessment;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(FeeAssessmentBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<FeeAssessment> get serializer => _$FeeAssessmentSerializer();
}

class _$FeeAssessmentSerializer implements PrimitiveSerializer<FeeAssessment> {
  @override
  final Iterable<Type> types = const [FeeAssessment, _$FeeAssessment];

  @override
  final String wireName = r'FeeAssessment';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    FeeAssessment object, {
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
    yield r'commission_basis_centavos';
    yield serializers.serialize(
      object.commissionBasisCentavos,
      specifiedType: const FullType(int),
    );
    yield r'commission_basis_points';
    yield serializers.serialize(
      object.commissionBasisPoints,
      specifiedType: const FullType(FeeAssessmentCommissionBasisPointsEnum),
    );
    yield r'earned_centavos';
    yield serializers.serialize(
      object.earnedCentavos,
      specifiedType: const FullType(int),
    );
    yield r'state';
    yield serializers.serialize(
      object.state,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    FeeAssessment object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required FeeAssessmentBuilder result,
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
        case r'commission_basis_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.commissionBasisCentavos = valueDes;
          break;
        case r'commission_basis_points':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(FeeAssessmentCommissionBasisPointsEnum),
          ) as FeeAssessmentCommissionBasisPointsEnum;
          result.commissionBasisPoints = valueDes;
          break;
        case r'earned_centavos':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.earnedCentavos = valueDes;
          break;
        case r'state':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.state = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  FeeAssessment deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = FeeAssessmentBuilder();
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


class FeeAssessmentCommissionBasisPointsEnum extends EnumClass {

  @BuiltValueEnumConst(wireNumber: 200)
  static const FeeAssessmentCommissionBasisPointsEnum number200 = _$feeAssessmentCommissionBasisPointsEnum_number200;

  static Serializer<FeeAssessmentCommissionBasisPointsEnum> get serializer => _$feeAssessmentCommissionBasisPointsEnumSerializer;

  const FeeAssessmentCommissionBasisPointsEnum._(String name): super(name);

  static BuiltSet<FeeAssessmentCommissionBasisPointsEnum> get values => _$feeAssessmentCommissionBasisPointsEnumValues;
  static FeeAssessmentCommissionBasisPointsEnum valueOf(String name) => _$feeAssessmentCommissionBasisPointsEnumValueOf(name);
}


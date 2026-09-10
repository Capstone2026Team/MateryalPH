//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_status_envelope_all_of_data.g.dart';

/// MfaStatusEnvelopeAllOfData
///
/// Properties:
/// * [mfaRequired] 
/// * [mfaEnrollmentRequired] 
@BuiltValue()
abstract class MfaStatusEnvelopeAllOfData implements Built<MfaStatusEnvelopeAllOfData, MfaStatusEnvelopeAllOfDataBuilder> {
  @BuiltValueField(wireName: r'mfa_required')
  MfaStatusEnvelopeAllOfDataMfaRequiredEnum get mfaRequired;
  // enum mfaRequiredEnum {  true,  };

  @BuiltValueField(wireName: r'mfa_enrollment_required')
  bool get mfaEnrollmentRequired;

  MfaStatusEnvelopeAllOfData._();

  factory MfaStatusEnvelopeAllOfData([void updates(MfaStatusEnvelopeAllOfDataBuilder b)]) = _$MfaStatusEnvelopeAllOfData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaStatusEnvelopeAllOfDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaStatusEnvelopeAllOfData> get serializer => _$MfaStatusEnvelopeAllOfDataSerializer();
}

class _$MfaStatusEnvelopeAllOfDataSerializer implements PrimitiveSerializer<MfaStatusEnvelopeAllOfData> {
  @override
  final Iterable<Type> types = const [MfaStatusEnvelopeAllOfData, _$MfaStatusEnvelopeAllOfData];

  @override
  final String wireName = r'MfaStatusEnvelopeAllOfData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaStatusEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'mfa_required';
    yield serializers.serialize(
      object.mfaRequired,
      specifiedType: const FullType(MfaStatusEnvelopeAllOfDataMfaRequiredEnum),
    );
    yield r'mfa_enrollment_required';
    yield serializers.serialize(
      object.mfaEnrollmentRequired,
      specifiedType: const FullType(bool),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaStatusEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaStatusEnvelopeAllOfDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mfa_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(MfaStatusEnvelopeAllOfDataMfaRequiredEnum),
          ) as MfaStatusEnvelopeAllOfDataMfaRequiredEnum;
          result.mfaRequired = valueDes;
          break;
        case r'mfa_enrollment_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.mfaEnrollmentRequired = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaStatusEnvelopeAllOfData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaStatusEnvelopeAllOfDataBuilder();
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


class MfaStatusEnvelopeAllOfDataMfaRequiredEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const MfaStatusEnvelopeAllOfDataMfaRequiredEnum true_ = _$mfaStatusEnvelopeAllOfDataMfaRequiredEnum_true_;

  static Serializer<MfaStatusEnvelopeAllOfDataMfaRequiredEnum> get serializer => _$mfaStatusEnvelopeAllOfDataMfaRequiredEnumSerializer;

  const MfaStatusEnvelopeAllOfDataMfaRequiredEnum._(String name): super(name);

  static BuiltSet<MfaStatusEnvelopeAllOfDataMfaRequiredEnum> get values => _$mfaStatusEnvelopeAllOfDataMfaRequiredEnumValues;
  static MfaStatusEnvelopeAllOfDataMfaRequiredEnum valueOf(String name) => _$mfaStatusEnvelopeAllOfDataMfaRequiredEnumValueOf(name);
}


//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_enrollment_envelope_all_of_data.g.dart';

/// MfaEnrollmentEnvelopeAllOfData
///
/// Properties:
/// * [secret] 
/// * [provisioningUri] 
@BuiltValue()
abstract class MfaEnrollmentEnvelopeAllOfData implements Built<MfaEnrollmentEnvelopeAllOfData, MfaEnrollmentEnvelopeAllOfDataBuilder> {
  @BuiltValueField(wireName: r'secret')
  String get secret;

  @BuiltValueField(wireName: r'provisioning_uri')
  String get provisioningUri;

  MfaEnrollmentEnvelopeAllOfData._();

  factory MfaEnrollmentEnvelopeAllOfData([void updates(MfaEnrollmentEnvelopeAllOfDataBuilder b)]) = _$MfaEnrollmentEnvelopeAllOfData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaEnrollmentEnvelopeAllOfDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaEnrollmentEnvelopeAllOfData> get serializer => _$MfaEnrollmentEnvelopeAllOfDataSerializer();
}

class _$MfaEnrollmentEnvelopeAllOfDataSerializer implements PrimitiveSerializer<MfaEnrollmentEnvelopeAllOfData> {
  @override
  final Iterable<Type> types = const [MfaEnrollmentEnvelopeAllOfData, _$MfaEnrollmentEnvelopeAllOfData];

  @override
  final String wireName = r'MfaEnrollmentEnvelopeAllOfData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaEnrollmentEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'secret';
    yield serializers.serialize(
      object.secret,
      specifiedType: const FullType(String),
    );
    yield r'provisioning_uri';
    yield serializers.serialize(
      object.provisioningUri,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaEnrollmentEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaEnrollmentEnvelopeAllOfDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'secret':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.secret = valueDes;
          break;
        case r'provisioning_uri':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.provisioningUri = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaEnrollmentEnvelopeAllOfData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaEnrollmentEnvelopeAllOfDataBuilder();
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



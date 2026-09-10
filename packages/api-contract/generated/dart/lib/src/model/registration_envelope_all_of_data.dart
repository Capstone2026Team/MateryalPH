//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'registration_envelope_all_of_data.g.dart';

/// RegistrationEnvelopeAllOfData
///
/// Properties:
/// * [userId] 
/// * [verificationRequired] 
/// * [next] 
@BuiltValue()
abstract class RegistrationEnvelopeAllOfData implements Built<RegistrationEnvelopeAllOfData, RegistrationEnvelopeAllOfDataBuilder> {
  @BuiltValueField(wireName: r'user_id')
  String? get userId;

  @BuiltValueField(wireName: r'verification_required')
  bool? get verificationRequired;

  @BuiltValueField(wireName: r'next')
  String? get next;

  RegistrationEnvelopeAllOfData._();

  factory RegistrationEnvelopeAllOfData([void updates(RegistrationEnvelopeAllOfDataBuilder b)]) = _$RegistrationEnvelopeAllOfData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegistrationEnvelopeAllOfDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegistrationEnvelopeAllOfData> get serializer => _$RegistrationEnvelopeAllOfDataSerializer();
}

class _$RegistrationEnvelopeAllOfDataSerializer implements PrimitiveSerializer<RegistrationEnvelopeAllOfData> {
  @override
  final Iterable<Type> types = const [RegistrationEnvelopeAllOfData, _$RegistrationEnvelopeAllOfData];

  @override
  final String wireName = r'RegistrationEnvelopeAllOfData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegistrationEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.userId != null) {
      yield r'user_id';
      yield serializers.serialize(
        object.userId,
        specifiedType: const FullType(String),
      );
    }
    if (object.verificationRequired != null) {
      yield r'verification_required';
      yield serializers.serialize(
        object.verificationRequired,
        specifiedType: const FullType(bool),
      );
    }
    if (object.next != null) {
      yield r'next';
      yield serializers.serialize(
        object.next,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RegistrationEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegistrationEnvelopeAllOfDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.userId = valueDes;
          break;
        case r'verification_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.verificationRequired = valueDes;
          break;
        case r'next':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.next = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegistrationEnvelopeAllOfData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegistrationEnvelopeAllOfDataBuilder();
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



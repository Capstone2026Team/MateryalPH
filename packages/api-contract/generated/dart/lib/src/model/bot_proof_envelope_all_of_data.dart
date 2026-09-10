//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bot_proof_envelope_all_of_data.g.dart';

/// BotProofEnvelopeAllOfData
///
/// Properties:
/// * [verified] 
/// * [expiresIn] 
/// * [stepUpToken] 
@BuiltValue()
abstract class BotProofEnvelopeAllOfData implements Built<BotProofEnvelopeAllOfData, BotProofEnvelopeAllOfDataBuilder> {
  @BuiltValueField(wireName: r'verified')
  BotProofEnvelopeAllOfDataVerifiedEnum get verified;
  // enum verifiedEnum {  true,  };

  @BuiltValueField(wireName: r'expires_in')
  int get expiresIn;

  @BuiltValueField(wireName: r'step_up_token')
  String? get stepUpToken;

  BotProofEnvelopeAllOfData._();

  factory BotProofEnvelopeAllOfData([void updates(BotProofEnvelopeAllOfDataBuilder b)]) = _$BotProofEnvelopeAllOfData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BotProofEnvelopeAllOfDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BotProofEnvelopeAllOfData> get serializer => _$BotProofEnvelopeAllOfDataSerializer();
}

class _$BotProofEnvelopeAllOfDataSerializer implements PrimitiveSerializer<BotProofEnvelopeAllOfData> {
  @override
  final Iterable<Type> types = const [BotProofEnvelopeAllOfData, _$BotProofEnvelopeAllOfData];

  @override
  final String wireName = r'BotProofEnvelopeAllOfData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BotProofEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'verified';
    yield serializers.serialize(
      object.verified,
      specifiedType: const FullType(BotProofEnvelopeAllOfDataVerifiedEnum),
    );
    yield r'expires_in';
    yield serializers.serialize(
      object.expiresIn,
      specifiedType: const FullType(int),
    );
    if (object.stepUpToken != null) {
      yield r'step_up_token';
      yield serializers.serialize(
        object.stepUpToken,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BotProofEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BotProofEnvelopeAllOfDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'verified':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BotProofEnvelopeAllOfDataVerifiedEnum),
          ) as BotProofEnvelopeAllOfDataVerifiedEnum;
          result.verified = valueDes;
          break;
        case r'expires_in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.expiresIn = valueDes;
          break;
        case r'step_up_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.stepUpToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BotProofEnvelopeAllOfData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BotProofEnvelopeAllOfDataBuilder();
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


class BotProofEnvelopeAllOfDataVerifiedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const BotProofEnvelopeAllOfDataVerifiedEnum true_ = _$botProofEnvelopeAllOfDataVerifiedEnum_true_;

  static Serializer<BotProofEnvelopeAllOfDataVerifiedEnum> get serializer => _$botProofEnvelopeAllOfDataVerifiedEnumSerializer;

  const BotProofEnvelopeAllOfDataVerifiedEnum._(String name): super(name);

  static BuiltSet<BotProofEnvelopeAllOfDataVerifiedEnum> get values => _$botProofEnvelopeAllOfDataVerifiedEnumValues;
  static BotProofEnvelopeAllOfDataVerifiedEnum valueOf(String name) => _$botProofEnvelopeAllOfDataVerifiedEnumValueOf(name);
}


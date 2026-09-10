//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'bot_step_up_error_envelope_all_of_errors_all_of_details.g.dart';

/// BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails
///
/// Properties:
/// * [challengeId] 
/// * [expiresAt] 
/// * [resendAfterSeconds] 
@BuiltValue()
abstract class BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails implements Built<BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails, BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder> {
  @BuiltValueField(wireName: r'challenge_id')
  String get challengeId;

  @BuiltValueField(wireName: r'expires_at')
  DateTime get expiresAt;

  @BuiltValueField(wireName: r'resend_after_seconds')
  int get resendAfterSeconds;

  BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails._();

  factory BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails([void updates(BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder b)]) = _$BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails> get serializer => _$BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsSerializer();
}

class _$BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsSerializer implements PrimitiveSerializer<BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails> {
  @override
  final Iterable<Type> types = const [BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails, _$BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails];

  @override
  final String wireName = r'BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'challenge_id';
    yield serializers.serialize(
      object.challengeId,
      specifiedType: const FullType(String),
    );
    yield r'expires_at';
    yield serializers.serialize(
      object.expiresAt,
      specifiedType: const FullType(DateTime),
    );
    yield r'resend_after_seconds';
    yield serializers.serialize(
      object.resendAfterSeconds,
      specifiedType: const FullType(int),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'challenge_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.challengeId = valueDes;
          break;
        case r'expires_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.expiresAt = valueDes;
          break;
        case r'resend_after_seconds':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.resendAfterSeconds = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BotStepUpErrorEnvelopeAllOfErrorsAllOfDetails deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BotStepUpErrorEnvelopeAllOfErrorsAllOfDetailsBuilder();
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



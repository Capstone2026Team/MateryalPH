//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'resend_bot_challenge_request.g.dart';

/// ResendBotChallengeRequest
///
/// Properties:
/// * [email] 
@BuiltValue()
abstract class ResendBotChallengeRequest implements Built<ResendBotChallengeRequest, ResendBotChallengeRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  ResendBotChallengeRequest._();

  factory ResendBotChallengeRequest([void updates(ResendBotChallengeRequestBuilder b)]) = _$ResendBotChallengeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(ResendBotChallengeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<ResendBotChallengeRequest> get serializer => _$ResendBotChallengeRequestSerializer();
}

class _$ResendBotChallengeRequestSerializer implements PrimitiveSerializer<ResendBotChallengeRequest> {
  @override
  final Iterable<Type> types = const [ResendBotChallengeRequest, _$ResendBotChallengeRequest];

  @override
  final String wireName = r'ResendBotChallengeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    ResendBotChallengeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    ResendBotChallengeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required ResendBotChallengeRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  ResendBotChallengeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = ResendBotChallengeRequestBuilder();
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



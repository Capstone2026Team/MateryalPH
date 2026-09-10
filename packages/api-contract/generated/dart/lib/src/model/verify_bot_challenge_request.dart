//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'verify_bot_challenge_request.g.dart';

/// VerifyBotChallengeRequest
///
/// Properties:
/// * [email] 
/// * [code] 
@BuiltValue()
abstract class VerifyBotChallengeRequest implements Built<VerifyBotChallengeRequest, VerifyBotChallengeRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'code')
  String get code;

  VerifyBotChallengeRequest._();

  factory VerifyBotChallengeRequest([void updates(VerifyBotChallengeRequestBuilder b)]) = _$VerifyBotChallengeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(VerifyBotChallengeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<VerifyBotChallengeRequest> get serializer => _$VerifyBotChallengeRequestSerializer();
}

class _$VerifyBotChallengeRequestSerializer implements PrimitiveSerializer<VerifyBotChallengeRequest> {
  @override
  final Iterable<Type> types = const [VerifyBotChallengeRequest, _$VerifyBotChallengeRequest];

  @override
  final String wireName = r'VerifyBotChallengeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    VerifyBotChallengeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    VerifyBotChallengeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required VerifyBotChallengeRequestBuilder result,
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
        case r'code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.code = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  VerifyBotChallengeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = VerifyBotChallengeRequestBuilder();
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



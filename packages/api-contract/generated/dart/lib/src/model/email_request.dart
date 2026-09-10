//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'email_request.g.dart';

/// EmailRequest
///
/// Properties:
/// * [email] 
@BuiltValue()
abstract class EmailRequest implements Built<EmailRequest, EmailRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  EmailRequest._();

  factory EmailRequest([void updates(EmailRequestBuilder b)]) = _$EmailRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(EmailRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<EmailRequest> get serializer => _$EmailRequestSerializer();
}

class _$EmailRequestSerializer implements PrimitiveSerializer<EmailRequest> {
  @override
  final Iterable<Type> types = const [EmailRequest, _$EmailRequest];

  @override
  final String wireName = r'EmailRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    EmailRequest object, {
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
    EmailRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required EmailRequestBuilder result,
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
  EmailRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = EmailRequestBuilder();
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



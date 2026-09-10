//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'password_reset_request.g.dart';

/// PasswordResetRequest
///
/// Properties:
/// * [email] 
/// * [code] 
/// * [password] 
/// * [passwordConfirmation] 
@BuiltValue()
abstract class PasswordResetRequest implements Built<PasswordResetRequest, PasswordResetRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'code')
  String get code;

  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'password_confirmation')
  String get passwordConfirmation;

  PasswordResetRequest._();

  factory PasswordResetRequest([void updates(PasswordResetRequestBuilder b)]) = _$PasswordResetRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasswordResetRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasswordResetRequest> get serializer => _$PasswordResetRequestSerializer();
}

class _$PasswordResetRequestSerializer implements PrimitiveSerializer<PasswordResetRequest> {
  @override
  final Iterable<Type> types = const [PasswordResetRequest, _$PasswordResetRequest];

  @override
  final String wireName = r'PasswordResetRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasswordResetRequest object, {
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
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    yield r'password_confirmation';
    yield serializers.serialize(
      object.passwordConfirmation,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    PasswordResetRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasswordResetRequestBuilder result,
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
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'password_confirmation':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.passwordConfirmation = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  PasswordResetRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasswordResetRequestBuilder();
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



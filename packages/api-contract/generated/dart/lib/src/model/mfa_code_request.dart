//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_code_request.g.dart';

/// MfaCodeRequest
///
/// Properties:
/// * [code] 
@BuiltValue()
abstract class MfaCodeRequest implements Built<MfaCodeRequest, MfaCodeRequestBuilder> {
  @BuiltValueField(wireName: r'code')
  String get code;

  MfaCodeRequest._();

  factory MfaCodeRequest([void updates(MfaCodeRequestBuilder b)]) = _$MfaCodeRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaCodeRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaCodeRequest> get serializer => _$MfaCodeRequestSerializer();
}

class _$MfaCodeRequestSerializer implements PrimitiveSerializer<MfaCodeRequest> {
  @override
  final Iterable<Type> types = const [MfaCodeRequest, _$MfaCodeRequest];

  @override
  final String wireName = r'MfaCodeRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaCodeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'code';
    yield serializers.serialize(
      object.code,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaCodeRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaCodeRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
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
  MfaCodeRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaCodeRequestBuilder();
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



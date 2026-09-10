//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'mfa_recovery_request.g.dart';

/// MfaRecoveryRequest
///
/// Properties:
/// * [recoveryCode] 
@BuiltValue()
abstract class MfaRecoveryRequest implements Built<MfaRecoveryRequest, MfaRecoveryRequestBuilder> {
  @BuiltValueField(wireName: r'recovery_code')
  String get recoveryCode;

  MfaRecoveryRequest._();

  factory MfaRecoveryRequest([void updates(MfaRecoveryRequestBuilder b)]) = _$MfaRecoveryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(MfaRecoveryRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<MfaRecoveryRequest> get serializer => _$MfaRecoveryRequestSerializer();
}

class _$MfaRecoveryRequestSerializer implements PrimitiveSerializer<MfaRecoveryRequest> {
  @override
  final Iterable<Type> types = const [MfaRecoveryRequest, _$MfaRecoveryRequest];

  @override
  final String wireName = r'MfaRecoveryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    MfaRecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'recovery_code';
    yield serializers.serialize(
      object.recoveryCode,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    MfaRecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required MfaRecoveryRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'recovery_code':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.recoveryCode = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  MfaRecoveryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = MfaRecoveryRequestBuilder();
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



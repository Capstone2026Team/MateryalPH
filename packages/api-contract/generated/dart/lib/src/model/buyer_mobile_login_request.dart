//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_mobile_login_request.g.dart';

/// Buyer-native login. The BUYER/MOBILE transport is selected by the server route and contains no CAPTCHA evidence.
///
/// Properties:
/// * [email] 
/// * [password] 
/// * [deviceId] 
/// * [riskProofToken] - Buyer-only proof returned after a server-issued email risk challenge; this is not CAPTCHA evidence.
@BuiltValue()
abstract class BuyerMobileLoginRequest implements Built<BuyerMobileLoginRequest, BuyerMobileLoginRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'device_id')
  String? get deviceId;

  /// Buyer-only proof returned after a server-issued email risk challenge; this is not CAPTCHA evidence.
  @BuiltValueField(wireName: r'risk_proof_token')
  String? get riskProofToken;

  BuyerMobileLoginRequest._();

  factory BuyerMobileLoginRequest([void updates(BuyerMobileLoginRequestBuilder b)]) = _$BuyerMobileLoginRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerMobileLoginRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerMobileLoginRequest> get serializer => _$BuyerMobileLoginRequestSerializer();
}

class _$BuyerMobileLoginRequestSerializer implements PrimitiveSerializer<BuyerMobileLoginRequest> {
  @override
  final Iterable<Type> types = const [BuyerMobileLoginRequest, _$BuyerMobileLoginRequest];

  @override
  final String wireName = r'BuyerMobileLoginRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerMobileLoginRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'password';
    yield serializers.serialize(
      object.password,
      specifiedType: const FullType(String),
    );
    if (object.deviceId != null) {
      yield r'device_id';
      yield serializers.serialize(
        object.deviceId,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.riskProofToken != null) {
      yield r'risk_proof_token';
      yield serializers.serialize(
        object.riskProofToken,
        specifiedType: const FullType(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerMobileLoginRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerMobileLoginRequestBuilder result,
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
        case r'password':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.password = valueDes;
          break;
        case r'device_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.deviceId = valueDes;
          break;
        case r'risk_proof_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.riskProofToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerMobileLoginRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerMobileLoginRequestBuilder();
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



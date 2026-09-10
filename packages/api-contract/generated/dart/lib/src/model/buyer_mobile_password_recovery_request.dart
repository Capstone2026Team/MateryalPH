//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_mobile_password_recovery_request.g.dart';

/// Buyer-native password recovery. The BUYER/MOBILE transport is selected by the server route and contains no CAPTCHA evidence.
///
/// Properties:
/// * [email] 
/// * [riskProofToken] - Buyer-only proof returned after a server-issued email risk challenge; this is not CAPTCHA evidence.
@BuiltValue()
abstract class BuyerMobilePasswordRecoveryRequest implements Built<BuyerMobilePasswordRecoveryRequest, BuyerMobilePasswordRecoveryRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  /// Buyer-only proof returned after a server-issued email risk challenge; this is not CAPTCHA evidence.
  @BuiltValueField(wireName: r'risk_proof_token')
  String? get riskProofToken;

  BuyerMobilePasswordRecoveryRequest._();

  factory BuyerMobilePasswordRecoveryRequest([void updates(BuyerMobilePasswordRecoveryRequestBuilder b)]) = _$BuyerMobilePasswordRecoveryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerMobilePasswordRecoveryRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerMobilePasswordRecoveryRequest> get serializer => _$BuyerMobilePasswordRecoveryRequestSerializer();
}

class _$BuyerMobilePasswordRecoveryRequestSerializer implements PrimitiveSerializer<BuyerMobilePasswordRecoveryRequest> {
  @override
  final Iterable<Type> types = const [BuyerMobilePasswordRecoveryRequest, _$BuyerMobilePasswordRecoveryRequest];

  @override
  final String wireName = r'BuyerMobilePasswordRecoveryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerMobilePasswordRecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
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
    BuyerMobilePasswordRecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerMobilePasswordRecoveryRequestBuilder result,
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
  BuyerMobilePasswordRecoveryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerMobilePasswordRecoveryRequestBuilder();
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



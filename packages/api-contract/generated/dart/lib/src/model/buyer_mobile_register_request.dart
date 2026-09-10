//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_mobile_register_request.g.dart';

/// Buyer-native registration. The BUYER/MOBILE transport is selected by the server route and contains no CAPTCHA evidence.
///
/// Properties:
/// * [fullName] 
/// * [email] 
/// * [mobileE164] 
/// * [password] 
/// * [passwordConfirmation] 
/// * [buyerType] 
/// * [companyName] 
/// * [termsAccepted] 
/// * [privacyAccepted] 
/// * [riskProofToken] - Buyer-only proof returned after a server-issued email risk challenge; this is not CAPTCHA evidence.
@BuiltValue()
abstract class BuyerMobileRegisterRequest implements Built<BuyerMobileRegisterRequest, BuyerMobileRegisterRequestBuilder> {
  @BuiltValueField(wireName: r'full_name')
  String get fullName;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'mobile_e164')
  String get mobileE164;

  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'password_confirmation')
  String get passwordConfirmation;

  @BuiltValueField(wireName: r'buyer_type')
  String get buyerType;

  @BuiltValueField(wireName: r'company_name')
  String? get companyName;

  @BuiltValueField(wireName: r'terms_accepted')
  BuyerMobileRegisterRequestTermsAcceptedEnum get termsAccepted;
  // enum termsAcceptedEnum {  true,  };

  @BuiltValueField(wireName: r'privacy_accepted')
  BuyerMobileRegisterRequestPrivacyAcceptedEnum get privacyAccepted;
  // enum privacyAcceptedEnum {  true,  };

  /// Buyer-only proof returned after a server-issued email risk challenge; this is not CAPTCHA evidence.
  @BuiltValueField(wireName: r'risk_proof_token')
  String? get riskProofToken;

  BuyerMobileRegisterRequest._();

  factory BuyerMobileRegisterRequest([void updates(BuyerMobileRegisterRequestBuilder b)]) = _$BuyerMobileRegisterRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerMobileRegisterRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerMobileRegisterRequest> get serializer => _$BuyerMobileRegisterRequestSerializer();
}

class _$BuyerMobileRegisterRequestSerializer implements PrimitiveSerializer<BuyerMobileRegisterRequest> {
  @override
  final Iterable<Type> types = const [BuyerMobileRegisterRequest, _$BuyerMobileRegisterRequest];

  @override
  final String wireName = r'BuyerMobileRegisterRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerMobileRegisterRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'full_name';
    yield serializers.serialize(
      object.fullName,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'mobile_e164';
    yield serializers.serialize(
      object.mobileE164,
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
    yield r'buyer_type';
    yield serializers.serialize(
      object.buyerType,
      specifiedType: const FullType(String),
    );
    if (object.companyName != null) {
      yield r'company_name';
      yield serializers.serialize(
        object.companyName,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'terms_accepted';
    yield serializers.serialize(
      object.termsAccepted,
      specifiedType: const FullType(BuyerMobileRegisterRequestTermsAcceptedEnum),
    );
    yield r'privacy_accepted';
    yield serializers.serialize(
      object.privacyAccepted,
      specifiedType: const FullType(BuyerMobileRegisterRequestPrivacyAcceptedEnum),
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
    BuyerMobileRegisterRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerMobileRegisterRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'full_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'mobile_e164':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.mobileE164 = valueDes;
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
        case r'buyer_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.buyerType = valueDes;
          break;
        case r'company_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.companyName = valueDes;
          break;
        case r'terms_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerMobileRegisterRequestTermsAcceptedEnum),
          ) as BuyerMobileRegisterRequestTermsAcceptedEnum;
          result.termsAccepted = valueDes;
          break;
        case r'privacy_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerMobileRegisterRequestPrivacyAcceptedEnum),
          ) as BuyerMobileRegisterRequestPrivacyAcceptedEnum;
          result.privacyAccepted = valueDes;
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
  BuyerMobileRegisterRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerMobileRegisterRequestBuilder();
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


class BuyerMobileRegisterRequestTermsAcceptedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const BuyerMobileRegisterRequestTermsAcceptedEnum true_ = _$buyerMobileRegisterRequestTermsAcceptedEnum_true_;

  static Serializer<BuyerMobileRegisterRequestTermsAcceptedEnum> get serializer => _$buyerMobileRegisterRequestTermsAcceptedEnumSerializer;

  const BuyerMobileRegisterRequestTermsAcceptedEnum._(String name): super(name);

  static BuiltSet<BuyerMobileRegisterRequestTermsAcceptedEnum> get values => _$buyerMobileRegisterRequestTermsAcceptedEnumValues;
  static BuyerMobileRegisterRequestTermsAcceptedEnum valueOf(String name) => _$buyerMobileRegisterRequestTermsAcceptedEnumValueOf(name);
}

class BuyerMobileRegisterRequestPrivacyAcceptedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const BuyerMobileRegisterRequestPrivacyAcceptedEnum true_ = _$buyerMobileRegisterRequestPrivacyAcceptedEnum_true_;

  static Serializer<BuyerMobileRegisterRequestPrivacyAcceptedEnum> get serializer => _$buyerMobileRegisterRequestPrivacyAcceptedEnumSerializer;

  const BuyerMobileRegisterRequestPrivacyAcceptedEnum._(String name): super(name);

  static BuiltSet<BuyerMobileRegisterRequestPrivacyAcceptedEnum> get values => _$buyerMobileRegisterRequestPrivacyAcceptedEnumValues;
  static BuyerMobileRegisterRequestPrivacyAcceptedEnum valueOf(String name) => _$buyerMobileRegisterRequestPrivacyAcceptedEnumValueOf(name);
}


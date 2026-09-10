//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_bot_protection_evidence.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'register_request.g.dart';

/// Vendor web registration. The WEB transport is selected by the server route.
///
/// Properties:
/// * [fullName] 
/// * [email] 
/// * [mobileE164] 
/// * [password] 
/// * [passwordConfirmation] 
/// * [businessName] 
/// * [termsAccepted] 
/// * [privacyAccepted] 
/// * [botProtection] - Vendor checkbox or accessible email fallback evidence.
@BuiltValue()
abstract class RegisterRequest implements Built<RegisterRequest, RegisterRequestBuilder> {
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

  @BuiltValueField(wireName: r'business_name')
  String get businessName;

  @BuiltValueField(wireName: r'terms_accepted')
  RegisterRequestTermsAcceptedEnum get termsAccepted;
  // enum termsAcceptedEnum {  true,  };

  @BuiltValueField(wireName: r'privacy_accepted')
  RegisterRequestPrivacyAcceptedEnum get privacyAccepted;
  // enum privacyAcceptedEnum {  true,  };

  /// Vendor checkbox or accessible email fallback evidence.
  @BuiltValueField(wireName: r'bot_protection')
  VendorBotProtectionEvidence? get botProtection;

  RegisterRequest._();

  factory RegisterRequest([void updates(RegisterRequestBuilder b)]) = _$RegisterRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(RegisterRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<RegisterRequest> get serializer => _$RegisterRequestSerializer();
}

class _$RegisterRequestSerializer implements PrimitiveSerializer<RegisterRequest> {
  @override
  final Iterable<Type> types = const [RegisterRequest, _$RegisterRequest];

  @override
  final String wireName = r'RegisterRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    RegisterRequest object, {
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
    yield r'business_name';
    yield serializers.serialize(
      object.businessName,
      specifiedType: const FullType(String),
    );
    yield r'terms_accepted';
    yield serializers.serialize(
      object.termsAccepted,
      specifiedType: const FullType(RegisterRequestTermsAcceptedEnum),
    );
    yield r'privacy_accepted';
    yield serializers.serialize(
      object.privacyAccepted,
      specifiedType: const FullType(RegisterRequestPrivacyAcceptedEnum),
    );
    if (object.botProtection != null) {
      yield r'bot_protection';
      yield serializers.serialize(
        object.botProtection,
        specifiedType: const FullType.nullable(VendorBotProtectionEvidence),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    RegisterRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required RegisterRequestBuilder result,
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
        case r'business_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.businessName = valueDes;
          break;
        case r'terms_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegisterRequestTermsAcceptedEnum),
          ) as RegisterRequestTermsAcceptedEnum;
          result.termsAccepted = valueDes;
          break;
        case r'privacy_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(RegisterRequestPrivacyAcceptedEnum),
          ) as RegisterRequestPrivacyAcceptedEnum;
          result.privacyAccepted = valueDes;
          break;
        case r'bot_protection':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(VendorBotProtectionEvidence),
          ) as VendorBotProtectionEvidence?;
          if (valueDes == null) continue;
          result.botProtection.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  RegisterRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = RegisterRequestBuilder();
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


class RegisterRequestTermsAcceptedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const RegisterRequestTermsAcceptedEnum true_ = _$registerRequestTermsAcceptedEnum_true_;

  static Serializer<RegisterRequestTermsAcceptedEnum> get serializer => _$registerRequestTermsAcceptedEnumSerializer;

  const RegisterRequestTermsAcceptedEnum._(String name): super(name);

  static BuiltSet<RegisterRequestTermsAcceptedEnum> get values => _$registerRequestTermsAcceptedEnumValues;
  static RegisterRequestTermsAcceptedEnum valueOf(String name) => _$registerRequestTermsAcceptedEnumValueOf(name);
}

class RegisterRequestPrivacyAcceptedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const RegisterRequestPrivacyAcceptedEnum true_ = _$registerRequestPrivacyAcceptedEnum_true_;

  static Serializer<RegisterRequestPrivacyAcceptedEnum> get serializer => _$registerRequestPrivacyAcceptedEnumSerializer;

  const RegisterRequestPrivacyAcceptedEnum._(String name): super(name);

  static BuiltSet<RegisterRequestPrivacyAcceptedEnum> get values => _$registerRequestPrivacyAcceptedEnumValues;
  static RegisterRequestPrivacyAcceptedEnum valueOf(String name) => _$registerRequestPrivacyAcceptedEnumValueOf(name);
}


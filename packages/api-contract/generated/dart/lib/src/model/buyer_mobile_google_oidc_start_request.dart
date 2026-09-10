//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_mobile_google_oidc_start_request.g.dart';

/// Buyer-native Google OIDC start. The BUYER/MOBILE transport is selected by the server route.
///
/// Properties:
/// * [mode] 
/// * [mobileE164] 
/// * [buyerType] 
/// * [companyName] 
/// * [termsAccepted] 
/// * [privacyAccepted] 
@BuiltValue()
abstract class BuyerMobileGoogleOidcStartRequest implements Built<BuyerMobileGoogleOidcStartRequest, BuyerMobileGoogleOidcStartRequestBuilder> {
  @BuiltValueField(wireName: r'mode')
  BuyerMobileGoogleOidcStartRequestModeEnum get mode;
  // enum modeEnum {  SIGN_IN,  SIGN_UP,  };

  @BuiltValueField(wireName: r'mobile_e164')
  String? get mobileE164;

  @BuiltValueField(wireName: r'buyer_type')
  String? get buyerType;

  @BuiltValueField(wireName: r'company_name')
  String? get companyName;

  @BuiltValueField(wireName: r'terms_accepted')
  bool? get termsAccepted;

  @BuiltValueField(wireName: r'privacy_accepted')
  bool? get privacyAccepted;

  BuyerMobileGoogleOidcStartRequest._();

  factory BuyerMobileGoogleOidcStartRequest([void updates(BuyerMobileGoogleOidcStartRequestBuilder b)]) = _$BuyerMobileGoogleOidcStartRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerMobileGoogleOidcStartRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerMobileGoogleOidcStartRequest> get serializer => _$BuyerMobileGoogleOidcStartRequestSerializer();
}

class _$BuyerMobileGoogleOidcStartRequestSerializer implements PrimitiveSerializer<BuyerMobileGoogleOidcStartRequest> {
  @override
  final Iterable<Type> types = const [BuyerMobileGoogleOidcStartRequest, _$BuyerMobileGoogleOidcStartRequest];

  @override
  final String wireName = r'BuyerMobileGoogleOidcStartRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerMobileGoogleOidcStartRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(BuyerMobileGoogleOidcStartRequestModeEnum),
    );
    if (object.mobileE164 != null) {
      yield r'mobile_e164';
      yield serializers.serialize(
        object.mobileE164,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.buyerType != null) {
      yield r'buyer_type';
      yield serializers.serialize(
        object.buyerType,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.companyName != null) {
      yield r'company_name';
      yield serializers.serialize(
        object.companyName,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.termsAccepted != null) {
      yield r'terms_accepted';
      yield serializers.serialize(
        object.termsAccepted,
        specifiedType: const FullType(bool),
      );
    }
    if (object.privacyAccepted != null) {
      yield r'privacy_accepted';
      yield serializers.serialize(
        object.privacyAccepted,
        specifiedType: const FullType(bool),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerMobileGoogleOidcStartRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerMobileGoogleOidcStartRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(BuyerMobileGoogleOidcStartRequestModeEnum),
          ) as BuyerMobileGoogleOidcStartRequestModeEnum;
          result.mode = valueDes;
          break;
        case r'mobile_e164':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.mobileE164 = valueDes;
          break;
        case r'buyer_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
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
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.termsAccepted = valueDes;
          break;
        case r'privacy_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.privacyAccepted = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerMobileGoogleOidcStartRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerMobileGoogleOidcStartRequestBuilder();
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


class BuyerMobileGoogleOidcStartRequestModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SIGN_IN')
  static const BuyerMobileGoogleOidcStartRequestModeEnum SIGN_IN = _$buyerMobileGoogleOidcStartRequestModeEnum_SIGN_IN;
  @BuiltValueEnumConst(wireName: r'SIGN_UP')
  static const BuyerMobileGoogleOidcStartRequestModeEnum SIGN_UP = _$buyerMobileGoogleOidcStartRequestModeEnum_SIGN_UP;

  static Serializer<BuyerMobileGoogleOidcStartRequestModeEnum> get serializer => _$buyerMobileGoogleOidcStartRequestModeEnumSerializer;

  const BuyerMobileGoogleOidcStartRequestModeEnum._(String name): super(name);

  static BuiltSet<BuyerMobileGoogleOidcStartRequestModeEnum> get values => _$buyerMobileGoogleOidcStartRequestModeEnumValues;
  static BuyerMobileGoogleOidcStartRequestModeEnum valueOf(String name) => _$buyerMobileGoogleOidcStartRequestModeEnumValueOf(name);
}


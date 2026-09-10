//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'google_oidc_start_request.g.dart';

/// Vendor/Admin browser Google OIDC start. The WEB transport is selected by the server route.
///
/// Properties:
/// * [portal] 
/// * [mode] 
/// * [mobileE164] 
/// * [businessName] 
/// * [termsAccepted] 
/// * [privacyAccepted] 
@BuiltValue()
abstract class GoogleOidcStartRequest implements Built<GoogleOidcStartRequest, GoogleOidcStartRequestBuilder> {
  @BuiltValueField(wireName: r'portal')
  GoogleOidcStartRequestPortalEnum get portal;
  // enum portalEnum {  VENDOR,  ADMIN,  };

  @BuiltValueField(wireName: r'mode')
  GoogleOidcStartRequestModeEnum get mode;
  // enum modeEnum {  SIGN_IN,  SIGN_UP,  };

  @BuiltValueField(wireName: r'mobile_e164')
  String? get mobileE164;

  @BuiltValueField(wireName: r'business_name')
  String? get businessName;

  @BuiltValueField(wireName: r'terms_accepted')
  bool? get termsAccepted;

  @BuiltValueField(wireName: r'privacy_accepted')
  bool? get privacyAccepted;

  GoogleOidcStartRequest._();

  factory GoogleOidcStartRequest([void updates(GoogleOidcStartRequestBuilder b)]) = _$GoogleOidcStartRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(GoogleOidcStartRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<GoogleOidcStartRequest> get serializer => _$GoogleOidcStartRequestSerializer();
}

class _$GoogleOidcStartRequestSerializer implements PrimitiveSerializer<GoogleOidcStartRequest> {
  @override
  final Iterable<Type> types = const [GoogleOidcStartRequest, _$GoogleOidcStartRequest];

  @override
  final String wireName = r'GoogleOidcStartRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    GoogleOidcStartRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'portal';
    yield serializers.serialize(
      object.portal,
      specifiedType: const FullType(GoogleOidcStartRequestPortalEnum),
    );
    yield r'mode';
    yield serializers.serialize(
      object.mode,
      specifiedType: const FullType(GoogleOidcStartRequestModeEnum),
    );
    if (object.mobileE164 != null) {
      yield r'mobile_e164';
      yield serializers.serialize(
        object.mobileE164,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.businessName != null) {
      yield r'business_name';
      yield serializers.serialize(
        object.businessName,
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
    GoogleOidcStartRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required GoogleOidcStartRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'portal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GoogleOidcStartRequestPortalEnum),
          ) as GoogleOidcStartRequestPortalEnum;
          result.portal = valueDes;
          break;
        case r'mode':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(GoogleOidcStartRequestModeEnum),
          ) as GoogleOidcStartRequestModeEnum;
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
        case r'business_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.businessName = valueDes;
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
  GoogleOidcStartRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = GoogleOidcStartRequestBuilder();
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


class GoogleOidcStartRequestPortalEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const GoogleOidcStartRequestPortalEnum VENDOR = _$googleOidcStartRequestPortalEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const GoogleOidcStartRequestPortalEnum ADMIN = _$googleOidcStartRequestPortalEnum_ADMIN;

  static Serializer<GoogleOidcStartRequestPortalEnum> get serializer => _$googleOidcStartRequestPortalEnumSerializer;

  const GoogleOidcStartRequestPortalEnum._(String name): super(name);

  static BuiltSet<GoogleOidcStartRequestPortalEnum> get values => _$googleOidcStartRequestPortalEnumValues;
  static GoogleOidcStartRequestPortalEnum valueOf(String name) => _$googleOidcStartRequestPortalEnumValueOf(name);
}

class GoogleOidcStartRequestModeEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'SIGN_IN')
  static const GoogleOidcStartRequestModeEnum SIGN_IN = _$googleOidcStartRequestModeEnum_SIGN_IN;
  @BuiltValueEnumConst(wireName: r'SIGN_UP')
  static const GoogleOidcStartRequestModeEnum SIGN_UP = _$googleOidcStartRequestModeEnum_SIGN_UP;

  static Serializer<GoogleOidcStartRequestModeEnum> get serializer => _$googleOidcStartRequestModeEnumSerializer;

  const GoogleOidcStartRequestModeEnum._(String name): super(name);

  static BuiltSet<GoogleOidcStartRequestModeEnum> get values => _$googleOidcStartRequestModeEnumValues;
  static GoogleOidcStartRequestModeEnum valueOf(String name) => _$googleOidcStartRequestModeEnumValueOf(name);
}


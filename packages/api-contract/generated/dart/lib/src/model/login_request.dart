//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_bot_protection_evidence.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'login_request.g.dart';

/// Vendor/Admin browser login. The WEB transport is selected by the server route.
///
/// Properties:
/// * [email] 
/// * [password] 
/// * [portal] 
/// * [botProtection] - Vendor web password login only; prohibited for Admin login.
@BuiltValue()
abstract class LoginRequest implements Built<LoginRequest, LoginRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'portal')
  LoginRequestPortalEnum get portal;
  // enum portalEnum {  VENDOR,  ADMIN,  };

  /// Vendor web password login only; prohibited for Admin login.
  @BuiltValueField(wireName: r'bot_protection')
  VendorBotProtectionEvidence? get botProtection;

  LoginRequest._();

  factory LoginRequest([void updates(LoginRequestBuilder b)]) = _$LoginRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(LoginRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<LoginRequest> get serializer => _$LoginRequestSerializer();
}

class _$LoginRequestSerializer implements PrimitiveSerializer<LoginRequest> {
  @override
  final Iterable<Type> types = const [LoginRequest, _$LoginRequest];

  @override
  final String wireName = r'LoginRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    LoginRequest object, {
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
    yield r'portal';
    yield serializers.serialize(
      object.portal,
      specifiedType: const FullType(LoginRequestPortalEnum),
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
    LoginRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required LoginRequestBuilder result,
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
        case r'portal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(LoginRequestPortalEnum),
          ) as LoginRequestPortalEnum;
          result.portal = valueDes;
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
  LoginRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = LoginRequestBuilder();
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


class LoginRequestPortalEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const LoginRequestPortalEnum VENDOR = _$loginRequestPortalEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const LoginRequestPortalEnum ADMIN = _$loginRequestPortalEnum_ADMIN;

  static Serializer<LoginRequestPortalEnum> get serializer => _$loginRequestPortalEnumSerializer;

  const LoginRequestPortalEnum._(String name): super(name);

  static BuiltSet<LoginRequestPortalEnum> get values => _$loginRequestPortalEnumValues;
  static LoginRequestPortalEnum valueOf(String name) => _$loginRequestPortalEnumValueOf(name);
}


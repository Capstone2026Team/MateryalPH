//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:materyalph_api_client/src/model/vendor_bot_protection_evidence.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'password_recovery_request.g.dart';

/// Vendor/Admin browser password recovery. The WEB transport is selected by the server route.
///
/// Properties:
/// * [email] 
/// * [portal] 
/// * [botProtection] - Vendor web password recovery only; prohibited for Admin recovery.
@BuiltValue()
abstract class PasswordRecoveryRequest implements Built<PasswordRecoveryRequest, PasswordRecoveryRequestBuilder> {
  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'portal')
  PasswordRecoveryRequestPortalEnum get portal;
  // enum portalEnum {  VENDOR,  ADMIN,  };

  /// Vendor web password recovery only; prohibited for Admin recovery.
  @BuiltValueField(wireName: r'bot_protection')
  VendorBotProtectionEvidence? get botProtection;

  PasswordRecoveryRequest._();

  factory PasswordRecoveryRequest([void updates(PasswordRecoveryRequestBuilder b)]) = _$PasswordRecoveryRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(PasswordRecoveryRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<PasswordRecoveryRequest> get serializer => _$PasswordRecoveryRequestSerializer();
}

class _$PasswordRecoveryRequestSerializer implements PrimitiveSerializer<PasswordRecoveryRequest> {
  @override
  final Iterable<Type> types = const [PasswordRecoveryRequest, _$PasswordRecoveryRequest];

  @override
  final String wireName = r'PasswordRecoveryRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    PasswordRecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'portal';
    yield serializers.serialize(
      object.portal,
      specifiedType: const FullType(PasswordRecoveryRequestPortalEnum),
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
    PasswordRecoveryRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required PasswordRecoveryRequestBuilder result,
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
        case r'portal':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(PasswordRecoveryRequestPortalEnum),
          ) as PasswordRecoveryRequestPortalEnum;
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
  PasswordRecoveryRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = PasswordRecoveryRequestBuilder();
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


class PasswordRecoveryRequestPortalEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'VENDOR')
  static const PasswordRecoveryRequestPortalEnum VENDOR = _$passwordRecoveryRequestPortalEnum_VENDOR;
  @BuiltValueEnumConst(wireName: r'ADMIN')
  static const PasswordRecoveryRequestPortalEnum ADMIN = _$passwordRecoveryRequestPortalEnum_ADMIN;

  static Serializer<PasswordRecoveryRequestPortalEnum> get serializer => _$passwordRecoveryRequestPortalEnumSerializer;

  const PasswordRecoveryRequestPortalEnum._(String name): super(name);

  static BuiltSet<PasswordRecoveryRequestPortalEnum> get values => _$passwordRecoveryRequestPortalEnumValues;
  static PasswordRecoveryRequestPortalEnum valueOf(String name) => _$passwordRecoveryRequestPortalEnumValueOf(name);
}


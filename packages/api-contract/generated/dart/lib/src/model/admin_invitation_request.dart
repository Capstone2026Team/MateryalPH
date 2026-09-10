//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'admin_invitation_request.g.dart';

/// AdminInvitationRequest
///
/// Properties:
/// * [token] 
/// * [fullName] 
/// * [password] 
/// * [passwordConfirmation] 
/// * [termsAccepted] 
/// * [privacyAccepted] 
@BuiltValue()
abstract class AdminInvitationRequest implements Built<AdminInvitationRequest, AdminInvitationRequestBuilder> {
  @BuiltValueField(wireName: r'token')
  String get token;

  @BuiltValueField(wireName: r'full_name')
  String get fullName;

  @BuiltValueField(wireName: r'password')
  String get password;

  @BuiltValueField(wireName: r'password_confirmation')
  String get passwordConfirmation;

  @BuiltValueField(wireName: r'terms_accepted')
  AdminInvitationRequestTermsAcceptedEnum get termsAccepted;
  // enum termsAcceptedEnum {  true,  };

  @BuiltValueField(wireName: r'privacy_accepted')
  AdminInvitationRequestPrivacyAcceptedEnum get privacyAccepted;
  // enum privacyAcceptedEnum {  true,  };

  AdminInvitationRequest._();

  factory AdminInvitationRequest([void updates(AdminInvitationRequestBuilder b)]) = _$AdminInvitationRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AdminInvitationRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AdminInvitationRequest> get serializer => _$AdminInvitationRequestSerializer();
}

class _$AdminInvitationRequestSerializer implements PrimitiveSerializer<AdminInvitationRequest> {
  @override
  final Iterable<Type> types = const [AdminInvitationRequest, _$AdminInvitationRequest];

  @override
  final String wireName = r'AdminInvitationRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AdminInvitationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'token';
    yield serializers.serialize(
      object.token,
      specifiedType: const FullType(String),
    );
    yield r'full_name';
    yield serializers.serialize(
      object.fullName,
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
    yield r'terms_accepted';
    yield serializers.serialize(
      object.termsAccepted,
      specifiedType: const FullType(AdminInvitationRequestTermsAcceptedEnum),
    );
    yield r'privacy_accepted';
    yield serializers.serialize(
      object.privacyAccepted,
      specifiedType: const FullType(AdminInvitationRequestPrivacyAcceptedEnum),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    AdminInvitationRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AdminInvitationRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.token = valueDes;
          break;
        case r'full_name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.fullName = valueDes;
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
        case r'terms_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminInvitationRequestTermsAcceptedEnum),
          ) as AdminInvitationRequestTermsAcceptedEnum;
          result.termsAccepted = valueDes;
          break;
        case r'privacy_accepted':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AdminInvitationRequestPrivacyAcceptedEnum),
          ) as AdminInvitationRequestPrivacyAcceptedEnum;
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
  AdminInvitationRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AdminInvitationRequestBuilder();
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


class AdminInvitationRequestTermsAcceptedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const AdminInvitationRequestTermsAcceptedEnum true_ = _$adminInvitationRequestTermsAcceptedEnum_true_;

  static Serializer<AdminInvitationRequestTermsAcceptedEnum> get serializer => _$adminInvitationRequestTermsAcceptedEnumSerializer;

  const AdminInvitationRequestTermsAcceptedEnum._(String name): super(name);

  static BuiltSet<AdminInvitationRequestTermsAcceptedEnum> get values => _$adminInvitationRequestTermsAcceptedEnumValues;
  static AdminInvitationRequestTermsAcceptedEnum valueOf(String name) => _$adminInvitationRequestTermsAcceptedEnumValueOf(name);
}

class AdminInvitationRequestPrivacyAcceptedEnum extends EnumClass {

  @BuiltValueEnumConst(wireName: r'true')
  static const AdminInvitationRequestPrivacyAcceptedEnum true_ = _$adminInvitationRequestPrivacyAcceptedEnum_true_;

  static Serializer<AdminInvitationRequestPrivacyAcceptedEnum> get serializer => _$adminInvitationRequestPrivacyAcceptedEnumSerializer;

  const AdminInvitationRequestPrivacyAcceptedEnum._(String name): super(name);

  static BuiltSet<AdminInvitationRequestPrivacyAcceptedEnum> get values => _$adminInvitationRequestPrivacyAcceptedEnumValues;
  static AdminInvitationRequestPrivacyAcceptedEnum valueOf(String name) => _$adminInvitationRequestPrivacyAcceptedEnumValueOf(name);
}


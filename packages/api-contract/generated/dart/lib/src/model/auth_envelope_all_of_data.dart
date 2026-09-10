//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/user_identity.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'auth_envelope_all_of_data.g.dart';

/// AuthEnvelopeAllOfData
///
/// Properties:
/// * [user] 
/// * [sessionId] 
/// * [accessToken] 
/// * [refreshToken] 
/// * [accessExpiresIn] 
/// * [refreshExpiresIn] 
/// * [mfaSetupRequired] 
/// * [mfaRequired] 
/// * [mfaEnrollmentRequired] 
/// * [challengeExpiresIn] 
/// * [recoveryCodes] - Present only immediately after enrollment or recovery; store offline because these values are not returned again.
@BuiltValue()
abstract class AuthEnvelopeAllOfData implements Built<AuthEnvelopeAllOfData, AuthEnvelopeAllOfDataBuilder> {
  @BuiltValueField(wireName: r'user')
  UserIdentity? get user;

  @BuiltValueField(wireName: r'session_id')
  String? get sessionId;

  @BuiltValueField(wireName: r'access_token')
  String? get accessToken;

  @BuiltValueField(wireName: r'refresh_token')
  String? get refreshToken;

  @BuiltValueField(wireName: r'access_expires_in')
  int? get accessExpiresIn;

  @BuiltValueField(wireName: r'refresh_expires_in')
  int? get refreshExpiresIn;

  @BuiltValueField(wireName: r'mfa_setup_required')
  bool? get mfaSetupRequired;

  @BuiltValueField(wireName: r'mfa_required')
  bool? get mfaRequired;

  @BuiltValueField(wireName: r'mfa_enrollment_required')
  bool? get mfaEnrollmentRequired;

  @BuiltValueField(wireName: r'challenge_expires_in')
  int? get challengeExpiresIn;

  /// Present only immediately after enrollment or recovery; store offline because these values are not returned again.
  @BuiltValueField(wireName: r'recovery_codes')
  BuiltList<String>? get recoveryCodes;

  AuthEnvelopeAllOfData._();

  factory AuthEnvelopeAllOfData([void updates(AuthEnvelopeAllOfDataBuilder b)]) = _$AuthEnvelopeAllOfData;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(AuthEnvelopeAllOfDataBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<AuthEnvelopeAllOfData> get serializer => _$AuthEnvelopeAllOfDataSerializer();
}

class _$AuthEnvelopeAllOfDataSerializer implements PrimitiveSerializer<AuthEnvelopeAllOfData> {
  @override
  final Iterable<Type> types = const [AuthEnvelopeAllOfData, _$AuthEnvelopeAllOfData];

  @override
  final String wireName = r'AuthEnvelopeAllOfData';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    AuthEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    if (object.user != null) {
      yield r'user';
      yield serializers.serialize(
        object.user,
        specifiedType: const FullType(UserIdentity),
      );
    }
    if (object.sessionId != null) {
      yield r'session_id';
      yield serializers.serialize(
        object.sessionId,
        specifiedType: const FullType(String),
      );
    }
    if (object.accessToken != null) {
      yield r'access_token';
      yield serializers.serialize(
        object.accessToken,
        specifiedType: const FullType(String),
      );
    }
    if (object.refreshToken != null) {
      yield r'refresh_token';
      yield serializers.serialize(
        object.refreshToken,
        specifiedType: const FullType(String),
      );
    }
    if (object.accessExpiresIn != null) {
      yield r'access_expires_in';
      yield serializers.serialize(
        object.accessExpiresIn,
        specifiedType: const FullType(int),
      );
    }
    if (object.refreshExpiresIn != null) {
      yield r'refresh_expires_in';
      yield serializers.serialize(
        object.refreshExpiresIn,
        specifiedType: const FullType(int),
      );
    }
    if (object.mfaSetupRequired != null) {
      yield r'mfa_setup_required';
      yield serializers.serialize(
        object.mfaSetupRequired,
        specifiedType: const FullType(bool),
      );
    }
    if (object.mfaRequired != null) {
      yield r'mfa_required';
      yield serializers.serialize(
        object.mfaRequired,
        specifiedType: const FullType(bool),
      );
    }
    if (object.mfaEnrollmentRequired != null) {
      yield r'mfa_enrollment_required';
      yield serializers.serialize(
        object.mfaEnrollmentRequired,
        specifiedType: const FullType(bool),
      );
    }
    if (object.challengeExpiresIn != null) {
      yield r'challenge_expires_in';
      yield serializers.serialize(
        object.challengeExpiresIn,
        specifiedType: const FullType(int),
      );
    }
    if (object.recoveryCodes != null) {
      yield r'recovery_codes';
      yield serializers.serialize(
        object.recoveryCodes,
        specifiedType: const FullType(BuiltList, [FullType(String)]),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    AuthEnvelopeAllOfData object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required AuthEnvelopeAllOfDataBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'user':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(UserIdentity),
          ) as UserIdentity?;
          if (valueDes == null) continue;
          result.user.replace(valueDes);
          break;
        case r'session_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.sessionId = valueDes;
          break;
        case r'access_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.accessToken = valueDes;
          break;
        case r'refresh_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.refreshToken = valueDes;
          break;
        case r'access_expires_in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.accessExpiresIn = valueDes;
          break;
        case r'refresh_expires_in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.refreshExpiresIn = valueDes;
          break;
        case r'mfa_setup_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.mfaSetupRequired = valueDes;
          break;
        case r'mfa_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.mfaRequired = valueDes;
          break;
        case r'mfa_enrollment_required':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(bool),
          ) as bool?;
          if (valueDes == null) continue;
          result.mfaEnrollmentRequired = valueDes;
          break;
        case r'challenge_expires_in':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.challengeExpiresIn = valueDes;
          break;
        case r'recovery_codes':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(BuiltList, [FullType(String)]),
          ) as BuiltList<String>?;
          if (valueDes == null) continue;
          result.recoveryCodes.replace(valueDes);
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  AuthEnvelopeAllOfData deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = AuthEnvelopeAllOfDataBuilder();
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



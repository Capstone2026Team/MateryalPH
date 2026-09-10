//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:materyalph_api_client/src/model/account_type.dart';
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'user_identity.g.dart';

/// UserIdentity
///
/// Properties:
/// * [id] 
/// * [name] 
/// * [email] 
/// * [accountType] 
@BuiltValue()
abstract class UserIdentity implements Built<UserIdentity, UserIdentityBuilder> {
  @BuiltValueField(wireName: r'id')
  String get id;

  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'email')
  String get email;

  @BuiltValueField(wireName: r'account_type')
  AccountType get accountType;
  // enum accountTypeEnum {  BUYER,  VENDOR,  ADMIN,  };

  UserIdentity._();

  factory UserIdentity([void updates(UserIdentityBuilder b)]) = _$UserIdentity;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(UserIdentityBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<UserIdentity> get serializer => _$UserIdentitySerializer();
}

class _$UserIdentitySerializer implements PrimitiveSerializer<UserIdentity> {
  @override
  final Iterable<Type> types = const [UserIdentity, _$UserIdentity];

  @override
  final String wireName = r'UserIdentity';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    UserIdentity object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(String),
    );
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'email';
    yield serializers.serialize(
      object.email,
      specifiedType: const FullType(String),
    );
    yield r'account_type';
    yield serializers.serialize(
      object.accountType,
      specifiedType: const FullType(AccountType),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    UserIdentity object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required UserIdentityBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.id = valueDes;
          break;
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'email':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.email = valueDes;
          break;
        case r'account_type':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(AccountType),
          ) as AccountType;
          result.accountType = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  UserIdentity deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = UserIdentityBuilder();
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



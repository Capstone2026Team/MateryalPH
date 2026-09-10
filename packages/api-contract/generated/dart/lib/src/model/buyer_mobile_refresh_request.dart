//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'buyer_mobile_refresh_request.g.dart';

/// BuyerMobileRefreshRequest
///
/// Properties:
/// * [refreshToken] 
@BuiltValue()
abstract class BuyerMobileRefreshRequest implements Built<BuyerMobileRefreshRequest, BuyerMobileRefreshRequestBuilder> {
  @BuiltValueField(wireName: r'refresh_token')
  String get refreshToken;

  BuyerMobileRefreshRequest._();

  factory BuyerMobileRefreshRequest([void updates(BuyerMobileRefreshRequestBuilder b)]) = _$BuyerMobileRefreshRequest;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(BuyerMobileRefreshRequestBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<BuyerMobileRefreshRequest> get serializer => _$BuyerMobileRefreshRequestSerializer();
}

class _$BuyerMobileRefreshRequestSerializer implements PrimitiveSerializer<BuyerMobileRefreshRequest> {
  @override
  final Iterable<Type> types = const [BuyerMobileRefreshRequest, _$BuyerMobileRefreshRequest];

  @override
  final String wireName = r'BuyerMobileRefreshRequest';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    BuyerMobileRefreshRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'refresh_token';
    yield serializers.serialize(
      object.refreshToken,
      specifiedType: const FullType(String),
    );
  }

  @override
  Object serialize(
    Serializers serializers,
    BuyerMobileRefreshRequest object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required BuyerMobileRefreshRequestBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'refresh_token':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.refreshToken = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  BuyerMobileRefreshRequest deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = BuyerMobileRefreshRequestBuilder();
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


